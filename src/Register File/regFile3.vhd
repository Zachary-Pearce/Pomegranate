library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.pomegranate_conf.all;

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
		data_bus: inout std_logic_vector(n-1 downto 0);
		--address bus
		data_address_bus: in std_logic_vector(a-1 downto 0);
		--Read outputs (source and target)
		source_out, target_out: out std_logic_vector(n-1 downto 0)
    );
end entity regFile;

architecture regFileRTL of regFile is
	--register adresses (source, target, destination)
	constant s_index: natural := AddressIndex(register_format, Rs);
	constant t_index: natural := AddressIndex(register_format, Rt);
	constant d_index: natural := AddressIndex(register_format, Rd);
	signal R_source, R_target, R_destination: std_logic_vector(k-1 downto 0);
	--register array
	type regFileArray is array(0 to (2**k)-1) of std_logic_vector(n-1 downto 0);
	signal registers: regFileArray;
begin
	--COMBINATIONAL PART
	-- get the source register
    R_source <= data_address_bus(s_index-1 downto s_index-k) when enable = '1' else (others => '0');
    -- get the target register
    R_target <= data_address_bus(t_index-1 downto t_index-k) when enable = '1' else (others => '0');
    -- get the destination register
    R_destination <= data_address_bus(d_index-1 downto d_index-k) when enable = '1' else (others => '0');
	
	--SEQUENTIAL PART
	s0: process(CLK, ARST)
	begin
        if ARST = '1' then
			--using the zeros constant as this is more friendly for higher bit widths
			registers <= (others => zeros);
		elsif rising_edge(CLK) then
		    if enable = '1' then
		        --write and bypass
		        if R_write_enable = '1' then
		            --write to destination register
		            registers(to_integer(unsigned(R_destination))) <= data_bus(n-1 downto 0);
		        end if;
		    end if;
		end if;
	end process s0;
	
	--OUTPUT PART
	source_out <= registers(to_integer(unsigned(R_source)))(n-1 downto 0) when enable = '1' else (others => 'Z');
    target_out <= registers(to_integer(unsigned(R_target)))(n-1 downto 0) when enable = '1' else (others => 'Z');
    data_bus <= registers(to_integer(unsigned(R_source)))(n-1 downto 0) when enable = '1' and data_bus_R_file = '1' else (others => 'Z');
end architecture regFileRTL;