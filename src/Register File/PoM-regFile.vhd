library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.cpu_defs.all;

entity regFile is
    generic (
		--data bus width
		n: natural := 8;
		--adress bus width
		a: natural := 32;
		--register address width
		k: natural := 5
    );
    port (
		CLK, ARST, enable, R_write_enable, data_bus_R_file: in std_logic;
		--data bus
		data_data_bus: inout std_logic_vector(n-1 downto 0);
		--address bus
		data_address_bus: in std_logic_vector(a-1 downto 0);
		--Read outputs (source and target)
		source_out, target_out: out std_logic_vector(n-1 downto 0)
    );
end entity regFile;

architecture regFileRTL of regFile is
	--register adresses (source, target, destination)
	signal s_index, t_index, d_index: natural;
	signal Rs, Rt, Rd: std_logic_vector(k-1 downto 0);
	--register array
	type regFileArray is array(0 to (2**k)-1) of std_logic_vector(n-1 downto 0);
	signal registers: regFileArray;
begin
	--COMBINATIONAL PART
	--get the source address index
	s_index <= AddressIndex(data_address_bus,'s');
	Rs <= data_address_bus(s_index-1 downto s_index-k) when enable = '1' else (others => '0');
	--get the target address index
	t_index <= AddressIndex(data_address_bus,'t');
	Rt <= data_address_bus(t_index-1 downto t_index-k) when enable = '1' else (others => '0');
	--get the destination address index
	d_index <= AddressIndex(data_address_bus,'d');
	Rd <= data_address_bus(d_index-1 downto d_index-k) when enable = '1' else (others => '0');
	
	--SEQUENTIAL PART
	s0: process(CLK, ARST)
	begin
        if ARST = '1' then
			--this isn't very friendly with higher bit widths
			registers <= (others => (others => '0'));
		elsif rising_edge(CLK) then
		    if enable = '1' then
		        --write and bypass
		        if R_write_enable = '1' then
		            --write to destination register
		            registers(to_integer(unsigned(Rd))) <= data_data_bus(n-1 downto 0);
		        end if;
		    end if;
		end if;
	end process s0;
	
	--OUTPUT PART
	source_out <= registers(to_integer(unsigned(Rs)))(n-1 downto 0) when enable = '1' else (others => 'Z');
    target_out <= registers(to_integer(unsigned(Rt)))(n-1 downto 0) when enable = '1' else (others => 'Z');
    data_data_bus <= registers(to_integer(unsigned(Rs)))(n-1 downto 0) when enable = '1' and data_bus_R_file = '1' else (others => 'Z');
end architecture regFileRTL;