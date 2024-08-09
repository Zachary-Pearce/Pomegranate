library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--package declarations
package pomegranate_conf is
    ------ VARIABLES ------
    
    constant word_w: NATURAL := 32; --the width of the data and address bus, or architecture width
    constant op_w: NATURAL := 5;    --the number of bits reserved for the opcode in instructions
    constant Raddr_w: NATURAL := 5; --the number of bits reserved for register addresses
    constant Maddr_w: NATURAL := 8; --the number of bits reserved for memory addresses
    
    --opcode mnemonics
    type opcode is
    (
        NOP,
        ADD,
        SUB,
        DAND,
        DOR,
        DNOT,
        DXOR,
        MOV,
        LDR,
        STR,
        BRA,
        BRZ,
        BRP,
        CMP,
        INPA,
        INPB,
        ADOUT,
        AOUTC,
        BDOUT,
        BOUTC,
        ADDI,
        SUBI,
        ANDI,
        ORI,
        XORI
    );
    
    --operands
    type operands is
    (
        Rd,
        Rs,
        Rt,
        data_address,
        prgm_address,
        imm,
        char
    );
    
    ------ FUNCTIONS AND CONSTANTS ------

    --blank constant, n-bits of zero's
    -- ideal for resetting large memories
    constant zeros: std_logic_vector(word_w-1 downto 0) := (others => '0');


    --INSTRUCTION FORMAT CHECK FUNCTIONS

    -- register format check
    function RFormatCheck (op: in opcode) return std_logic;

    -- branch format check
    function BFormatCheck (op: in opcode) return std_logic;

    -- immediate format check
    function IFormatCheck (op: in opcode) return std_logic;

    -- I/O format check
    function IOFormatCheck (op: in opcode) return std_logic;

    -- load format check
    function LFormatCheck (op: in opcode) return std_logic;

    -- store format check
    function SFormatCheck (op: in opcode) return std_logic;

    --OPCODE FUNCTIONS
    
    -- address index function
    function AddressIndex (addrbus: in std_logic_vector(word_w-1 downto 0) := (others => '0'); operand: in operands := Rs) return NATURAL;
    
    -- convert from standard logic vector to opcode mnemonic
    function slv2op (slv: in std_logic_vector) return opcode;
    
    -- convert from opcode mnemonic to standard logic vector
    function op2slv (op: in opcode) return std_logic_vector;
end package pomegranate_conf;


--definition of package declarations
package body pomegranate_conf is
    ------ VARIABLES ------
    
    --the array used to translate a standard logic vector to it's respective opcode mnemonic
    type optable is array (opcode) of std_logic_vector(op_w-1 downto 0);
    constant trans_table: optable := (
        "00000",
        "00001",
        "00010",
        "00011",
        "00100",
        "00101",
        "00110",
        "00111",
        "01000",
        "01001",
        "01010",
        "01011",
        "01100",
        "01101",
        "01110",
        "01111",
        "10000",
        "10001",
        "10010",
        "10011",
        "10100",
        "10101",
        "10110",
        "10111",
        "11000"
    );
    
    --operand MSB index table
    type operand_table is array (operands) of natural;
    -- branch format
    constant branch_table: operand_table := (
        0, 10, 0, 0, 7, 0, 0
    );
    -- register format
    constant register_table: operand_table := (
        27, 22, 17, 0, 0, 0, 0
    );
    -- immediate format
    constant immediate_table: operand_table := (
        10, 9, 0, 0, 0, 7, 0
    );
    -- I/O format
    constant IO_table: operand_table := (
        10, 9, 0, 0, 0, 0, 7
    );
    -- load format
    constant load_table: operand_table := (
        10, 0, 0, 7, 0, 0, 0
    );
    -- store format
    constant store_table: operand_table := (
        0, 10, 0, 7, 0, 0, 0
    );
    
    ------ FUNCTIONS ------

    --INSTRUCTION FORMAT CHECK FUNCTION DECLARATIONS

    -- register format check
    function RFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: ADD, SUB, DAND, DOR, DNOT, DXOR, MOV
            when "00001" | "00010" | "00011" | "00100" | "00101" | "00110" | "00111" =>
                --return '1' to specify we are in the register format
                return '1';
            when others =>
                --otherwise we return '0'
                return '0';
        end case;
    end function RFormatCheck;

    -- branch format check
    function BFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: BRA, BRZ, BRP, CMP
            when "01010" | "01011" | "01100" | "01101" =>
                --return '1' to indicate we are in the branch format
                return '1';
            when others =>
                --otherwise return '0'
                return '0';
        end case;
    end function BFormatCheck;

    -- immediate format check
    function IFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: ADDI, SUBI, ANDI, ORI, XORI
            when "10100" | "10101" | "10110" | "10111" | "11000" =>
                --return '1' to indicate we are in the immediate format
                return '1';
            when others =>
                --otherwise return '0'
                return '0';
        end case;
    end function IFormatCheck;

    -- I/O format check
    function IOFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: INPA, INPB, AOUT, AOUTC, BOUT, BOUTC
            when "01110" | "01111" | "10000" | "10001" | "10010" | "10011" =>
                --return '1' to indicate we are in the IO format
                return '1';
            when others =>
                --otherwise return '0'
                return '0';
        end case;
    end function IOFormatCheck;

    -- load format check
    function LFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: LDR
            when "01000" =>
                --return '1' to indicate we are in the load format
                return '1';
            when others =>
                --otherwise return '0'
                return '0';
        end case;
    end function LFormatCheck;

    -- store format check
    function SFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: STR
            when "01001" =>
                --return '1' to indicate we are in the store format
                return '1';
            when others =>
                --otherwise return '0'
                return '0';
        end case;
    end function SFormatCheck;

    --OPCODE FUNCTIONS
    
    -- address index return function
    function AddressIndex (addrbus: in std_logic_vector(word_w-1 downto 0) := (others => '0'); operand: in operands := Rs) return NATURAL is
        --a constant to represent the opcode of the addrbus content
        constant op: opcode := slv2op(addrbus(word_w-1 downto word_w-op_w));
    begin
        --check which instruction format the opcode is in
        -- then return the index of the MSB of the target operand
        if RFormatCheck(op) = '1' then --register format
            return register_table(operand);
        elsif BFormatCheck(op) = '1' then --branch format
            return branch_table(operand);
        elsif IFormatCheck(op) = '1' then --immediate format
            return immediate_table(operand);
        elsif IOFormatCheck(op) = '1' then --I/O format
            return IO_table(operand);
        elsif LFormatCheck(op) = '1' then --load format
            return load_table(operand);
        elsif SFormatCheck(op) = '1' then --store format
            return store_table(operand);
        else -- if it is a no operation (NOP) instruction
            return word_w;
        end if;
        return word_w; --on a fail to fulfill conditions return the archiecture width
    end function AddressIndex;
    
    -- convert from binary (std_logic_vector) to opcode
    function slv2op (slv: in std_logic_vector) return opcode is
        variable transop: opcode;
    begin
        --this is the way that makes the most sense, however some synthesis tools don't support it.
        --  the other method would be to use a case statement but it is harder to edit the instruction set.
        for i in opcode loop
            if slv = trans_table(i) then
                transop := i;
            end if;
        end loop;
        return transop;
    end function slv2op;
    
    -- convert from opcode to binary (std_logic_vector)
    function op2slv (op : in opcode) return std_logic_vector is
    begin
        return trans_table(op);
    end function op2slv;
end package body pomegranate_conf;
