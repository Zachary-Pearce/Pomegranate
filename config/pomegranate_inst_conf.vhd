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

    constant word_w: NATURAL := 8; --the width of a word
    constant instruction_w: NATURAL := 32; --the width of instructions
    constant op_w: NATURAL := 5;    --the number of bits reserved for the opcode in instructions
    constant Raddr_w: NATURAL := 3; --the number of bits reserved for register addresses
    constant Daddr_w: NATURAL := 8; --the number of bits reserved for data addresses
    constant Iaddr_w: NATURAL := 8; --the number of bits reserved for instruction addresses
    
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

    ---- FORMAT CHECK FUNCTIONS ----
    -- these functions determine which instructions are in which format
    -- these functions must be synthesisable as they will be used in control unit logic

    -- example register format check
    function RFormatCheck (op: in opcodes) return std_logic;
    -- add other format checks here...
    
    ---- HELPER FUNCTIONS, DO NOT EDIT THESE ----
    --get operand function
    -- gets just the operand from a given standard logic vector
    -- as this forms connections between modules, there should be no decision logic here
    function GetOperand (slv; in std_logic_vector; instruction_format: in formats; operand: in operands) return std_logic_vector;
    
    --convert from binary (std_logic_vector) to opcode
    -- convert binary to integer and use it to index opcodes table
    function slv2op (slv: in std_logic_vector) return opcodes;
    
    --convert from opcode to binary (std_logic_vector)
    -- get the index of the given opcode and convert to binary
    function op2slv (op: in opcodes) return std_logic_vector;
end package pomegranate_inst_conf;


--definition of package declarations
package body pomegranate_inst_conf is
--==========================================================--
--VARIABLES                                                 --
--==========================================================--

    --operand width table
    type t_operand_width is array (operands) of NATURAL;
    constant operand_width: t_operand_width := (
        Raddr_w, Raddr_w, Raddr_w, word_w, word_w
    );

    --operand MSB index table
    -- a 2D array with a row for each instruction format
    -- each row contains the index of the MSB of the operands in the corresponding format
    type t_operand_table is array (formats, operands) of NATURAL;
    constant operand_table: t_operand_table := (
        (11, 27, 23, 0, 7, 0) --register format example
    );

--==========================================================--
--FUNCTIONS                                                 --
--==========================================================--

    ---- FORMAT CHECK FUNCTIONS ----
    -- these functions determine which instructions are in which format
    -- these functions must be synthesisable as they will be used in control unit logic

    -- example register format check
    function RFormatCheck (op: in opcodes) return std_logic is
    begin
        case op2slv(op) is
            --opcodes in this format are as follows: list the opcodes...
            when "00000" | "00001" => --replace the binary here
                return '1';
            when others =>
                return '0';
        end case;
    end function RFormatCheck;
    --add other format checks here...
    
    ---- HELPER FUNCTIONS, DO NOT EDIT THESE ----
    --get operand function
    -- gets just the operand from a given standard logic vector
    -- as this forms connections between modules, there should be no decision logic here
    function GetOperand (slv; in std_logic_vector; instruction_format: in formats; operand: in operands) return std_logic_vector is
        variable operand_index: natural;
    begin
        operand_index := operand_table(instruction_format, operand);
        return slv(operand_index downto operand_index-(operand_width(operand)-1));
    end function GetOperand;

    --convert from binary (std_logic_vector) to opcode
    -- convert binary to integer and use it to index opcodes table
    function slv2op (slv: in std_logic_vector) return opcodes is
    begin
        return opcodes'val(to_integer(unsigned(slv)));
    end function slv2op;

    --convert from opcode to binary (std_logic_vector)
    -- get the index of the given opcode and convert to binary
    function op2slv (op : in opcodes) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(opcodes'pos(op), op_w));
    end function op2slv;
end package body pomegranate_inst_conf;
