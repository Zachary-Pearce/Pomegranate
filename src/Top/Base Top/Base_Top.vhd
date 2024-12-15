----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2024 00:06:11
-- Design Name: 
-- Module Name: Base_Top - Behavioral
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

entity Base_Top is
    Port (
        CLK, RST: in std_logic;
        --bus outputs for testing
        Data_Address_Bus: inout std_logic_vector(Maddr_w-1 downto 0);
        Data_Bus: inout std_logic_vector(word_w-1 downto 0);
        Instruction_Bus: inout std_logic_vector(instruction_w-1 downto 0);
        Instruction_Address_Bus: inout std_logic_vector(Iaddr_w-1 downto 0);
        --opcode output for testing
        op: out opcode;
        --contron signal output for testing
        ALU_EN1, ALU_IMM1, MEM_WE1, DAT_MEM1, PC_INC1, DAT_PC1, PC_LDA1, RF_WE1, DAT_RF1, STK_EN1, STK_INC1: out std_logic;
        ALU_OP1: out std_logic_vector(2 downto 0);
        SRC_IMM1: out std_logic_vector(1 downto 0)
    );
end Base_Top;

architecture RTL of Base_Top is

--components
--control unit
component Control_Unit is
    Port (
        op: in opcode;
        Z_flag, C_flag, N_flag, P_flag: in std_logic;
        ALU_EN, ALU_IMM, MEM_WE, DAT_MEM, PC_INC, DAT_PC, PC_LDA, RF_WE, DAT_RF, STK_EN, STK_INC: out std_logic;
        ALU_OP: out std_logic_vector(2 downto 0);
        SRC_IMM: out std_logic_vector(1 downto 0)
    );
end component Control_Unit;
--ALU
component ALU is
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
end component ALU;
--Data Memory
component Memory_ITF is
    generic (
        n: natural := 8; --data width
        k: natural := 8  --memory address width
    );
    Port (
        --control signals
        CLK: in std_logic;
        WE, DAT_MEM: in std_logic;
        --bus connections
        data: inout std_logic_vector(n-1 downto 0);
        address: in std_logic_vector(k-1 downto 0)
    );
end component Memory_ITF;
--Program Counter
component PC is
    generic (
        a: natural := 8
    );
    Port (
        CLK, RST: in std_logic;
        PC_INC, DAT_PC, PC_LDA: in std_logic;
        data_bus: inout std_logic_vector(a-1 downto 0);
        instruction_bus: in std_logic_vector(a-1 downto 0);
        address_out: out std_logic_vector(a-1 downto 0)
    );
end component PC;
--Stack Pointer
component Stack_Pointer is
    generic (
        a: natural := 8 --memory address width
    );
    Port (
        CLK, RST: in std_logic;
        enable, Pntr_INC: in std_logic;
        address: out std_logic_vector(a-1 downto 0)
    );
end component Stack_Pointer;
--Program Memory
component program_memory is
    generic (
        i: natural := 8; --instruction width
        k: natural := 8  --memory address width
    );
    Port (
        address: in std_logic_vector(k-1 downto 0);
        dout: out std_logic_vector(i-1 downto 0)
    );
end component program_memory;
--Register File
component regFile is
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
end component regFile;

--signals
--CONTROL SIGNALS
signal ALU_EN, ALU_IMM, MEM_WE, DAT_MEM, PC_INC, DAT_PC, PC_LDA, RF_WE, DAT_RF, STK_EN, STK_INC: std_logic;
signal ALU_OP: std_logic_vector(2 downto 0);
signal SRC_IMM: std_logic_vector(1 downto 0);
--FLAGS
signal Z_flag, C_flag, N_flag, P_flag: std_logic;
--ALU/RF
signal R_source, R_target: std_logic_vector(word_w-1 downto 0);

begin

