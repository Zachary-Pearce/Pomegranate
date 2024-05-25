----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2024 19:50:03
-- Design Name: 
-- Module Name: Dmem_TB - Behavioral
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

entity Dmem_TB is
end Dmem_TB;

architecture Behavioral of Dmem_TB is

--components
component DataMemITF is
    generic (
        n: natural := 8;  --data bus width
        a: natural := 16; --address bus width
        k: natural := 8   --address width
    );
    port (
        --control signals
        CLK, RST: in std_logic;
        DCS, DWE, DRE, DADR_MAR, DMDR_DAT, DDAT_MDR: in std_logic;
        --data and address bus
        Ddatabus: inout std_logic_vector(n-1 downto 0);
        Daddrbus: in std_logic_vector(a-1 downto 0)
    );
end component DataMemITF;

--constants
constant n: natural := 16;
constant a: natural := 16;
constant K: natural := 8;

--signals
signal CLK, RST: std_logic := '0';
signal DCS, DWE, DRE, DADR_MAR, DMDR_DAT, DDAT_MDR: std_logic := '0';
signal Ddatabus: std_logic_vector(n-1 downto 0) := (others => '0');
signal Daddrbus: std_Logic_vector(a-1 downto 0) := (others => '0');

begin

--initialise device under test
DUT: DataMemITF generic map (n,a,k) port map (CLK => CLK, RST => RST, DCS => DCS, DWE => DWE, DRE => DRE, DADR_MAR => DADR_MAR, DMDR_DAT => DMDR_DAT, DDAT_MDR => DDAT_MDR, Ddatabus => Ddatabus, Daddrbus => Daddrbus);

--reset
RST <= '1' after 1ns, '0' after 2ns;

--clock
CLK <= not CLK after 5ns;

--stimulus
process is
begin
    --stimulus 1, read from first memory location
    wait until rising_edge(CLK);
    Daddrbus <= "0000000000000000";
    Ddatabus <= (others => 'Z');
    DMDR_DAT <= '0';
    DADR_MAR <= '1';
    DCS <= '1';
    DRE <= '1';
    wait until rising_edge(CLK);
    DADR_MAR <= '0';
    DCS <= '0';
    DRE <= '0';
    DMDR_DAT <= '1';
    
    --stimulus 2, write to first memory location
    wait until rising_edge(CLK);
    Ddatabus <= "1000000000000000";
    DMDR_DAT <= '0';
    DDAT_MDR <= '1';
    wait until rising_edge(CLK);
    DDAT_MDR <= '0';
    DADR_MAR <= '1';
    DCS <= '1';
    DWE <= '1';
    
    --stimulus 3, read from first memory location
    wait until rising_edge(CLK);
    Ddatabus <= (others => 'Z');
    DCS <= '0';
    DWE <= '0';
    DADR_MAR <= '0';
    DDAT_MDR <= '0';
    DADR_MAR <= '1';
    DCS <= '1';
    DRE <= '1';
    wait until rising_edge(CLK);
    DADR_MAR <= '0';
    DCS <= '0';
    DRE <= '0';
    DMDR_DAT <= '1';
end process;

end Behavioral;
