----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2023 12:23:04
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
use WORK.cpu_defs.all;

entity ALU_TB is
end entity ALU_TB;

architecture Behavioral of ALU_TB is
    --components
    component ALU is
        generic (
            n: natural := 8
        );
        port (
            CLK, RST: in std_logic;
            REGF_ALU, DAT_ALU, ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_NOT, ALU_XOR, ALU_Imm: in std_logic;
            Ddatabus: inout std_logic_vector(n-1 downto 0);
            regfile: inout std_logic_vector(2*n-1 downto 0)
        );
    end component ALU;

    --architecture width constant
    constant n: natural := 8;

    --signals
    signal CLK, RST: std_logic := '0';
    signal REGF_ALU, DAT_ALU, ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_NOT, ALU_XOR, ALU_Imm: std_logic := '0';
    signal databus: std_logic_vector(n-1 downto 0);
    signal regfile: std_logic_vector(2*n-1 downto 0);
begin
    --instantiate the component
    DUT: ALU generic map (n) port map (CLK => CLK, RST => RST,
        REGF_ALU => REGF_ALU, DAT_ALU => DAT_ALU, ALU_ADD => ALU_ADD,
        ALU_SUB => ALU_SUB, ALU_AND => ALU_AND, ALU_OR => ALU_OR,
        ALU_NOT => ALU_NOT, ALU_XOR => ALU_XOR, ALU_Imm => ALU_Imm,
        Ddatabus => databus, regfile => regfile);
    
    --reset
    RST <= '1' after 1ns, '0' after 2ns;

    --clock
    CLK <= not CLK after 5ns;
    
    --stimuli
    process is
    begin
        wait until rising_edge(CLK);
        
        --set the inputs
        DAT_ALU <= '0';
        REGF_ALU <= '0';
        regfile(15 downto 8) <= "11000100";
        regfile(7 downto 0)  <= "00011010";
        databus <= (others => 'Z');
        
        --first stimulus, add two inputs
        ALU_Imm <= '0';
        ALU_ADD <= '1';
        ALU_SUB <= '0';
        ALU_AND <= '0';
        ALU_OR  <= '0';
        ALU_NOT <= '0';
        ALU_XOR <= '0';
        wait until rising_edge(CLK);
        DAT_ALU <= '1'; --output result on databus
        
        wait until rising_edge(CLK);

        --second stimulus, subtract two inputs
        DAT_ALU <= '0';
        REGF_ALU <= '0';
        ALU_Imm <= '0';
        ALU_ADD <= '0';
        ALU_SUB <= '1';
        ALU_AND <= '0';
        ALU_OR  <= '0';
        ALU_NOT <= '0';
        ALU_XOR <= '0';
        wait until rising_edge(CLK);
        DAT_ALU <= '1'; --output result on databus
        
        wait until rising_edge(CLK);

        --third stimulus, AND two inputs
        REGF_ALU <= '0';
        DAT_ALU <= '0';
        ALU_Imm <= '0';
        ALU_ADD <= '0';
        ALU_SUB <= '0';
        ALU_AND <= '1';
        ALU_OR  <= '0';
        ALU_NOT <= '0';
        ALU_XOR <= '0';
        wait until rising_edge(CLK);
        DAT_ALU <= '1'; --output result on databus
        
        wait until rising_edge(CLK);

        --fourth stimulus, OR two inputs
        REGF_ALU <= '0';
        DAT_ALU <= '0';
        ALU_Imm <= '0';
        ALU_ADD <= '0';
        ALU_SUB <= '0';
        ALU_AND <= '0';
        ALU_OR  <= '1';
        ALU_NOT <= '0';
        ALU_XOR <= '0';
        wait until rising_edge(CLK);
        DAT_ALU <= '1'; --output result on databus
        
        wait until rising_edge(CLK);

        --fifth stimulus, NOT an input
        REGF_ALU <= '0';
        DAT_ALU <= '0';
        ALU_Imm <= '0';
        ALU_ADD <= '0';
        ALU_SUB <= '0';
        ALU_AND <= '0';
        ALU_OR  <= '0';
        ALU_NOT <= '1';
        ALU_XOR <= '0';
        wait until rising_edge(CLK);
        DAT_ALU <= '1'; --output result on databus
        
        wait until rising_edge(CLK);

        --sixth stimulus, XOR two inputs
        DAT_ALU <= '0';
        REGF_ALU <= '0';
        ALU_Imm <= '0';
        ALU_ADD <= '0';
        ALU_SUB <= '0';
        ALU_AND <= '0';
        ALU_OR  <= '0';
        ALU_NOT <= '0';
        ALU_XOR <= '1';
        wait until rising_edge(CLK);
        DAT_ALU <= '1'; --output result on databus
        
        wait until rising_edge(CLK);

        --set the inputs
        DAT_ALU <= '0';
        REGF_ALU <= '0';
        regfile <= (others => 'Z');
        regfile(15 downto 8) <= "00011010"; --set to high impedance so this part of the ALU bus can be driven
        databus <= "10010110";

        --seventh stimulus, use immediate addressing with the first stimulus
        ALU_Imm <= '1';
        ALU_ADD <= '1';
        ALU_SUB <= '0';
        ALU_AND <= '0';
        ALU_OR  <= '0';
        ALU_NOT <= '0';
        ALU_XOR <= '0';
        wait until rising_edge(CLK);
        REGF_ALU <= '1'; --output result on ALU bus
    end process;
end architecture Behavioral;