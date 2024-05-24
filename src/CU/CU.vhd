library IEEE;
use IEEE.std_logic_1164.all;
use WORK.cpu_defs.all;

entity CU is
    port (
        CLK, ARST: in std_logic;
        z_flag, p_flag: in std_logic;
        --PC control signals
        LDA_PC, INC_PC, PC_ADR: out std_logic;
        --IR control signals
        IR_PDAT, IR_DDAT, ADR_IR: out std_logic;
        --data memory control signals
        DCS, DWE, DRE, DADR_MAR, DMDR_DAT, DDAT_MDR: out std_logic;
        --program memory control signals
        PCS, PRE, PADR_MAR, PMDR_DAT: out std_logic;
        --register file control signals
        RWE, RRE, CMPE, ALU_REGF, LDA_REGF, DAT_REGF: out std_logic;
        --ALU control signals
        REGF_ALU, DAT_ALU, ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_NOT, ALU_XOR, ALU_Imm: out std_logic;
        --port A control signals
        PORTA_DAT, DAT_PORTA, PORTA_OUT, PORTA_IN, AWE: out std_logic;
        --port B control signals
        PORTB_DAT, DAT_PORTB, PORTB_OUT, PORTB_IN, BWE: out std_logic;
        op: in opcode
    );
end entity CU;

architecture CU_RTL of CU is
    type state is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10);
    signal present_state, next_state: state;
