library IEEE;
use IEEE.std_logic_1164.all;
use WORK.cpu_defs.all;

entity aPort is
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
end entity aPort;

architecture port_RTL of aPort is
    signal regContents: std_logic_vector(n-1 downto 0);
begin
    --combinational writing of the data bus
    Ddatabus <= regContents when DAT_PORT = '1' else (others => 'Z');
    Dout <= regContents when PORT_OUT = '1' else (others => 'Z');

    --sequential part
    s0: process(CLK, ARST)
    begin
        if ARST = '1' then
            regContents <= (others => '0');
        elsif rising_edge(CLK) then
            if WE = '1' then
                if PORT_DAT = '1' then
                    regContents <= Ddatabus;
                elsif PORT_IN = '1' then
                    regContents <= Dout;
                end if;
            end if;
        end if;
    end process s0;
end architecture port_RTL;