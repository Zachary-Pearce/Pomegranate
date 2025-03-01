----------------------------------------------------------------------------------
-- Engineer: Zachary Pearce
-- 
-- Create Date: 23/02/2025
-- Module Name: pomegranate_inst_conf
-- Project Name: Pomegranate
-- Description: Define parameters that are used to modify the instruction set architecture of Pomegranate configured architectures
-- 
-- Dependencies: NA
-- 
-- Revision: 1.0
-- Revision Date: 23/02/2025
-- Notes: File Created
----------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--package declarations
package pomegranate_inst_conf is
    ------ VARIABLES ------
    
    constant word_w: NATURAL := 8; --the width of the data bus
    constant instruction_w: NATURAL := 24; --the width of instructions
    constant op_w: NATURAL := 5;    --the number of bits reserved for the opcode in instructions
    constant Raddr_w: NATURAL := 3; --the number of bits reserved for register addresses
    constant Maddr_w: NATURAL := 8; --the number of bits reserved for memory addresses
    constant Iaddr_w: NATURAL := 8;--the number of bits reserved for instruction addresses
    
    --opcode mnemonics
    type opcode is
    (
        NOP,
        SIE,
        CIE,
        SCF,
        CCF,
        ADD,
        SUB,
        DAND,
        DOR,
        DNOT,
        DXOR,
        ADDI,
        SUBI,
        ANDI,
        ORI,
        LSL,
        LSR,
        CPY,
        LDR,
        LDRI,
        STR,
        STRI,
        PUSH,
        POP,
        BRA,
        BRZ,
        BRC,
        BRN,
        BRP,
        CALL,
        RET,
        RETI
    );
    
    --operands
    type operands is
    (
        Rd,
        Rs,
        Rt,
        Data_Address,
        Instruction_Address,
        Immediate
    );
    
    --instruction formats
    type formats is
    (
        register_format,
        branch_format,
        load_format,
        store_format
    );

    --INSTRUCTION FORMAT CHECK FUNCTIONS

    -- register format check
    function RFormatCheck (op: in opcode) return std_logic;

    -- branch format check
    function BFormatCheck (op: in opcode) return std_logic;

    -- load format check
    function LFormatCheck (op: in opcode) return std_logic;

    -- store format check
    function SFormatCheck (op: in opcode) return std_logic;

    --OPCODE FUNCTIONS
    
    -- address index function
    function AddressIndex (instruction_format: in formats := branch_format; operand: in operands := Rs) return NATURAL;
    
    -- convert from standard logic vector to opcode mnemonic
    function slv2op (slv: in std_logic_vector) return opcode;
    
    -- convert from opcode mnemonic to standard logic vector
    function op2slv (op: in opcode) return std_logic_vector;
end package pomegranate_inst_conf;


--definition of package declarations
package body pomegranate_inst_conf is
    ------ VARIABLES ------
    
    --the array used to translate a standard logic vector to it's respective opcode mnemonic
    type opcode_table is array (opcode) of std_logic_vector(op_w-1 downto 0);
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
        "11000",
        "11001",
        "11010",
        "11011",
        "11100",
        "11101",
        "11110",
        "11111"
    );
    
    --operand MSB index table
    type operand_table is array (operands) of natural;
    -- register format
    constant register_table: operand_table := (
        18, 10, 13, 0, 0, 7
    );
    -- branch format
    constant branch_table: operand_table := (
        0, 0, 0, 0, 7, 0
    );
    -- load format
    constant load_table: operand_table := (
        18, 0, 0, 7, 0, 15
    );
    -- store format
    constant store_table: operand_table := (
        0, 10, 0, 7, 0, 18
    );

    -- register format check
    function RFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: SIE, CIE, SFC, CCF, ADD, SUB, AND, OR, NOT, XOR, ADDI, SUBI, ANDI, ORI, LSL, LSR, CPY
            when "00001" | "00010" | "00011" | "00100" | "00101" | "00110" | "00111" | "01000" | "01001" | "01010" | "01011" | "01100" | "01101" | "01110" | "01111" | "10000" | "10001" =>
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
            --opcodes in this format are as follows: NOP, BRA, BRZ, BRC, BRN, BRP, CALL, RET, RETI
            when "00000" | "11000" | "11001" | "11010" | "11011" | "11100" | "11101" | "11110" | "11111" =>
                --return '1' to indicate we are in the branch format
                return '1';
            when others =>
                --otherwise return '0'
                return '0';
        end case;
    end function BFormatCheck;
    -- load format check
    function LFormatCheck (op: in opcode) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: LDR, LDRI, POP
            when "10010" | "10011" | "10111" =>
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
            --opcodes in this format are as follows: STR, STRI, PUSH
            when "10100" | "10101" | "10110" =>
                --return '1' to indicate we are in the store format
                return '1';
            when others =>
                --otherwise return '0'
                return '0';
        end case;
    end function SFormatCheck;
        
        
    ---- OPCODE FUNCTIONS ----
     
    -- address index return function
    function AddressIndex (instruction_format: in formats := branch_format; operand: in operands := Rs) return NATURAL is
    begin
        --check which instruction format the opcode is in
        -- then return the index of the MSB of the target operand
        case instruction_format is
            when register_format =>
                return register_table(operand);
            when branch_format =>
                return branch_table(operand);
            when load_format =>
                return load_table(operand);
            when store_format =>
                return store_table(operand);
        end case;
        report "format not found!" severity error;
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
end package body pomegranate_inst_conf;
