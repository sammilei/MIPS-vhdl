-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: datapath
--
-- Combines other modules with pipeline registers to form the pipelined datapath 
-- used by all instructions. Connects the components to each other with signals.
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity datapath is -- pipelined MIPS datapath
   port (
     clk, reset        : in STD_LOGIC;
     --tb_instr     : in std_logic_vector (31 downto 0);
     zero              : out STD_LOGIC;
     instr             : out std_logic_vector(31 downto 0);
     rs_val, rt_val    : out std_logic_vector(31 downto 0);
     branch_addr       : out std_logic_vector(31 downto 0);
     PC                : out STD_LOGIC_VECTOR(31 downto 0);
     ALUOut, writedata : out STD_LOGIC_VECTOR(31 downto 0);
     dmem_read         : out std_logic_vector(31 downto 0);
     reg_to_write      : out std_logic_vector(4 downto 0);
     ctrl_signals      : out std_logic_vector(8 downto 0));
end datapath;


architecture struct of datapath is

  component imem is -- instruction memory
    port (
        reset: in STD_LOGIC;
        -- receives address from PC
        address_in: in STD_LOGIC_VECTOR(31 downto 0);
        -- outputs a 32-bit instruction
        instruction_out: out STD_LOGIC_VECTOR(31 downto 0));
