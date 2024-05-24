----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2023 12:23:04
-- Design Name: 
-- Module Name: IR_TB - Behavioral
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

entity IR_TB is
end entity IR_TB;

architecture Behavioral of IR_TB is
    --components
    component IR is
        generic (
            n: natural := 16; --size of the program data bus
            d: natural := 8;  --size of the data data bus
            a: natural := 16  --size of the address busses
        );
        Port (CLK, reset: in std_logic;
              IR_PDAT, IR_DDAT, ADR_IR: in std_logic;
              op: out opcode;
              --data busses
              Pdatabus: in std_logic_vector(n-1 downto 0);
              Ddatabus: out std_logic_vector(d-1 downto 0);
              --address busses
              Paddrbus: out std_logic_vector(a-1 downto 0);
              Daddrbus: out std_logic_vector(a-1 downto 0));
    end component IR;

    --constants
    constant n: natural := 16;
    constant d: natural := 8;
    constant a: natural := 16;

    --signals
    signal CLK, reset: std_logic := '0';
    signal IR_PDAT, IR_DDAT, ADR_IR: std_logic := '0';
    signal op: opcode;
    signal Ddatabus: std_logic_vector(d-1 downto 0);
    signal Daddrbus: std_logic_vector(a-1 downto 0);
    signal Pdatabus: std_logic_vector(n-1 downto 0);
    signal Paddrbus: std_logic_vector(a-1 downto 0);
begin
    --instantiate the component
    DUT: IR generic map (n) port map (
        CLK => CLK, reset => reset, IR_PDAT => IR_PDAT, IR_DDAT => IR_DDAT, ADR_IR => ADR_IR,
        op => op, Pdatabus => Pdatabus, Ddatabus => Ddatabus, Paddrbus => Paddrbus, Daddrbus => Daddrbus
    );

    --reset
    reset <= '1' after 1ns, '0' after 2ns;

    --clock
    CLK <= not CLK after 5ns;

    --stimuli
    process is
    begin
        --set the input (assuming 8-bit width)
        Pdatabus <= "0000100000000000"; --just setting the opcode, which is ADD

        --first stimuli, load the IR with the program databus
        IR_PDAT <= '1';
        IR_DDAT <= '0';
        ADR_IR <= '0';
        wait for 10ns;

        --second stimuli drive the program and data address bus with the value of the IR
        IR_PDAT <= '0';
        IR_DDAT <= '0';
        ADR_IR <= '1';
        wait for 10ns;
        
        --third stimuli drive the databus with what would be an immediate value
        IR_PDAT <= '0';
        IR_DDAT <= '1';
        ADR_IR <= '0';
        wait for 10ns;
    end process;
end architecture Behavioral;