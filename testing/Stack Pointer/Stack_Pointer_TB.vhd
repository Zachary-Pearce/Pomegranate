----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 16:06:15
-- Design Name: 
-- Module Name: Stack_Pointer_TB - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL  ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stack_Pointer_TB is
end Stack_Pointer_TB;

architecture Behavioral of Stack_Pointer_TB is

--components
component Stack_Pointer is
    generic (
        a: natural := 8 --memory address width
    );
    Port (
        CLK, RST: in std_logic;
        enable, Pntr_INC: in std_logic;
        address: out std_logic_vector(a-1 downto 0)
    );
end component Stack_Pointer;

--signals
constant a: natural := 8;
signal CLK, RST, enable, Pntr_INC: std_logic := '0';
signal Address_Bus : std_logic_vector(7 downto 0) := (others => '0');

begin

--initialise the component under test
DUT: Stack_Pointer generic map (a) port map (
    CLK => CLK, RST => RST, enable => enable, Pntr_INC => Pntr_INC, address => Address_Bus
);

--reset
RST <= '1' after 1ns, '0' after 2ns;
--clock
CLK <= not CLK after 5ns;

--test stimuli
process is
begin
    --first test case - drive address bus then increment stack pointer in time for next clock
    wait until rising_edge(CLK);
    Address_Bus <= "ZZZZZZZZ";
    enable <= '1';
    Pntr_INC <= '1';

    --second test case - drive the address bus then decrement the stack pointer in time for next clock
    wait until rising_edge(CLK);
    Address_Bus <= "ZZZZZZZZ";
    enable <= '1';
    Pntr_INC <= '0';
    
    --third test case - drive the address bus
    wait until rising_edge(CLK);
    Address_Bus <= "ZZZZZZZZ";
    enable <= '1';
    Pntr_INC <= '0';
    
    --fourth test case - do nothing
    wait until rising_edge(CLK);
    Address_Bus <= "ZZZZZZZZ";
    enable <= '0';
    Pntr_INC <= '0';
end process;

end Behavioral;
