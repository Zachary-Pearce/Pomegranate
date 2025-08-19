library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic (
        WORD_WIDTH: natural := 8 --data width
    );
    Port (
        ALU_EN, ALU_IMM: in std_logic;
        ALU_OP: in std_logic_vector(2 downto 0);
        Rs, Rt, Immediate: in std_logic_vector(WORD_WIDTH-1 downto 0);
        result_out: out std_logic_vector(WORD_WIDTH-1 downto 0);
        C_flag, Z_flag, N_flag, P_flag: out std_logic
    );
end entity ALU;

architecture ALU_RTL of ALU is
--signals
signal result: std_logic_vector(WORD_WIDTH downto 0);
signal source, target: std_logic_vector(WORD_WIDTH-1 downto 0);
begin
    --COMBINATIONAL PART
    --get the source and target
    -- the target will either be from the register file or an immediate value
    source <= Rs;
    target <= Immediate when ALU_IMM = '1' else Rt;
    
    --select ALU operation
    with ALU_OP select
        result  <= std_logic_vector(unsigned('0' & source) + unsigned('0' & target)) when "000",
                <= '0' & std_logic_vector(unsigned(source) - unsigned(target)) when "001",
                <= '0' & source and '0' & target when "010",
                <= '0' & source or '0' & target when "011",
                <= '0' & source xor '0' & target when "100",
                <= '0' & (not source) when "101",
                <= std_logic_vector(shift_left(unsigned('0' & source), 1)) when "110",
                <= std_logic_vector(shift_right(unsigned('0' & source), 1)) when "111";
    
    --OUTPUT PART
    result_out <= result(WORD_WIDTH-1 downto 0) when ALU_EN = '1' else (others => 'Z');
    Z_flag <= '1' when unsigned(result(WORD_WIDTH-1 downto 0)) = 0 else '0';
    N_flag <= result(WORD_WIDTH-1); --2's complement, if the MSB is set then the result is negative
    P_flag <= not result(WORD_WIDTH-1); --2's complement, if the MSB is cleared then the result is positive
    C_flag <= result(WORD_WIDTH); --the last bit of the result signal is the carry
end ALU_RTL;
