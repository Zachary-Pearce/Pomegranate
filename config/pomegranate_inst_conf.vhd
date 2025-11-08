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
--==========================================================--
--VARIABLES                                                 --
--==========================================================--

    constant word_w: NATURAL := 8; --the width of the data bus
    constant instruction_w: NATURAL := 32; --the width of instructions
    constant op_w: NATURAL := 5;    --the number of bits reserved for the opcode in instructions
    constant Raddr_w: NATURAL := 3; --the number of bits reserved for register addresses
    constant Maddr_w: NATURAL := 8; --the number of bits reserved for memory addresses
    constant Iaddr_w: NATURAL := 8;--the number of bits reserved for instruction addresses
    
    type opcodes is
    (
        --your opcodes go here...
    );
    
    type operands is
    (
        --your operands go here...
    );

    type formats is
    (
        --your instruction formats go here...
    );

--==========================================================--
--FUNCTIONS                                                 --
--==========================================================--

    --INSTRUCTION FORMAT CHECK FUNCTIONS

    -- register format check
    function RFormatCheck (op: in opcodes) return std_logic;

    -- branch format check
    function BFormatCheck (op: in opcodes) return std_logic;

    -- load format check
    function LFormatCheck (op: in opcodes) return std_logic;

    -- store format check
    function SFormatCheck (op: in opcodes) return std_logic;

    --OPCODE FUNCTIONS
    
    -- address index function
    function AddressIndex (instruction_format: in formats := branch_format; operand: in operands := Rs) return NATURAL;
    
    -- convert from standard logic vector to opcode mnemonic
    function slv2op (slv: in std_logic_vector) return opcodes;
    
    -- convert from opcode mnemonic to standard logic vector
    function op2slv (op: in opcodes) return std_logic_vector;
end package pomegranate_inst_conf;


--definition of package declarations
package body pomegranate_inst_conf is
--==========================================================--
--VARIABLES                                                 --
--==========================================================--

    --operand MSB index table
    --each operand index table goes in order of operands enum
    --there is a table for each operand format, 0 used when operand is not present
    type operand_table is array (operands) of natural;
    -- example table with 6 operands...
    constant register_table: operand_table := (
        11, 27, 23, 0, 7, 0
    );
    --add more tables here...

--==========================================================--
--FUNCTIONS                                                 --
--==========================================================--

    -- register format check
    function RFormatCheck (op: in opcodes) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: list the opcodes...
            --replace the binary here
            when "00000" | "00001" =>
                return '1';
            when others =>
                return '0';
        end case;
    end function RFormatCheck;
    -- branch format check
    function BFormatCheck (op: in opcodes) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: list the opcodes...
            --replace the binary here
            when "00010" | "00011" =>
                return '1';
            when others =>
                return '0';
        end case;
    end function BFormatCheck;
    -- addressing format check
    function AFormatCheck (op: in opcodes) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: list the opcodes...
            --replace the binary here
            when "00100" | "00101" =>
                return '1';
            when others =>
                return '0';
        end case;
    end function AFormatCheck;
    
    ---- OPCODE FUNCTIONS ----
     
    -- address index return function
    function AddressIndex (instruction_format: in formats := branch_format; operand: in operands := Rs) return NATURAL is
    begin
        --check which instruction format the opcode is in
        -- then return the index of the MSB of the target operand
        case instruction_format is
            when register_format =>
                return register_table(operand);
            --add other format checks here...
        end case;
        report "format not found!" severity error;
        return word_w; --on a fail to fulfill conditions return the word width
    end function AddressIndex;
    
    -- convert from binary (std_logic_vector) to opcode
    function slv2op (slv: in std_logic_vector) return opcodes is
    begin
        return opcodes'val(to_integer(unsigned(slv)));
    end function slv2op;

    -- convert from opcode to binary (std_logic_vector)
    function op2slv (op : in opcodes) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(opcodes'pos(op), op_w));
    end function op2slv;
end package body pomegranate_inst_conf;
