----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2024 17:47:57
-- Design Name: 
-- Module Name: Port_TB - Behavioral
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

entity Port_TB is
end Port_TB;

architecture Behavioral of Port_TB is

--components
component aPort is
    generic (
        n: natural := 8
    );
    port (
        CLK, ARST: in std_logic;
        PORT_DAT, DAT_PORT, PORT_OUT, PORT_IN, WE: in std_logic;
        --inputs outputs
        Ddatabus: inout std_logic_vector(n-1 downto 0);
        Dout: inout std_logic_vector(n-1 downto 0)
    );
end component aPort;

--constants
constant n: natural := 8;

--signals
signal CLK, ARST: std_logic := '0';
signal PORT_DAT, DAT_PORT, PORT_OUT, PORT_IN, WE: std_logic := '0';
signal Ddatabus, Dout: std_logic_vector(n-1 downto 0) := (others => '0');

begin

--instantiate DUT
DUT: aPort generic map (n) port map (CLK => CLK, ARST => ARST, PORT_DAT => PORT_DAT,
DAT_PORT => DAT_PORT, PORT_OUT => PORT_OUT, PORT_IN => PORT_IN, WE => WE, Ddatabus => Ddatabus, Dout => Dout);

--reset
ARST <= '1' after 1ns, '0' after 2ns;

--clock
CLK <= not CLK after 5ns;

--stimuli
process is
begin
    --first stimuli - input a value into the port
    Dout <= "10000000";
    WE <= '1';
    PORT_IN <= '1';
    PORT_DAT <= '0';
    PORT_OUT <= '0';
    DAT_PORT <= '0';
    wait until rising_edge(CLK);
    
    --second stimuli - output a value from the port
    Dout <= "ZZZZZZZZ";
    WE <= '0';
    PORT_IN <= '0';
    PORT_DAT <= '0';
    PORT_OUT <= '1';
    DAT_PORT <= '0';
    wait until rising_edge(CLK);
    
    --third stimuli - place a value in the port from the databus
    Ddatabus <= "01000000";
    WE <= '1';
    PORT_IN <= '0';
    PORT_DAT <= '1';
    PORT_OUT <= '0';
    DAT_PORT <= '0';
    wait until rising_edge(CLK);
    
    --fourth stimuli - drive the databus with the port
    Ddatabus <= "ZZZZZZZZ";
    WE <= '0';
    PORT_IN <= '0';
    PORT_DAT <= '0';
    PORT_OUT <= '0';
    DAT_PORT <= '1';
    wait until rising_edge(CLK);
end process;

end Behavioral;