--Control unit initialisation
CU_inst: Control_Unit port map (
    op => slv2op(Instruction_Bus(instruction_w-1 downto instruction_w-op_w)),
    Z_flag => Z_flag, C_flag => C_flag, N_flag => N_flag, P_flag => P_flag,
    ALU_EN => ALU_EN, ALU_IMM => ALU_IMM, MEM_WE => MEM_WE, DAT_MEM => DAT_MEM,
    PC_INC => PC_INC, DAT_PC => DAT_PC, PC_LDA => PC_LDA, RF_WE => RF_WE, DAT_RF => DAT_RF, STK_EN => STK_EN, STK_INC => STK_INC, SRC_IMM => SRC_IMM,
    ALU_OP => ALU_OP
);

--ALU initialisation
ALU_inst: ALU generic map (word_w) port map (
    ALU_EN => ALU_EN, ALU_IMM => ALU_IMM,
    ALU_OP => ALU_OP,
    Rs => R_source, Rt => R_target, Immediate => Instruction_Bus(7 downto 0),
    Z => Data_Bus,
    C_flag => C_flag, Z_flag => Z_flag, N_flag => N_flag, P_flag => P_flag
);

--Data memory initialisation
DataMem_inst: Memory_ITF generic map (word_w, Maddr_w) port map (
    CLK => CLK,
    WE => MEM_WE, DAT_MEM => DAT_MEM,
    data => Data_Bus,
    address => Data_Address_Bus
);

--PC initialisation
PC_inst: PC generic map (Iaddr_w) port map (
    CLK => CLK, RST => RST,
    PC_INC => PC_INC, DAT_PC => DAT_PC, PC_LDA => PC_LDA,
    data_bus => Data_Bus,
    instruction_bus => Instruction_Bus(7 downto 0),
    address_out => Instruction_Address_Bus
);

--Stack pointer initialisation
Pntr_inst: Stack_Pointer generic map (Iaddr_w) port map (
    CLK => CLK, RST => RST, enable => STK_EN, Pntr_INC => STK_INC, address => Data_Address_Bus
);

InstructionMem_inst: program_memory generic map (instruction_w, Iaddr_w) port map (
    address => Instruction_Address_Bus,
    dout => Instruction_Bus
);

RegFile_inst: regFile generic map (word_w, Maddr_w, Raddr_w) port map (
    CLK => CLK, ARST => RST, R_write_enable => RF_WE, data_bus_R_file => DAT_RF,
    source_register => Instruction_Bus(10 downto 8),
    target_register => Instruction_Bus(13 downto 11),
    destination_register => Instruction_Bus(18 downto 16),
    data_bus => Data_Bus,
    source_out => R_source, target_out => R_target
);

--COMBINATIONAL PART - drive the databus with a required immediate
c0: process (SRC_IMM) is
begin
    case (SRC_IMM) is
        --decide which immediate should be placed on the data bus
        when "11" =>
            Data_Bus <= Instruction_Bus(18 downto 11);
        when "10" =>
            Data_Bus <= Instruction_Bus(15 downto 8);
        when "01" =>
            Data_Bus <= Instruction_Bus(7 downto 0);
        when others =>
            --if we don't need an immediate, don't drive the data bus so other components can
            Data_Bus <= (others => 'Z');
    end case;
end process c0;

op <= slv2op(Instruction_Bus(instruction_w-1 downto instruction_w-op_w));
--output control signals
ALU_EN1 <= ALU_EN;
ALU_IMM1 <= ALU_IMM;
MEM_WE1 <= MEM_WE;
DAT_MEM1 <= DAT_MEM;
PC_INC1 <= PC_INC;
DAT_PC1 <= DAT_PC;
PC_LDA1 <= PC_LDA;
RF_WE1 <= RF_WE;
DAT_RF1 <= DAT_RF;
STK_EN1 <= STK_EN;
STK_INC1 <= STK_INC;
SRC_IMM1 <= SRC_IMM;
ALU_OP1 <= ALU_OP;

end architecture RTL;
