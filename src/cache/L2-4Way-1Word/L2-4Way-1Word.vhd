library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.cpu_defs.all;

entity cache is
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
end entity cache;

architecture cacheRTL of cache is
    --constants
    constant indexWidth: natural := 2;          --the width of the index field
    constant setNum: natural := 2**indexWidth;  --the number of sets
    constant tagWidth: natural := a-indexWidth; --the width of the tag field

    --cache line type
    type cacheLine is record
        tag: std_logic_vector(tagWidth-1 downto 0);
        data: std_logic_vector(n-1 downto 0);
        valid: std_logic;
    end record;
    --cache set array type
    type cacheSet is array (0 to associativity-1) of cacheLine;
    --cache memory array type
    type cacheMem is array (0 to setNum-1) of cacheSet;

    --signals
    signal dataOut: std_logic_vector(n-1 downto 0); --ouput data
    signal cache: cacheMem;                         --cache memory array
    --signals for the index, tag, and hit check
    signal tag: std_logic_vector(tagWidth-1 downto 0);
    signal index: std_logic_vector(indexWidth-1 downto 0);
begin
    --combinational driving of databus
    Pdatabus <= dataOut when PDAT_C='1' else (others => 'Z');

    --combinationally get the index and tag
    tag <= Paddrbus(a-1 downto indexWidth);
    index <= Paddrbus(indexWidth-1 downto 0);

    --sequential part
    s0: process(CLK, ARST)
        variable hitCheck: boolean;
        variable j: integer;
    begin
        if ARST = '1' then
            --reset the cache memory
            for x in 0 to setNum-1 loop
                for y in 0 to associativity-1 loop
                    cache(x)(y).tag <= (others => '0');
                    cache(x)(y).data <= (others => '0');
                    cache(x)(y).valid <= '0';
                end loop;
            end loop;
            memRead <= '0';
            hit <= '0';
            hitCheck := false;
            j := 0;
        elsif rising_edge(CLK) then
            --reset some signals
            memRead <= '0';
            hit <= '0';
            hitCheck := false;
            j := 0;

            --if there was a read request...
            if read_request = '1' then
                --check for a cache hit
                for i in 0 to associativity-1 loop
                    --if the inputted data is 
                    if cache(to_integer(unsigned(index)))(i).valid = '1' then
                        if cache(to_integer(unsigned(index)))(i).tag = tag then
                            --cache hit
                            hitCheck := true;
                            --set the hit output                                                 
                            --in the control unit, it will set the output bit when there is a hit
                            hit <= '1';                                                          
                            --output the data
                            dataOut <= cache(to_integer(unsigned(index)))(i).data;
                            exit; --exit the loop early
                        end if;
                    else
                        --keep track of the last not valid set looked at
                        j := i;
                        --if this statement never runs and there is a cache miss
                        -- the value from memory will be written to set 0
                    end if;
                end loop;

                --if there was a cache miss
                if not hitCheck then
                    --clear the hit output
                    hit <= '0';
                    --request to read the memory
                    memRead <= '1';
                    --read the memory and either write to a non-occupted cache set or set 0 if all sets are full
                    cache(to_integer(unsigned(index)))(j) <=
                        ( tag => tag, data => Pdatabus, valid => '1' ); --set all of the records values, same syntax as port map
                end if;
            --otherwise if there was a write request...
            elsif write_request = '1' then
                --check for a cache hit
                for i in 0 to associativity-1 loop
                    --if the inputted data is 
                    if cache(to_integer(unsigned(index)))(i).valid = '1' and cache(to_integer(unsigned(index)))(i).tag = tag then
                        --cache hit
                        hit <= '1';
                        --write to the cache
                        cache(to_integer(unsigned(index)))(i) <=
                            ( tag => tag, data => Pdatabus, valid => '1' ); --set all of the records values, same syntax as port map
                        exit; --exit the loop early
                    end if;
                end loop;
                --otherwise if there was a cache miss we don't do anything
            end if;
        end if;
    end process s0;
end architecture cacheRTL;