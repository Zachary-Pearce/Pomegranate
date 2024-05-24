----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2023 12:23:04
-- Design Name: 
-- Module Name: PC_TB - Behavioral
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
use WORK.cpu_defs.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_TB is
end PC_TB;

architecture Behavioral of PC_TB is

constant n: natural := 16;
constant a: natural := 16;
constant k: natural := 8;

signal LDA_PC, INC_PC, PC_ADR: std_logic := '0';

signal CLK, RST: std_logic := '0';
signal count: unsigned(n-1 downto 0) := (others => '0');
signal databus: std_logic_vector(n-1 downto 0) := (others => '0');
signal adrbus: std_logic_vector(n-1 downto 0) := (others => '0');

component PC is
    generic(
        n: natural := 16; --data bus width
        a: natural := 16; --address bus width
        k: natural := 8  --width of register
    );
    port(
        --control signals
        CLK, RST: in std_logic;
        LDA_PC, INC_PC, PC_ADR: in std_logic;
        --data bus and address bus
        Pdatabus: in std_logic_vector(n-1 downto 0);
        Paddrbus: out std_logic_vector(a-1 downto 0);
        countOut: out unsigned(n-1 downto 0)
    );
end component PC;

begin

DUT: PC generic map (n, a, k) port map (CLK, RST, LDA_PC, INC_PC, PC_ADR, databus, adrbus, count);

RST <= '1' after 1ns, '0' after 2ns;
CLK <= not CLK after 5ns;

process is
begin
    --stimulus will scale with the architecture width
    --first stimulus - increment test
    INC_PC <= '1';
    LDA_PC <= '1';
    PC_ADR <= '0';
    wait for 10ns;
    
    --second stimulus - load test
    databus <= std_logic_vector(to_unsigned(5, n)); --load addres of 5 onto the address bus
    LDA_PC <= '1'; --get PC to load value on the data bus
    INC_PC <= '0';
    PC_ADR <= '0';
    wait for 10ns;
    
    --third stimulus - drive address bus
    LDA_PC <= '0';
    INC_PC <= '0';
    PC_ADR <= '1';
    wait for 10ns;
end process;


end Behavioral;
