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

entity RegFile_TB is
end RegFile_TB;

architecture Behavioral of RegFile_TB is

--natural signals
constant n: natural := 8;
constant a: natural := 32;
constant k: natural := 5;

--control signals
signal CLK, ARST, enable, RWE, DAT_REGF: std_logic := '0';
signal databus: std_logic_vector(n-1 downto 0) := (others => '0');
signal addrbus: std_logic_vector(a-1 downto 0) := (others => '0');
signal outS, outT: std_logic_vector(n-1 downto 0) := (others => '0');

--component declaration
component regFile is
    generic (
		--data bus width
		n: natural := 8;
		--adress bus width
		a: natural := 32;
		--register address width
		k: natural := 5
    );
    port (
		CLK, ARST, enable, R_write_enable, data_bus_R_file: in std_logic;
		--data bus
		data_data_bus: inout std_logic_vector(n-1 downto 0);
		--address bus
		data_address_bus: in std_logic_vector(a-1 downto 0);
		--Read outputs (source and target)
		source_out, target_out: out std_logic_vector(n-1 downto 0)
    );
end component regFile;

begin
    --instantiate the component
    DUT: regFile generic map (n, a, k) port map (
        CLK => CLK, ARST => ARST, enable => enable, R_write_enable => RWE, data_bus_R_file => DAT_REGF,
        data_data_bus => databus, data_address_bus => addrbus, source_out => outS, target_out => outT
    );

    --reset
    ARST <= '1' after 1ns, '0' after 2ns;
    --clock
    CLK <= not CLK after 5ns;
    
    --stimuli
    process is
    begin
        wait until rising_edge(CLK);
        --first stimulus read 1 value from two addresses (s and t)
        -- expected output of all 0 from address 1 and address 2
        databus <= (others => 'Z');
        --d is 0, s is 1, and t is 2
        addrbus <= "00001000000000100010000000000000";
        RWE <= '0';
        ENABLE <= '1';
        DAT_REGF <= '0';
        wait until rising_edge(CLK);
        
        --second stimulus write value to 1 address and read from the other 2 at the same time
        -- expect that address 0 be written with all 1's, 0 is read from both address 1 and address 2
        databus <= (others => '1');
        --d is 0, s is 1, and t is 2
        addrbus <= "00001000000000100010000000000000";
        RWE <= '1';
        ENABLE <= '1';
        DAT_REGF <= '0';
        wait until rising_edge(CLK);
        
        --fourth stimulus do not drive enable signal
        -- expect that nothing happens
        databus <= "00000001";
        --d is 0, s is 1, and t is 2
        addrbus <= "00001000000000100010000000000000";
        RWE <= '1';
        ENABLE <= '0';
        DAT_REGF <= '0';
        wait until rising_edge(CLK);
        
        --third stimulus read 1 value from an address (s) to confirm previous write action and disable
        -- expect that adress 0 is read as all 1's
        databus <= (others => 'Z');
        --d is 0, s is 0, and t is 0
        addrbus <= "00001000000000000000000000000000";
        RWE <= '0';
        ENABLE <= '1';
        DAT_REGF <= '1';
    end process;
end architecture Behavioral;