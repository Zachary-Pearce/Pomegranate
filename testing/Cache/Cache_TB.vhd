library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.cpu_defs.all;

entity Cache_TB is
end entity Cache_TB;

architecture Behavioral of Cache_TB is
    --components
    --the 4-way set associative cache
    component cache is
        generic (
            n: natural := 8;            --width of the data bus
            a: natural := 8;            --width of the address bus
            associativity: natural := 4 --the associativity of the cache
        );
        port (
            --control signals
            CLK, ARST, read_request, write_request, PDAT_C: in std_logic;
            hit, memRead: out std_logic;
            --busses
            Pdatabus: inout std_logic_vector(n-1 downto 0); --program data bus
            Paddrbus: in std_logic_vector(a-1 downto 0)  --program address bus
        );
    end component cache;

    --constants
    constant n: natural := 8;
    constant a: natural := 8;
    constant associativity: natural := 4;

    --signals
    signal CLK, ARST, write_request, read_request: std_logic := '0';
    signal PDAT_C: std_logic := '0';
    signal hit, memRead: std_logic := '0';

    signal Pdatabus: std_logic_vector(n-1 downto 0) := (others => '0');
    signal Paddrbus: std_logic_vector(n-1 downto 0) := (others => '0');
begin
    --instnatiate components
    --cache
    DUT: cache generic map (n,a,associativity) port map (
        CLK => CLK, ARST => ARST, write_request => write_request, read_request => read_request, PDAT_C => PDAT_C,
        hit => hit, memRead => memRead, Pdatabus => Pdatabus, Paddrbus => Paddrbus
    );

    --clock
    CLK <= not CLK after 5ns;

    --stimuli
    process is
    begin
        wait until rising_edge(CLK);
        ARST <= '1';
        write_request <= '0';
        read_request <= '0';
        Pdatabus <= "ZZZZZZZZ";
        Paddrbus <= "ZZZZZZZZ";
        wait until rising_edge(CLK);
        ARST <= '0';

        --stimulus 1, write to cache - will result in a miss and nothing being written
        Pdatabus <= "01100110";
        Paddrbus <= "00001100";
        write_request <= '1';
        read_request <= '0';
        PDAT_C <= '0';
        wait until rising_edge(CLK);

        --stimulus 2, read from the cache - will result in a miss and databus value will be written
        write_request <= '0';
        read_request <= '1';
        PDAT_C <= '0';
        if hit = '1' then
            PDAT_C <= '1';
        end if;
        wait until rising_edge(CLK);
        
        --stimulus 3, read from the cache - will result in a hit and databus will be driven
        Pdatabus <= "ZZZZZZZZ";
        write_request <= '0';
        read_request <= '1';
        PDAT_C <= '0';
        if hit = '1' then
            PDAT_C <= '1';
        end if;
        wait until rising_edge(CLK);

        --stimulus 4, write to the same location in cache
        Pdatabus <= "11110011";
        write_request <= '1';
        read_request <= '0';
        PDAT_C <= '0';
    end process;
end architecture Behavioral;