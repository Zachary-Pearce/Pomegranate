library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.cpu_defs.all;

entity PC is
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
        Paddrbus: out std_logic_vector(a-1 downto 0)
        --countOut: out unsigned(n-1 downto 0)
    );
end entity PC;

architecture PC_RTL of PC is
    --signals
    signal count: unsigned(a-1 downto 0);
begin
    --addrbus is only driven when PC_ADR is set (combinational)
    Paddrbus <= std_logic_vector(count) when PC_ADR = '1' else (others => 'Z');
    --sequential part
    s0: process (CLK, RST) is
    begin
        if RST='1' then --ASynchronous reset
            count <= (others => '0');
        elsif rising_edge(CLK) then
            if LDA_PC = '1' then
                if INC_PC = '1' then
                    --increment count
                    count <= count + 1;
                else
                    --put the operand on the data bus in the PC
                    count <= resize(unsigned(Pdatabus(k-1 downto 0)),a);
                end if;
            end if;
        end if;
    end process s0;
    --output the count for testing purposes
    --countOut <= count;
end architecture PC_RTL;