library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

--package declarations
package cpu_defs is
    -- the opcode mnemonics that the processor can execute
    -- this is defined in an enumerator so we can map it to an equivalent standard logic vector
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
    
    constant word_w: NATURAL := 16; --the width of the data and address bus, or architecture width
    constant op_w: NATURAL := 5; --the number of bits reserved for the opcode in instructions
    constant Raddr_w: NATURAL := 1; --the number of bits reserved for register addresses
    constant Maddr_w: NATURAL := 8; --the number of bits reserved for memory addresses

    --we can fill the opcode with 0's when we don't need it
    constant rfill: std_logic_vector(op_w-1 downto 0) := (others => '0');

    --blank constant, n-bits of zero's
    constant zeros: std_logic_vector(word_w-1 downto 0) := (others => '0');

    -- OPCODE CONVERSION FUNCTION DECLARATIONS
    
    --convert from standard logic vector to opcode mnemonic
    function slv2op (slv: in std_logic_vector) return opcode;
    
    --convert from opcode mnemonic to standard logic vector
    function op2slv (op: in opcode) return std_logic_vector;


    -- INSTRUCTION FORMAT CHECK FUNCTION DECLARATIONS

    --register format check
    function RFormatCheck (op: in opcode) return std_logic;

    --branch format check
    function BFormatCheck (op: in opcode) return std_logic;

    --immediate format check
    function IFormatCheck (op: in opcode) return std_logic;

    --I/O format check
    function IOFormatCheck (op: in opcode) return std_logic;

    --load format check
    function LFormatCheck (op: in opcode) return std_logic;

    --store format check
    function SFormatCheck (op: in opcode) return std_logic;

    -- MISCELLANEOUS FUNCTIONS
    
    --address index return function
    function AddressIndex (addrbus: in std_logic_vector(word_w-1 downto 0) := (others => '0'); addr: in character := 's') return NATURAL;
end package cpu_defs;


--definition of package declarationsd
package body cpu_defs is
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
    
    
    -- OPCODE CONVERSION FUNCTION DEFINITIONS
    
    --convert from binary (std_logic_vector) to opcode
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
    
    --convert from opcode to binary (std_logic_vector)
    function op2slv (op : in opcode) return std_logic_vector is
    begin
        return trans_table(op);
    end function op2slv;


    -- INSTRUCTION FORMAT CHECK FUNCTION DECLARATIONS

    --register format check
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

    --branch format check
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

    --immediate format check
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

    --I/O format check
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

    --load format check
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

    --store format check
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

    -- MISCELLANEOUS FUNCTIONS
    
    --address index return function
    function AddressIndex (addrbus: in std_logic_vector(word_w-1 downto 0) := (others => '0'); addr: in character := 's') return NATURAL is
        --a constant to represent the opcode of the addrbus content
        constant op: opcode := slv2op(addrbus(word_w-1 downto word_w-op_w));
    begin
        --check which instruction format the opcode is in
        -- in some cases, architecture widths lead to special cases...
        --  we test these special cases with the register address width as the architecture width will always be 8 times the register address width
        if RFormatCheck(op) = '1' then --register format
            if addr = 'd' then
                return word_w-op_w;
            elsif addr = 's' then
                return word_w-op_w-Raddr_w;
            elsif addr = 't' then
                return word_w-op_w-(2*Raddr_w);
            end if;
        elsif BFormatCheck(op) = '1' then --branch format
            if addr = 's' then
                return word_w-op_w;
            elsif addr = 'P' then
                if (Raddr_w*8 = 8) then
                    --we minus 2 due to the "00" padding in the instruction
                    return word_w-op_w-Raddr_w-2;
                else
                    return word_w-op_w-Raddr_w;
                end if;
            end if;
        elsif IFormatCheck(op) = '1' then --immediate format
            if addr = 'd' then
                return word_w-op_w;
            elsif addr = 's' then
                return word_w-op_w-Raddr_w;
            end if;
        elsif IOFormatCheck(op) = '1' then --I/O format
            if (Raddr_w*8 = 16) then
                --if the architecture is 16-bit then the adresses are stored in the same space
                return word_w-op_w;
            else
                if addr = 'd' then
                    return word_w-op_w;
                elsif addr = 't' then
                    return word_w-op_w-Raddr_w;
                end if;
            end if;
        elsif LFormatCheck(op) = '1' then --load format
            if addr = 'd' then
                return word_w-op_w;
            elsif addr = 'D' then
                if (Raddr_w*8 = 8) then
                    --we minus 2 due to the "00" padding in the instruction
                    return word_w-op_w-Raddr_w-2;
                else
                    return word_w-op_w-Raddr_w;
                end if;
            end if;
        elsif SFormatCheck(op) = '1' then --store format
            if addr = 's' then
                return word_w-op_w;
            elsif addr = 'D' then
                if (Raddr_w*8 = 8) then
                    --we minus 2 due to the "00" padding in the instruction
                    return word_w-op_w-Raddr_w-2;
                else
                    return word_w-op_w-Raddr_w;
                end if;
            end if;
        else -- if it is a no operation (NOP) instruction
            return word_w;
        end if;
        return word_w; --on a fail to fulfill conditions return the archiecture width
    end function AddressIndex;
end package body cpu_defs;
