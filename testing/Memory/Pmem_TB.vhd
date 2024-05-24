----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2024 15:37:51
-- Design Name: 
-- Module Name: Pmem_TB - Behavioral
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pmem_TB is
end Pmem_TB;

architecture Behavioral of Pmem_TB is

--components
component ProgMemITF is
    generic (
        n: natural := 16;
        a: natural := 16;
        K: natural := 8
    );
    port (
        --control signals
        CLK, RST: in std_logic;
        PCS, PRE, PADR_MAR, PMDR_DAT: in std_logic;
        --data and address bus
        Pdatabus: inout std_logic_vector(n-1 downto 0);
        Paddrbus: in std_logic_vector(a-1 downto 0)
    );
end component ProgMemITF;

--constants
constant n: natural := 16;
constant a: natural := 16;
constant K: natural := 8;

--signals
signal CLK, RST: std_logic := '0';
signal PCS, PRE, PADR_MAR, PMDR_DAT: std_logic := '0';
signal Pdatabus: std_logic_vector(n-1 downto 0) := (others => '0');
signal Paddrbus: std_Logic_vector(a-1 downto 0) := (others => '0');

begin

--initialise device under test
DUT: ProgMemITF generic map (n,a,k) port map (CLK => CLK, RST => RST, PCS => PCS, PRE => PRE, PADR_MAR => PADR_MAR, PMDR_DAT => PMDR_DAT, Pdatabus => Pdatabus, Paddrbus => Paddrbus);

--reset
RST <= '1' after 1ns, '0' after 2ns;

--clock
CLK <= not CLK after 5ns;

--stimulus
process is
begin
    --stimulus 1, read from first memory location
    wait until rising_edge(CLK);
    Paddrbus <= "0000000000000000";
    PMDR_DAT <= '0';
    PADR_MAR <= '1';
    PCS <= '1';
    PRE <= '1';
    wait until rising_edge(CLK);
    PADR_MAR <= '0';
    PCS <= '0';
    PRE <= '0';
    PMDR_DAT <= '1';
    
    --stimulus 2, read from a second memory location
    wait until rising_edge(CLK);
    Paddrbus <= "0000000000000001";
    PMDR_DAT <= '0';
    PADR_MAR <= '1';
    PCS <= '1';
    PRE <= '1';
    wait until rising_edge(CLK);
    PADR_MAR <= '0';
    PCS <= '0';
    PRE <= '0';
    PMDR_DAT <= '1';
end process;

end Behavioral;
