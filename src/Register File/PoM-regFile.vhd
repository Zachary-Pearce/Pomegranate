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
        CLK, ARST, RWE, CMPE, ALU_REGF, REGF_DAT, DAT_REGF: in std_logic;
		z_flag, p_flag: out std_logic;
		--data bus
		Ddatabus: inout std_logic_vector(n-1 downto 0);
		--address bus
		Daddrbus: in std_logic_vector(a-1 downto 0);
		--ALU bus
		alubus: out std_logic_vector(2*n-1 downto 0)
    );
end entity regFile;

architecture regFileRTL or regFile is
    --register addresses (source, target, destination)
	signal Rs,Rt,Rd: std_logic_vector(k-1 downto 0);
	signal sIndex, tIndex, dIndex: natural;
	--register data (source, target, and destination)
	signal sData, tData, dData: std_logic_vector(n-1 downto 0);
	--register array
	type regFileArray is array(0 to (2**k)-1) of std_logic_vector(n-1 downto 0);
begin
    --COMBINATIONAL PART
	--read the source address
	sIndex <= AddressIndex(Daddrbus,'s');
	s <= Daddrbus(sIndex-1 downto sIndex-k);
	--read the target address
	tIndex <= AddressIndex(Daddrbus,'t');
	t <= Daddrbus(tIndex-1 downto tIndex-k);
	--read the destination address
	dIndex <= AddressIndex(Daddrbus,'d');
	d <= Daddrbus(dIndex-1 downto dIndex-k);
	
	--get the register data
	sData <= registers(to_integer(unsigned(s)))(n-1 downto 0);
	tData <= registers(to_integer(unsigned(t)))(n-1 downto 0);
	dData <= Ddatabus(n-1 downto 0) when REGF_DAT = '1' else (others => '0');
	
	--SEQUENTIAL PART
	s0: process(CLK, ARST)
		variable sData, tData: std_logic_vector(n-1 downto 0);
	begin
		if ARST = '1' then
			z_flag <= '0';
			p_flag <= '0';
			--this isn't very friendly for higher bit widths
			registers <= (others => (others => '0'));
		elsif rising_edge(CLK) then
			if RWE = '1' then
				registers(to_integer(unsigned(d))) <= dData;
			elsif CMPE = '1' then
				--if we aren't writing, we can run CMP operations
				z_flag <= '0';
				p_flag <= '0';
				if signed(sData) = 0 then
					z_flag <= '1';
				elsif signed(sData) > 0 then
					p_flag <= '1';
				end if;
			end if;
		end if;
	end process s0;
	
	--OUTPUT PART
	alubus <= (sData & tData) when ALU_REGF = '1' else (others => '0');
	Ddatabus <= tData when DAT_REGF = '1' else (others => 'Z');
end architecture regFileRTL;