begin
    --sequential setting of state
    s: process (CLK, ARST)
    begin
        if (ARST = '1') then
            present_state <= s10;
        elsif rising_edge(CLK) then
            present_state <= next_state;
        end if;
    end process s;

    --combinational next state and output logic
    c0: process (present_state, z_flag, p_flag, op)
    begin
        --at the beginning of the clock cycle reset all control signals
        --PC control signals
        LDA_PC <= '0';
        INC_PC <= '0';
        PC_ADR <= '0';
        --IR control signals
        IR_PDAT <= '0';
        IR_DDAT <= '0';
        ADR_IR <= '0';
        --data memory control signals
        DCS <= '0';
        DWE <= '0';
        DRE <= '0';
        DADR_MAR <= '0';
        DMDR_DAT <= '0';
        DDAT_MDR <= '0';
        --program memory control signals
        PCS <= '0';
        PRE <= '0';
        PADR_MAR <= '0';
        PMDR_DAT <= '0';
        --register file control signals
        RWE <= '0';
        RRE <= '0';
        CMPE <= '0';
        ALU_REGF <= '0';
        LDA_REGF <= '0';
        DAT_REGF <= '0';
        --ALU control signals
        REGF_ALU <= '0';
        DAT_ALU <= '0';
        ALU_ADD <= '0';
        ALU_SUB <= '0';
        ALU_AND <= '0';
        ALU_OR <= '0';
        ALU_NOT <= '0';
        ALU_XOR <= '0';
        ALU_Imm <= '0';
        --port A control signals
        PORTA_DAT <= '0';
        DAT_PORTA <= '0';
        PORTA_OUT <= '0';
        PORTA_IN <= '0';
        AWE <= '0';
        --port B control signals
        PORTB_DAT <= '0';
        DAT_PORTB <= '0';
        PORTB_OUT <= '0';
        PORTB_IN <= '0';
        BWE <= '0';
            
        --next state state logic
        case present_state is
            when s0 => --fetch stage
                --PC <- PC + 1
                LDA_PC <= '1';
                INC_PC <= '1';
                --set the next state
                next_state <= s10;
            when s1 => --decode stage
                --IR <- PMDR
                PMDR_DAT <= '1';
                IR_PDAT <= '1';
                --set the next state
                next_state <= s2;
            when s2 =>
                --execute the corresponding instruction
                if RFormatCheck(op) = '1' then
                    if op = MOV then
                        --fetch contents of source and target register and put on ALU bus
                        -- ALU <- regfile(s) & regfile(t)
                        ADR_IR <= '1';
                        RRE <= '1';
                        REGF_ALU <= '1';

                        --set the next state
                        next_state <= s3;
                    else
                        --ALU <- source & target
                        ADR_IR <= '1';
                        RRE <= '1';
                        REGF_ALU <= '1';

                        --set the relevant operation control signal
                        case op is
                            when ADD =>
                                ALU_ADD <= '1';
                            when SUB =>
                                ALU_SUB <= '1';
                            when DAND =>
                                ALU_AND <= '1';
                            when DOR =>
                                ALU_OR <= '1';
                            when DNOT =>
                                ALU_NOT <= '1';
                            when DXOR =>
                                ALU_XOR <= '1';
                            when others =>
                                ALU_ADD <= '0';
                                ALU_SUB <= '0';
                                ALU_AND <= '0';
                                ALU_OR <= '0';
                                ALU_NOT <= '0';
                                ALU_XOR <= '0';
                                ALU_Imm <= '0';
                        end case;

                        --set the next state
                        next_state <= s4;
                    end if;
                elsif BFormatCheck(op) = '1' then
                    if op = CMP then
                        --addrbus <- s
                        ADR_IR <= '1';
                        --perform register compare
                        RRE <= '1';
                        CMPE <= '1';
                        --set the next state
                        next_state <= s0;
                    elsif op = BRA then
                        --PC <- MDR
                        PMDR_DAT <= '1';
                        LDA_PC <= '1';
                        --we need to bring the address jumped to to the IR without incrementing the program counter
                        --set the next state
                        next_state <= s10;
                    elsif op = BRZ then
                        if z_flag = '1' then
                            --PC <- MDR
                            PMDR_DAT <= '1';
                            ADR_IR <= '1';
                            --we need to bring the address jumped to to the IR without incrementing the program counter
                            --set the next state
                            next_state <= s10;
                        else
                            --otherwise
                            --nothing happens and we fetch the next instruction
                            --set the next state
                            next_state <= s0;
                        end if;
                    elsif op = BRP then
                        if p_flag = '1' then
                            --PC <- MDR
                            PMDR_DAT <= '1';
                            ADR_IR <= '1';
                            --we need to bring the address jumped to to the IR without incrementing the program counter
                            --set the next state
                            next_state <= s10;
                        else
                            --otherwise
                            --nothing happens and we fetch the next instruction
                            --set the next state
                            next_state <= s0;
                        end if;
                    else
                        --when failed go back to state 0 and fetch next instruction
                        --set the next state
                        next_state <= s0;
                    end if;
                elsif IFormatCheck(op) = '1' then
                    --ALU <- regfile(s)
                    ADR_IR <= '1';
                    RRE <= '1';
                    ALU_REGF <= '1';
                    --databus <- immediate operand
                    IR_DDAT <= '1';
                    --set the relevant operation control signal
                    ALU_Imm <= '1';
                    case op is
                        when ADDI =>
                            ALU_ADD <= '1';
                        when SUBI =>
                            ALU_SUB <= '1';
                        when ANDI =>
                            ALU_AND <= '1';
                        when ORI =>
                            ALU_OR <= '1';
                        when XORI =>
                            ALU_XOR <= '1';
                        when others =>
                            ALU_ADD <= '0';
                            ALU_SUB <= '0';
                            ALU_AND <= '0';
                            ALU_OR <= '0';
                            ALU_XOR <= '0';
                            ALU_Imm <= '0';
                    end case;
                    --set the next state
                    next_state <= s5;
                elsif IOFormatCheck(op) = '1' then
                    --are we reading from the port?
                    if op = AOUTC or op = ADOUT or op = BOUTC or op = BDOUT then
                        --if not then write to the port
                        --addrbus <- t
                        ADR_IR <= '1';
                        --databus <- regfile(t)
                        RRE <= '1';
                        DAT_REGF <= '1';
                        --IO port <- databus
                        if op = BDOUT or op = BOUTC then
                            --write to port B
                            BWE <= '1';
                            PORTB_DAT <= '1';
                        elsif op = ADOUT or op = AOUTC then
                            --write to port A
                            AWE <= '1';
                            PORTA_DAT <= '1';
                        end if;
                        --set the next state
                        next_state <= s7;
                    else
                        --write value from the outside world
                        if op = INPA then
                            --write to port A
                            AWE <= '1';
                            PORTA_IN <= '1';
                        elsif op = INPB then
                            --write to port B
                            BWE <= '1';
                            PORTB_IN <= '1';
                        end if;
                        --set the next state
                        next_state <= s6;
                    end if;
                elsif LFormatCheck(op) = '1' then
                    --MAR <- operand
                    ADR_IR <= '1';
                    DADR_MAR <= '1';
                    --MDR <- RAM(operand)
                    DCS <= '1';
                    DRE <= '1';
                    --set the next state
                    next_state <= s8;
                elsif SFormatCheck(op) = '1' then
                    --addrbus <- t
                    ADR_IR <= '1';
                    --databus <- regfile(t)
                    RRE <= '1';
                    DAT_REGF <= '1';
                    --MDR <- databus
                    DDAT_MDR <= '1';
                    --set the next state
                    next_state <= s9;
                else --otherwise it is a no operation (NOP) instruction
                    next_state <= s0;
                end if;
            when s3 =>
                --regfile(d) <- ALU
                ADR_IR <= '1';
                RWE <= '1';
                REGF_ALU <= '1';
                --set the next state
                next_state <= s0;
            when s4 =>
                --addrbus <- d
                ADR_IR <= '1';
                --ALU bus <- result
                REGF_ALU <= '1';
                --Regfile(d) <- ALU bus
                RWE <= '1';
                REGF_ALU <= '1';
                --set the next state
                next_state <= s0;
            when s5 =>
                --databus <- result
                DAT_ALU <= '1';
                --addrbus <- d
                ADR_IR <= '1';
                --regfile(d) <- databus
                RWE <= '1';
                --set the next state
                next_state <= s0;
            when s6 =>
                --addrbus <- d
                ADR_IR <= '1';
                --databus <- port
                if op = INPA then
                    --read port A
                    DAT_PORTA <= '1';
                elsif op = INPB then
                    --read port B
                    DAT_PORTB <= '1';
                end if;
                --regfile(d) <- databus
                RWE <= '1';
                --set the next state
                next_state <= s0;
            when s7 =>
                --outside world <- port
                if op = BDOUT or op = BOUTC then
                    --read from port B
                    PORTB_OUT <= '1';
                elsif op = ADOUT or op = AOUTC then
                    --read from port A
                    PORTA_OUT <= '1';
                end if;
               --set the next state
                next_state <= s0;
            when s8 =>
                --databus <- MDR
                DMDR_DAT <= '1';
                --addrbus <- d
                ADR_IR <= '1';
                --regfile(d) <- databus
                RWE <= '1';
                --set the next state
                next_state <= s0;
            when s9 =>
                --MAR <- data address
                ADR_IR <= '1';
                --RAM(MAR) <- MDR
                DADR_MAR <= '1';
                DCS <= '1';
                DWE <= '1';
                --set the next state
                next_state <= s0;
            when s10 => --fetch stage
                --PMAR <- PC
                PC_ADR <= '1';
                PADR_MAR <= '1';
                --PMDR <- ROM(PMAR)
                PCS <= '1';
                PRE <= '1';
                --skip straight to decoding
                --set the next state
                next_state <= s1;
        end case;
    end process c0;
end architecture CU_RTL;