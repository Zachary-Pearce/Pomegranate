library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.pomegranate_conf.all;

entity ALU is
    generic (
        n: natural := 8 --data width
    );
    Port (
        ALU_EN, ALU_IMM: in std_logic;
        ALU_OP: in std_logic_vector(2 downto 0);
        Rs, Rt, Immediate: in std_logic_vector(n-1 downto 0);
        Z: out std_logic_vector(n-1 downto 0);
        C_flag, Z_flag, N_flag, P_flag: out std_logic
    );
end entity ALU;

architecture ALU_RTL of ALU is
--signals
signal result_reg, add_result, sub_result, and_result, or_result, xor_result, not_result, shift_left_result, shift_right_result: std_logic_vector(n downto 0);
signal source, target: std_logic_vector(n-1 downto 0);
begin
    --COMBINATIONAL PART
    --get the source and target
    -- the target will either be from the register file or an immediate value
    source <= Rs;
    target <= Immediate when ALU_IMM = '1' else Rt;
    
    --add operation
    add_result <= std_logic_vector(unsigned('0' & source) + unsigned('0' & target)) when ALU_OP = "000" else (others => '0');
    --subtract operation
    sub_result <= '0' & std_logic_vector(unsigned(source) - unsigned(target)) when ALU_OP = "001" else (others => '0');
    --logical and operation
    and_result <= '0' & source and '0' & target when ALU_OP = "010" else (others => '0');
    --logical or operation
    or_result <= '0' & source or '0' & target when ALU_OP = "011" else (others => '0');
    --logical XOR operation
    xor_result <= '0' & source xor '0' & target when ALU_OP = "100" else (others => '0');
    --logical NOT operation
    not_result <= '0' & (not source) when ALU_OP = "101" else (others => '0');
    --logical shift operation
    shift_left_result <= '0' & std_logic_vector(shift_left(unsigned(source), 1)) when ALU_OP = "110" else (others => '0');
    shift_right_result <= '0' & std_logic_vector(shift_right(unsigned(source), 1)) when ALU_OP = "111" else (others => '0');
    
    --final result
    result_reg <= add_result or sub_result or and_result or or_result or xor_result or not_result or shift_left_result or shift_right_result;
    
    --OUTPUT PART
    Z <= result_reg(n-1 downto 0) when ALU_EN = '1' else (others => 'Z');
    Z_flag <= '1' when result_reg(n-1 downto 0) = zeros else '0';
    N_flag <= result_reg(n-1);
    P_flag <= not result_reg(n-1);
    C_flag <= result_reg(n);
end ALU_RTL;
