library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.cpu_defs.all;

entity DataMemITF is
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
end entity DataMemITF;

architecture DMemITF_RTL of DataMemITF is
    --MDR
    signal MDR: std_logic_vector(n - 1 downto 0);
    --memory array definition
    type mem_array is array (0 to (2**k)-1)
        of std_logic_vector(n-1 downto 0);
    signal RAM: mem_array;
begin
    --drive data bus when control signal is set (combinational)
    Ddatabus <= MDR when DMDR_DAT = '1' else (others => 'Z');
    --sequential part
    s0: process (CLK, RST) is
        --MAR
        variable MAR: unsigned(k - 1 downto 0);
    begin
        if RST = '1' then
            MDR <= (others => '0');
            MAR := (others => '0');
            RAM <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            if (DADR_MAR = '1' or DDAT_MDR = '1') then
                --the loading of the MAR and MDR is done like this so they can be loaded at the same time
                --load the MAR
                if DADR_MAR = '1' then
                    --memory addresses are always in the last k bits of an instruction
                    MAR := unsigned(Daddrbus(k-1 downto 0));
                end if;
                --load the MDR
                if DDAT_MDR = '1' then
                    MDR <= Ddatabus;
                end if;
            end if;
            
            if DCS = '1' then
                if DWE = '1' then
                    RAM(to_integer(MAR)) <= MDR;
                elsif DRE = '1' then
                    MDR <= RAM(to_integer(MAR));
                end if;
            end if;
        end if;
    end process s0;
end architecture DMemITF_RTL;