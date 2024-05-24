library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.cpu_defs.all;

entity regFile is
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
end entity regFile;

architecture regFileRTL of regFile is
    --register addresses
    signal d: std_logic_vector(k-1 downto 0); --destination always takes first address given
    signal s: std_logic_vector(k-1 downto 0); --source always takes second address given
    signal t: std_logic_vector(k-1 downto 0); --target always takes last address given
    
    signal dIndex: natural;
    signal sIndex: natural;
    signal tIndex: natural;

    --output data
    signal sData: std_logic_vector(n-1 downto 0); --data from the source register
    signal tData: std_logic_vector(n-1 downto 0); --data from the target register
    signal dData: std_logic_vector(n-1 downto 0); --data for the destination register

    --register array
    type regFileArray is array(0 to (2**k)-1) of std_logic_vector(n-1 downto 0);
    signal registers: regFileArray;
begin
    --combinationally write to the databus and ALU bus
    Ddatabus <= tData when DAT_REGF = '1' else (others => 'Z'); --might want to change what is written to the data bus, we will still need it for store instructions but might make more sense to use source data
    alubus <= (sData & tData) when ALU_REGF = '1' else (others => 'Z'); --writes the source data with the target data concantinated on the end to the ALU
    
    --read the destination address from the address bus using the address index function
    dIndex <= AddressIndex(Daddrbus,'d');
    d <= Daddrbus(dIndex-1 downto dIndex-k) when RRE = '1' else (others => '0');
    --read the source address from the address bus using the address index function
    sIndex <= AddressIndex(Daddrbus,'s');
    s <= Daddrbus(sIndex-1 downto sIndex-k) when RRE = '1' else (others => '0');
    --read the target address from the address bus using the adress index function
    tIndex <= AddressIndex(Daddrbus,'t');
    t <= Daddrbus(tIndex-1 downto tIndex-k) when RRE = '1' else (others => '0');

    dData <= alubus(n-1 downto 0) when REGF_ALU = '1' else Ddatabus;
    sData <= registers(to_integer(unsigned(s)))(n-1 downto 0);
    tData <= registers(to_integer(unsigned(t)))(n-1 downto 0);

    --sequential part process
    s0: process(CLK, ARST)
    begin
        if ARST = '1' then
            z_flag <= '0';
            p_flag <= '0';
            registers <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            if RWE = '1' then
                registers(to_integer(unsigned(d))) <= dData;
            elsif RRE = '1' then
                if CMPE = '1' then
                    z_flag <= '0';
                    p_flag <= '0';
                    if signed(sData) = 0 then
                        z_flag <= '1';
                    elsif signed(sData) > 0 then
                        p_flag <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process s0;
end architecture regFileRTL;