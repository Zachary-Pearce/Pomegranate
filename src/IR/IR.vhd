library IEEE;
use IEEE.std_logic_1164.all;
use WORK.cpu_defs.all;

entity IR is
    generic (
        n: natural := 16; --size of the program data bus
        d: natural := 8;  --size of the data data bus
        a: natural := 16  --size of the address busses
    );
    Port (CLK, reset: in std_logic;
          IR_PDAT, IR_DDAT, ADR_IR: in std_logic;
          op: out opcode;
          --data busses
          Pdatabus: in std_logic_vector(n-1 downto 0);
          Ddatabus: out std_logic_vector(d-1 downto 0);
          --address busses
          Paddrbus: out std_logic_vector(a-1 downto 0);
          Daddrbus: out std_logic_vector(a-1 downto 0));
end entity IR;

architecture RTL of IR is
    signal reg: std_logic_vector(n-1 downto 0);
begin
    --we are doing this outside of the process because we want to make sure we are loading the correct value
    --  if we wanted to do this inside the process then reg would have to be a variable rather than a signal
    Paddrbus <= reg when ADR_IR = '1' else (others => 'Z');
    Daddrbus <= reg when ADR_IR = '1' else (others => 'Z');
    Ddatabus <= reg(d-1 downto 0) when IR_DDAT = '1' else (others => 'Z');
    
    process (CLK, reset) is
    begin
        if reset = '1' then
            reg <= (others => '0');
        elsif rising_edge(CLK) then
            if IR_PDAT = '1' then
                reg <= Pdatabus;
            end if;
        end if;
    end process;
    
    --set opcode, combinationally with process to ensure latest value of reg is used
    op <= slv2op(reg(n-1 downto n - op_w));
end RTL;