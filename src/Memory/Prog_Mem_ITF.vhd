library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.cpu_defs.all;

entity ProgMemITF is
    generic (
        n: natural := 16;
        a: natural := 16;
        K: natural := 8
    );
    port (
        --control signals
        CLK, RST: in std_logic;
        PCS, PRE, PADR_MAR, PMDR_DAT: in std_logic;
        --data and address bus
        Pdatabus: inout std_logic_vector(n-1 downto 0);
        Paddrbus: in std_logic_vector(a-1 downto 0)
    );
end entity ProgMemITF;

architecture PMemITF_RTL of ProgMemITF is
    --MDR
    signal MDR: std_logic_vector(n - 1 downto 0);
begin
    --drive data bus when control signal is set (combinational)
    Pdatabus <= MDR when PMDR_DAT = '1' else (others => 'Z');
    --using the address index function defined in the processor package to get the starting index of the program address
    --sequential part
    s0: process (CLK, RST) is
        --MAR
        variable MAR: unsigned(k - 1 downto 0);
        
        --memory array definition
        type mem_array is array (0 to (2**k)-1)
            of std_logic_vector(n-1 downto 0);
        --the contents of the program memory
        constant ROM: mem_array := (
            0 => op2slv(INPA) & std_logic_vector(to_unsigned(0, Raddr_w)) & std_logic_vector(to_unsigned(0, Raddr_w)) & '0' & std_logic_vector(to_unsigned(0, 8)), --input port A to register 0
            1 => op2slv(ADDI) & std_logic_vector(to_unsigned(1, Raddr_w)) & std_logic_vector(to_unsigned(0, Raddr_w)) & '0' & std_logic_vector(to_unsigned(5, 8)), --immadiate add 5 to register address 0 and store in register address 1
            2 => op2slv(BDOUT) & std_logic_vector(to_unsigned(1, Raddr_w)) & std_logic_vector(to_unsigned(0, Raddr_w)) & '0' & std_logic_vector(to_unsigned(0, 8)), --output the result in register address 1 to port B
            3 => op2slv(BRA) & std_Logic_vector(to_unsigned(0, Raddr_w)) & "00" & std_logic_vector(to_unsigned(3, Maddr_w)), --loop back to this address forever
            others => (others => '0')
        );
    begin
        if RST = '1' then
            MDR <= (others => '0');
            MAR := (others => '0');
        elsif rising_edge(CLK) then   
            if PADR_MAR='1' then
                MAR := unsigned(Paddrbus(k-1 downto 0));
            end if;
            
            if PCS = '1' then
                if PRE = '1' then
                    MDR <= ROM(to_integer(MAR));
                end if;
            end if;
        end if;
    end process s0;
end architecture PMemITF_RTL;