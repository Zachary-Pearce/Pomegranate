----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2024 02:46:51
-- Design Name: 
-- Module Name: Top_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.pomegranate_conf.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_TB is
--  Port ( );
end Top_TB;

architecture Behavioral of Top_TB is

--components
component Base_Top is
    Port (
        CLK, RST: in std_logic;
        --bus outputs for testing
        Data_Address_Bus: inout std_logic_vector(Maddr_w-1 downto 0);
        Data_Bus: inout std_logic_vector(word_w-1 downto 0);
        Instruction_Bus: inout std_logic_vector(instruction_w-1 downto 0);
        Instruction_Address_Bus: inout std_logic_vector(Iaddr_w-1 downto 0);
        --opcode output for testing
        op: out opcode;
        --contron signal output for testing
        ALU_EN1, ALU_IMM1, MEM_WE1, DAT_MEM1, PC_INC1, DAT_PC1, PC_LDA1, RF_WE1, DAT_RF1, STK_EN1, STK_INC1: out std_logic;
        ALU_OP1: out std_logic_vector(2 downto 0);
        SRC_IMM1: out std_logic_vector(1 downto 0)
    );
end component Base_Top;

--signals
signal CLK, RST: std_logic := '0';
signal Data_Address_Bus: std_logic_vector(Maddr_w-1 downto 0) := (others => '0');
signal Data_Bus: std_logic_vector(word_w-1 downto 0) := (others => '0');
signal Instruction_Bus: std_logic_vector(instruction_w-1 downto 0) := (others => '0');
signal Instruction_Address_Bus: std_logic_vector(Iaddr_w-1 downto 0) := (others => '0');
signal op: opcode := NOP;
signal ALU_EN1, ALU_IMM1, MEM_WE1, DAT_MEM1, PC_INC1, DAT_PC1, PC_LDA1, RF_WE1, DAT_RF1, STK_EN1, STK_INC1: std_logic;
signal ALU_OP1: std_logic_vector(2 downto 0);
signal SRC_IMM1: std_logic_vector(1 downto 0);

begin

--initialise component
DUT: Base_Top port map (
    CLK => CLK, RST => RST,
    Data_Address_Bus => Data_Address_Bus,
    Data_Bus => Data_Bus,
    Instruction_Bus => Instruction_Bus,
    Instruction_Address_Bus => Instruction_Address_Bus,
    op => op,
    ALU_EN1 => ALU_EN1, ALU_IMM1 => ALU_IMM1, MEM_WE1 => MEM_WE1, DAT_MEM1 => DAT_MEM1, PC_INC1 => PC_INC1, DAT_PC1 => DAT_PC1, PC_LDA1 => PC_LDA1,
    RF_WE1 => RF_WE1, DAT_RF1 => DAT_RF1, STK_EN1 => STK_EN1, STK_INC1 => STK_INC1,
    ALU_OP1 => ALU_OP1,
    SRC_IMM1 => SRC_IMM1
);

--reset
RST <= '1' after 1ns, '0' after 2ns;
--clock
CLK <= not CLK after 5ns;

end Behavioral;