end component;
  
  component register_block 
    port (
      rd, rs, rt     : in STD_LOGIC_VECTOR(4 downto 0);
      write_data     : in STD_LOGIC_VECTOR (31 downto 0);
      clk            : in std_logic;
      write_enable   : in std_logic;
      rs_out, rt_out : out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  component control is
    port (
      opcode     : in std_logic_vector(5 downto 0);
      reset	 : in std_logic;
      EX         : out std_logic_vector(3 downto 0);
      M          : out std_logic_vector(2 downto 0);
      WB         : out std_logic_vector(1 downto 0));
  end component;

  component ALU is
    Port (
      A, B         : in STD_LOGIC_VECTOR(31 downto 0);              -- operands
      ALU_control_input : in STD_LOGIC_VECTOR (3 downto 0);	  -- operation (4-bit ALUControl)
      ALU_Out      : out STD_LOGIC_VECTOR(31 downto 0);             -- 32-bit result of ALU operation
      CarryOut     : out std_logic;			          -- carryout Flag
      ZERO         : out std_logic);			          -- Flag for branching
  end component;

  component ALU_ctl is
    Port ( 
      funct : in STD_LOGIC_VECTOR (5 downto 0);
      ALU_op : in STD_LOGIC_VECTOR(1 downto 0);
      ALU_control_input: out STD_LOGIC_VECTOR(3 downto 0));
  end component;

  component adder
    port (
        a: in STD_LOGIC_VECTOR(31 downto 0);
        b: in STD_LOGIC_VECTOR(31 downto 0);
        y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  
  component sl2
    port (
      signExtendedInput : in STD_LOGIC_VECTOR(31 downto 0);
      shiftedOut        : out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  
  component signext
    port (
        signedIn  : in STD_LOGIC_VECTOR(15 downto 0);
        signedOut : out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  component flopr
      generic (width: integer);
    port (
      clk   : in STD_LOGIC;
      reset : in STD_LOGIC;
      d     : in STD_LOGIC_VECTOR(width-1 downto 0);
      q     : out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;

  component mux2
    generic(width: integer);
    port (
        d0        : in STD_LOGIC_VECTOR(width-1 downto 0);
        d1        : in STD_LOGIC_VECTOR(width-1 downto 0);
        selector  : in STD_LOGIC;
        y         : out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;

  component dmem is -- data memory
  port (
    clk          : in STD_LOGIC;
    reset        : in STD_LOGIC;
    readEnabled  : in STD_LOGIC;
    writeEnabled : in STD_LOGIC;
    memAddress   : in STD_LOGIC_VECTOR (31 downto 0);
    writeData    : in STD_LOGIC_VECTOR (31 downto 0);
    readData     : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

------------------------------------------------------------------
------- Intermediate registers -----------------------------------
------------------------------------------------------------------

  component IF_ID_register is
  port (
      PC    : in std_logic_vector(31 downto 0);
      instr : in std_logic_vector(31 downto 0);
      reset : in std_logic;
      clk   : in std_logic;
      instr_out : out std_logic_vector(31 downto 0);
      PC_out      : out std_logic_vector(31 downto 0));
end component;

  component ID_EX_register is
    port (
      PC             : in std_logic_vector(31 downto 0);
      rs_val, rt_val : in std_logic_vector(31 downto 0);
      imm            : in std_logic_vector(31 downto 0);
      rs, rd         : in std_logic_vector(4 downto 0);
      reset	     : in std_logic;
      clk            : in std_logic;

        
      EX                : in std_logic_vector(3 downto 0);
      M                 : in std_logic_vector(2 downto 0);
      WB                : in std_logic_vector(1 downto 0);

      PC_out                 : out std_logic_vector(31 downto 0);
      rs_val_out, rt_val_out : out std_logic_vector(31 downto 0);
      imm_out                : out std_logic_vector(31 downto 0);
      rs_out, rd_out         : out std_logic_vector(4 downto 0);

      EX_RegDst, EX_ALUSrc  : out std_logic;
      EX_ALUOp              : out std_logic_vector(1 downto 0);
      M_out                 : out std_logic_vector(2 downto 0);
      WB_out                : out std_logic_vector(1 downto 0));
  end component;

  component EX_MEM_register is
    port (
      branch_addr    : in std_logic_vector(31 downto 0);
      zero           : in std_logic;
      ALU_result     : in std_logic_vector(31 downto 0);
      write_data     : in std_logic_vector(31 downto 0);
      reg_to_write   : in std_logic_vector(4 downto 0);
      reset	     : in std_logic;
      clk            : in std_logic;

      M                 : in std_logic_vector(2 downto 0);
      WB                : in std_logic_vector(1 downto 0);

      branch_addr_out    : out std_logic_vector(31 downto 0);
      zero_out           : out std_logic;
      ALU_result_out     : out std_logic_vector(31 downto 0);
      write_data_out     : out std_logic_vector(31 downto 0);
      reg_to_write_out   : out std_logic_vector(4 downto 0);

      M_Branch, M_MemRead, M_MemWrite : out std_logic;
      WB_out                          : out std_logic_vector(1 downto 0));
  end component;

  component MEM_WB_register is
    port (
      reg_data       : in std_logic_vector(31 downto 0);
      mem_data       : in std_logic_vector(31 downto 0);
      reg_to_write   : in std_logic_vector(4 downto 0);
      reset	     : in std_logic;
      clk            : in std_logic;

      WB                : in std_logic_vector(1 downto 0);

      reg_data_out     : out std_logic_vector(31 downto 0);
      mem_data_out     : out std_logic_vector(31 downto 0);
      reg_to_write_out   : out std_logic_vector(4 downto 0);

      WB_RegWrite, WB_MemtoReg : out std_logic);
  end component;

------------------------------------------------------------------
--END-- Intermediate registers -----------------------------------
------------------------------------------------------------------
  
  -- IF Wires
  signal PCNext, PCNextBr, PCPlus4, PCBranch: STD_LOGIC_VECTOR(31 downto 0);
  signal PCFromFlop: std_logic_vector(31 downto 0);
  signal instrFromMem: std_logic_vector(31 downto 0);

  -- ID wires
  signal instrFromIFID: std_logic_vector(31 downto 0);
  signal PCFromIFID: std_logic_vector(31 downto 0);
  signal rsValFromReg, rtValFromReg: std_logic_vector(31 downto 0);
  signal immSignExt: std_logic_vector(31 downto 0);
  signal EXFromCtrl: std_logic_vector(3 downto 0);
  signal MFromCtrl: std_logic_vector(2 downto 0);
  signal WBFromCtrl: std_logic_vector(1 downto 0);

  -- EX wires
  signal PCFromIDEX: std_logic_vector(31 downto 0);
  signal rsValFromIDEX, rtValFromIDEX: std_logic_vector(31 downto 0);
  signal immFromIDEX: std_logic_vector(31 downto 0);
  signal rsFromIDEX, rdFromIDEX: std_logic_vector(4 downto 0);
  signal EX_RegDst, EX_ALUSrc: std_logic;
  signal EX_ALUOp: std_logic_vector(1 downto 0);
  signal MFromIDEX: std_logic_vector(2 downto 0);
  signal WBFromIDEX: std_logic_vector(1 downto 0);
  signal ALUSrcMuxOut: std_logic_vector(31 downto 0);
  signal ALUControlOut: std_logic_vector(3 downto 0);
  signal ALUResult: std_logic_vector(31 downto 0);
  signal ALUZero, ALUCarry: std_logic;
  signal immShift: std_logic_vector(31 downto 0);
  signal branchAddr: std_logic_vector(31 downto 0);
  signal regDestMuxOut: std_logic_vector(4 downto 0);

  -- MEM wires
  signal zeroFromEXMEM: std_logic;
  signal ALUResultFromEXMEM: std_logic_vector(31 downto 0);
  signal writeDataFromEXMEM: std_logic_vector(31 downto 0);
  signal regToWriteFromEXMEM: std_logic_vector(4 downto 0);
  signal M_Branch, M_MemRead, M_MemWrite: std_logic;
  signal WBFromEXMEM: std_logic_vector(1 downto 0);
  signal PCSrc: std_logic;
  signal readDataFromDMEM: std_logic_vector(31 downto 0);

  -- WB wires
  signal ALUResultFromMEMWB, memDataFromMEMWB: std_logic_vector(31 downto 0);
  signal regToWriteFromMEMWB: std_logic_vector(4 downto 0);
  signal regDataToWrite: std_logic_vector(31 downto 0);
  signal WB_RegWrite, WB_MemtoReg: std_logic;

begin
process(clk, reset)
begin
  instr <= instrFromMem;
  rs_val <= rsValFromReg;
  rt_val <= rtValFromReg;
  branch_addr <= PCBranch;
  PC <= PCFromFlop;
  ALUOut <= ALUResult;
  writedata <= regDataToWrite;
  dmem_read <= readDataFromDMEM;
  reg_to_write <= regToWriteFromMEMWB;
  ctrl_signals(8 downto 5) <= EXFromCtrl;
  ctrl_signals(4 downto 2) <= MFromCtrl;
  ctrl_signals(1 downto 0) <= WBFromCtrl;

  

  if reset = '1' then
    PCNext <= (others => '0');
  end if;
end process;

-- IF logic
  PCSrcMux: mux2 generic map(32) 
    port map(PCPlus4, PCBranch, PCSrc, PCNext);
  PCreg: flopr generic map(32) 
    port map(clk, reset, PCnext, PCFromFlop);
  PCadd1: adder 
    port map(PCFromFlop, X"00000004", PCplus4);
  instrMem : imem
    port map(reset, PCFromFlop, instrFromMem);

  -- IF/ID
  IF_ID_reg : IF_ID_register
    port map(PCplus4, instrFromMem, reset, clk, instrFromMem, PCFromIFID);

  -- instruction layout
  -- opcode 31 - 26, rs 25 - 21, rt 20-16, rd 15 - 11, shamt 10 to 6
  -- funct 5 - 0, imm 15 - 0, address 15 - 0
    
  -- ID logic
  regBlock: register_block
    port map(regToWriteFromMEMWB, instrFromIFID(25 downto 21), 
      instrFromIFID(20 downto 16), regDataToWrite, clk, WB_RegWrite, 
      rsValFromReg, rtValFromReg);
  ctrl : control
    port map(instrFromIFID(31 downto 26), reset, EXFromCtrl, MFromCtrl, WBFromCtrl);
  se: signext
    port map(instrFromIFID(15 downto 0), immSignExt);

  
  -- ID/EX
  ID_EX_reg : ID_EX_register
    port map(PCFromIFID, rsValFromReg, rtValFromReg, immSignExt,
      instrFromIFID(20 downto 16), instrFromIFID(15 downto 11), reset, clk, 
      EXFromCtrl, MFromCtrl, WBFromCtrl, PCFromIDEX, rsValFromIDEX, 
      rtValFromIDEX, immFromIDEX, rsFromIDEX, rdFromIDEX, EX_RegDst, 
      EX_ALUSrc, EX_ALUOp, MFromIDEX, WBFromIDEX);

  -- EX logic
  aluSrcMux : mux2 generic map(32)
    port map(rtValFromIDEX, immFromIDEX, EX_ALUSrc, ALUSrcMuxOut);
  EX_ALU : ALU
    port map(rsValFromIDEX, ALUSrcMuxOut, ALUControlOut, ALUResult, ALUCarry, ALUZero);
  
  -- TODO: instantiate ALU_ctl instead? ALUControl is a port.
  aluCtrl : ALU_ctl
    port map(immFromIDEX(5 downto 0), EX_ALUOp, ALUControlOut);
  immShiftLeft : sl2
    port map(immFromIDEX, immShift);
  PCBranchAdd : adder
    port map(PCFromIDEX, immShift, branchAddr);
  regDstMux : mux2 generic map(5)
    port map(rsFromIDEX, rdFromIDEX, EX_RegDst, regDestMuxOut);

  -- EX/MEM
  EX_MEM_reg : EX_MEM_register
    port map(branchAddr, ALUZero, ALUResult, rtValFromIDEX, regDestMuxOut, reset,
      clk, MFromIDEX, WBFromIDEX, PCBranch, zeroFromEXMEM, ALUResultFromEXMEM, 
      writeDataFromEXMEM, regToWriteFromEXMEM, M_Branch, M_MemRead,
      M_MemWrite, WBFromEXMEM);

  -- MEM logic
  PCSrc <= M_Branch AND zeroFromEXMEM;
  -- NOTE: doesn't use M_MemRead
  dataMem : dmem
    port map(clk, reset, M_MemRead, M_MemWrite, ALUResultFromEXMEM, writeDataFromEXMEM, 
      readDataFromDMEM);

  -- MEM/WB
  MEM_WB_reg : MEM_WB_register
    port map(ALUResultFromEXMEM, readDataFromDMEM, regToWriteFromEXMEM, reset,
      clk, WBFromEXMEM, ALUResultFromMEMWB, memDataFromMEMWB, regToWriteFromMEMWB,
      WB_RegWrite, WB_MemtoReg);

  -- WB logic
  regDataToWriteMux : mux2 generic map(32)
    port map(ALUResultFromMEMWB, memDataFromMEMWB, WB_MemtoReg, regDataToWrite);
end struct;