library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.cpu_defs.all;

entity ALU is
    generic (
        n: natural := 8
    );
    port (
        CLK, RST: in std_logic;
        REGF_ALU, DAT_ALU, ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_NOT, ALU_XOR, ALU_Imm: in std_logic;
        Ddatabus: inout std_logic_vector(n-1 downto 0);
        regfile: inout std_logic_vector(2*n-1 downto 0)
    );
end entity ALU;

architecture ALU_RTL of ALU is
    signal result: signed(n-1 downto 0);
    
    signal A: std_logic_vector(n-1 downto 0);
    signal B: std_logic_vector(n-1 downto 0);
begin
    Ddatabus <= std_logic_vector(result) when DAT_ALU = '1' else (others => 'Z');
    --we only write the first n bits of the ALU bus as we only have one piece of data to transfer
    regfile(n-1 downto 0) <= std_logic_vector(result) when REGF_ALU = '1' else (others => 'Z');
    regfile(2*n-1 downto n) <= (others => 'Z'); --we are never writing to this

    A <= regfile(2*n-1 downto n);
    B <= Ddatabus when ALU_Imm = '1' else regfile(n-1 downto 0);
    s0: process (CLK, RST) is
    begin
        if RST='1' then
            result <= (others => '0');
        elsif rising_edge(CLK) then
            if ALU_ADD = '1' then
                result <= signed(A) + signed(B);
            elsif ALU_SUB = '1' then
                result <= signed(A) - signed(B);
            elsif ALU_AND = '1' then
                result <= signed(A and B);
            elsif ALU_OR = '1' then
                result <= signed(A or B);
            elsif ALU_NOT = '1' then
                result <= signed(not B);
            elsif ALU_XOR = '1' then
                result <= signed(A xor B);
            end if;
        end if;
    end process s0;
end architecture ALU_RTL;