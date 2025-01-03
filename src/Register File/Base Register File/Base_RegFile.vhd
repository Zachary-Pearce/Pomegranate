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
		CLK, ARST, R_write_enable, data_bus_R_file: in std_logic;
		--register address inputs
		source_register, target_register, destination_register: std_logic_vector(k-1 downto 0);
		--data bus
		data_bus: inout std_logic_vector(n-1 downto 0);
		--Read outputs (source and target)
		source_out, target_out: out std_logic_vector(n-1 downto 0)
    );
end entity regFile;

architecture regFileRTL of regFile is
	--register array
	type regFileArray is array(0 to (2**k)-1) of std_logic_vector(n-1 downto 0);
	signal registers: regFileArray;
begin
	--SEQUENTIAL PART
	s0: process(CLK, ARST)
	begin
        if ARST = '1' then
			--using the zeros constant as this is more friendly for higher bit widths
			registers <= (others => zeros);
		elsif rising_edge(CLK) then
		    --write and bypass
		    if R_write_enable = '1' then
		        --write to destination register
		        registers(to_integer(unsigned(destination_register))) <= data_bus(n-1 downto 0);
		    end if;
		end if;
	end process s0;
	
	--OUTPUT PART
	source_out <= registers(to_integer(unsigned(source_register)))(n-1 downto 0);
	target_out <= registers(to_integer(unsigned(target_register)))(n-1 downto 0);
	data_bus <= registers(to_integer(unsigned(source_register)))(n-1 downto 0) when data_bus_R_file = '1' else (others => 'Z');
end architecture regFileRTL;