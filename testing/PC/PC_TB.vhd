----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 22:44:12
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_TB is
--  Port ( );
end PC_TB;

architecture Behavioral of PC_TB is

--components
component PC is
    generic (
        a: natural := 8
    );
    Port (
        CLK, RST: in std_logic;
        PC_INC: in std_logic;
        data_in: in std_logic_vector(a-1 downto 0);
        address_out: out std_logic_vector(a-1 downto 0)
    );
end component PC;

--constants
constant a: natural := 8;
--signals
signal CLK, RST, PC_INC: std_logic := '0';
signal Data_Bus, Address_Bus: std_logic_vector(a-1 downto 0) := (others => '0');

begin

--initalise component
DUT: PC generic map (a) port map (
    CLK => CLK, RST => RST, PC_INC => PC_INC,
    data_in => Data_Bus, address_out => Address_Bus
);

--reset
RST <= '1' after 1ns, '0' after 2ns;
--clock
CLK <= not CLK after 5ns;

--test stimuli
process is
begin
    --first case - a standard fetch, drive the address bus then increment for next clock cycle
    wait until rising_edge(CLK);
    Data_Bus <= (others => 'Z');
    Address_Bus <= (others => 'Z');
    PC_INC <= '1';
    
    --second case - second standard fetch
    wait until rising_edge(CLK);
    Data_Bus <= (others => 'Z');
    Address_Bus <= (others => 'Z');
    PC_INC <= '1';
    
    --second case - load a value into the program counter
    wait until rising_edge(CLK);
    Data_Bus <= "11111111";
    Address_Bus <= (others => 'Z');
    PC_INC <= '0';
    
    --third case - third standard fetch
    wait until rising_edge(CLK);
    Data_Bus <= (others => 'Z');
    Address_Bus <= (others => 'Z');
    PC_INC <= '1';
end process;

end Behavioral;
