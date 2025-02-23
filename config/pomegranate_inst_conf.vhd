----------------------------------------------------------------------------------
-- Engineer: Zachary Pearce
-- 
-- Create Date: 23/02/2025
-- Module Name: pomegranate_conf
-- Project Name: Pomegranate
-- Description: Define parameters that are used to modify Pomegranate configured architectures
-- 
-- Dependencies: NA
-- 
-- Revision: 1.0
-- Revision Date: 23/02/2025
-- Notes: File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--package declarations
package pomegranate_conf is
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
end package pomegranate_conf;


--definition of package declarations
package body pomegranate_conf is
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
end package body pomegranate_conf;
