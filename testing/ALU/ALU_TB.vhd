----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2024 00:45:20
-- Design Name: 
-- Module Name: ALU_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is
--components
component ALU is
    generic (
        n: natural := 8 --data width
    );
    Port (
        ALU_EN, ALU_IMM: in std_logic;
        ALU_OP: in std_logic_vector(2 downto 0);
        Rs, Rt, Immediate: in std_logic_vector(n-1 downto 0);
        Z: out std_logic_vector(n-1 downto 0);
        C_flag, Z_flag, N_flag, P_flag: out std_logic
    );
end component ALU;

--naturals
constant nn: natural := 8;

--signals
signal ALU_EN, ALU_IMM: std_logic := '0';
signal ALU_OP: std_logic_vector(2 downto 0) := "000";
signal databus, Immediate: std_logic_vector(nn-1 downto 0) := (others => '0');
signal Rs, Rt: std_logic_vector(nn-1 downto 0) := (others => '0');
signal C, Z, N, P: std_logic := '0';

begin

--instantiate unit under test
DUT: ALU generic map (nn) port map (
    ALU_EN => ALU_EN, ALU_IMM => ALU_IMM, ALU_OP => ALU_OP, Rs => Rs, Rt => Rt,
    Immediate => Immediate, Z => databus, C_flag => C, Z_flag => Z, N_flag => N, P_flag => P
);

--stimuli
process is
begin
    wait for 10ns;
    --first stimuli - arithmetic register operation
    Rs <= "00110010";
    Rt <= "10111001";
    databus <= "ZZZZZZZZ";
    Immediate <= "ZZZZZZZZ";
    ALU_EN <= '1';
    ALU_IMM <= '0';
    ALU_OP <= "001";

    wait for 10ns;
    --second stimuli - arithmetic operation with immediate input
    Rs <= "00110010";
    Rt <= "10111001";
    databus <= "ZZZZZZZZ";
    Immediate <= "00001110";
    ALU_EN <= '1';
    ALU_IMM <= '1';
    ALU_OP <= "000";
    
    wait for 10ns;
    --third stimuli - logical register operation
    Rs <= "00110010";
    Rt <= "10111001";
    databus <= "ZZZZZZZZ";
    Immediate <= "ZZZZZZZZ";
    ALU_EN <= '1';
    ALU_IMM <= '0';
    ALU_OP <= "011";
    
    wait for 10ns;
    --fourth stimuli - logical operation with immediate input
    Rs <= "00110010";
    Rt <= "10111001";
    databus <= "ZZZZZZZZ";
    Immediate <= "00001110";
    ALU_EN <= '1';
    ALU_IMM <= '1';
    ALU_OP <= "010";
end process;

end Behavioral;
