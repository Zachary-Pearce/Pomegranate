library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_memory is
    generic (
        i: natural := 8; --instruction width
        k: natural := 8  --memory address width
    );
    Port (
        address: in std_logic_vector(k-1 downto 0);
        dout: out std_logic_vector(i-1 downto 0)
    );
end program_memory;

--ROM is designed for low latency therefore we do not have an output register
-- adding an output register would increase the read time to 2 clock cycles but reduces the clock-to-output time
architecture Behavioral of program_memory is
    --rom data type
    type rom_type is array (0 to (2**k)-1) of std_logic_vector(i-1 downto 0);
    --rom definition, put program in here
    constant rom: rom_type := (
        0 => "111100000000000000000000",
        1 => "000000000000000000000000",
        2 => "010110000000000100000101",
        3 => "101000000000000000000000",
        4 => "100010100000000000000000",
        5 => "101000000000001000000000",
        6 => "100111110000111100000000",
        7 => "101000000000011100000011",
        8 => "110000000000000000001001",
        9 => "111010000000000000000000",
        others => (others => '0')
    );
begin
    --OUTPUT PART
    dout <= rom(to_integer(unsigned(address)));
end Behavioral;
