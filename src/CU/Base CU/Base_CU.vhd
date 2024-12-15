----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 20:22:12
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.pomegranate_conf.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control_Unit is
    Port (
        op: in opcode;
        Z_flag, C_flag, N_flag, P_flag: in std_logic;
        ALU_EN, ALU_IMM, MEM_WE, DAT_MEM, PC_INC, DAT_PC, PC_LDA, RF_WE, DAT_RF, STK_EN, STK_INC: out std_logic;
        ALU_OP: out std_logic_vector(2 downto 0);
        SRC_IMM: out std_logic_vector(1 downto 0)
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
--signals
--flag registers
signal Z, C, N, P: std_logic;
--interrupt enable
signal IE: std_logic;
begin

--COMBINATIONAL PART - decoder
c0: process (op) is
begin
    --reset all control signals
    ALU_EN <= '0';
    ALU_IMM <= '0';
    MEM_WE <= '0';
    DAT_MEM <= '0';
    PC_INC <= '0';
    DAT_PC <= '0';
    PC_LDA <= '0';
    RF_WE <= '0';
    DAT_RF <= '0';
    STK_EN <= '0';
    STK_INC <= '0';
    SRC_IMM <= "00";
    ALU_OP <= "000";
    
    --get flags
    Z <= Z_flag;
    C <= C_flag;
    N <= N_flag;
    P <= P_flag;
    
    --REGISTER FORMAT?
    if RFormatCheck(op) = '1' then
        PC_INC <= '1';
        case (op) is
            when SIE =>
                IE <= '1';
            when CIE =>
                IE <= '0';
            when SCF =>
                C <= '1';
            when CCF =>
                C <= '0';
            when ADD | ADDI =>
                ALU_EN <= '1';
                ALU_OP <= "000";
                RF_WE <= '1';
                if op = ADDI then
                    ALU_IMM <= '1';
                end if;
            when SUB | SUBI =>
                ALU_EN <= '1';
                ALU_OP <= "001";
                RF_WE <= '1';
                if op = SUBI then
                    ALU_IMM <= '1';
                end if;
            when DAND | ANDI =>
                ALU_EN <= '1';
                ALU_OP <= "010";
                RF_WE <= '1';
                if op = ANDI then
                    ALU_IMM <= '1';
                end if;
            when DOR | ORI =>
                ALU_EN <= '1';
                ALU_OP <= "011";
                RF_WE <= '1';
                if op = ORI then
                    ALU_IMM <= '1';
                end if;
            when DNOT =>
                ALU_EN <= '1';
                ALU_OP <= "100";
                RF_WE <= '1';
            when DXOR =>
                ALU_EN <= '1';
                ALU_OP <= "101";
                RF_WE <= '1';
            when LSL =>
                ALU_EN <= '1';
                ALU_OP <= "110";
                RF_WE <= '1';
            when LSR =>
                ALU_EN <= '1';
                ALU_OP <= "111";
                RF_WE <= '1';
            when others => --CPY
                RF_WE <= '1';
                DAT_RF <= '1';
        end case;
    --BRANCH FORMAT?
    elsif BFormatCheck(op) = '1' then
        if op = NOP then
            PC_INC <= '1';
        else
            --if the relevant flag is not set...
            -- increment the program counter rather than load it
            case (op) is
                when BRZ =>
                    if Z = '0' then
                        PC_INC <= '1';
                    end if;
                when BRC =>
                    if C = '0' then
                        PC_INC <= '1';
                    end if;
                when BRN =>
                    if N = '0' then
                        PC_INC <= '1';
                    end if;
                when BRP =>
                    if P = '0' then
                        PC_INC <= '1';
                    end if;
                when others =>
                    if not(op = BRA) then
                        --only for subroutine calls and returns
                        STK_EN <= '1';
                        if (op = CALL) then
                            --only if a call instruction
                            STK_INC <= '1';
                            DAT_PC <= '1';
                            MEM_WE <= '1';
                        else --if it is a return instruction
                            PC_LDA <= '1';
                            DAT_MEM <= '1';
                        end if;
                    end if;
            end case;
        end if;
    --LOAD FORMAT?
    elsif LFormatCheck(op) = '1' then
        PC_INC <= '1';
        RF_WE <= '1';
        if (op = LDRI) then
            SRC_IMM <= "10";
        elsif (op = POP) then
            STK_EN <= '1';
            DAT_MEM <= '1';
        else
            DAT_MEM <= '1';
        end if;
    --STORE FORMAT?
    else
        PC_INC <= '1';
        MEM_WE <= '1';
        if (op = STRI) then
            SRC_IMM <= "11";
        elsif (op = PUSH) then
            STK_EN <= '1';
            STK_INC <= '1';
            DAT_RF <= '1';
        else
            DAT_RF <= '1';
        end if;
    end if;
end process c0;

end Behavioral;
