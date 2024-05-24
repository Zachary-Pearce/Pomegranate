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
constant a: natural := 16;
constant k: natural := n/8;

--control signals
signal CLK, ARST: std_logic := '0';
signal z_flag, p_flag: std_logic := '0';
signal RWE, RRE, CMPE, ALU_REGF, REGF_ALU, DAT_REGF: std_logic := '0';
signal databus: std_logic_vector(n-1 downto 0) := (others => '0');
signal addrbus: std_logic_vector(a-1 downto 0) := (others => '0');
signal alubus: std_logic_vector(2*n-1 downto 0) := (others => '0');

--component declaration
component regFile is
    generic (
        n: natural := 8;
        a: natural := 8;
        k: natural := 1
    );
    port (
        CLK, ARST: in std_logic;
        z_flag, p_flag: out std_logic;
        RWE, RRE, CMPE, ALU_REGF, REGF_ALU, DAT_REGF: in std_logic;
        --data bus
        Ddatabus: inout std_logic_vector(n-1 downto 0);
        --address bus
        Daddrbus: in std_logic_vector(a-1 downto 0);
        --ALU bus
        alubus: inout std_logic_vector(2*n-1 downto 0)
    );
end component regFile;

begin
    --instantiate the component
    DUT: regFile generic map (n, a, k) port map (
        CLK => CLK, ARST => ARST, z_flag => z_flag, p_flag => p_flag, RWE => RWE, RRE => RRE, CMPE => CMPE,
        ALU_REGF => ALU_REGF, REGF_ALU => REGF_ALU, DAT_REGF => DAT_REGF, Ddatabus => databus,
        Daddrbus => addrbus, alubus => alubus
    );

    --reset
    ARST <= '1' after 1ns, '0' after 2ns;
    --clock
    CLK <= not CLK after 5ns;
    
    --stimuli
    process is
    begin
        wait until rising_edge(CLK);
        --first stimulus read 1 value from an address (s)
        -- expected output of either all 0's all 1's
        addrbus <= (others => '0'); --address 0
        RRE <= '1';
        RWE <= '0';
        CMPE <= '0';
        ALU_REGF <= '1';
        DAT_REGF <= '0';
        wait until rising_edge(CLK);

        --second stimulus write value to 1 address
        -- expect that address 0 be written with all 1's
        databus <= (others => '1');
        addrbus <= (others => '0'); --address 0
        RRE <= '0';
        RWE <= '1';
        CMPE <= '0';
        ALU_REGF <= '0';
        DAT_REGF <= '0';
        wait until rising_edge(CLK);
        
        --third stimulus compare value of address 0
        -- expected that pflag be set
        addrbus <= (others => '0'); --address 0
        RRE <= '1';
        RWE <= '0';
        CMPE <= '1';
        ALU_REGF <= '1';
        DAT_REGF <= '0';
    end process;
end architecture Behavioral;