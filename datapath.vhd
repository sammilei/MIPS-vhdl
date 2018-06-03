-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: datapath
--
-- Combines 
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity datapath is –– MIPS datapath
  port (
    clk, reset        : in STD_LOGIC;
    memtoreg, PCsrc   : in STD_LOGIC;
    ALUsrc, regdst    : in STD_LOGIC;
    regwrite, jump    : in STD_LOGIC;
    ALUControl        : in STD_LOGIC_VECTOR(2 downto 0);
    zero              : out STD_LOGIC;
    PC                : buffer STD_LOGIC_VECTOR(31 downto 0);
    instr             : in STD_LOGIC_VECTOR(31 downto 0);
    ALUOut, writedata : buffer STD_LOGIC_VECTOR(31 downto 0);
    readdata          : in STD_LOGIC_VECTOR(31 downto 0));
end datapath;


architecture structural of datapath is
  component ALU is
    port (
      A, B     : in STD_LOGIC_VECTOR(31 downto 0);    -- operands
      ALU_Sel  : in STD_LOGIC_VECTOR (5 downto 0);	  -- operation (6-bit ALUControl)
      ALU_Out  : out STD_LOGIC_VECTOR(31 downto 0);   -- 32-bit result of ALU operation
      CarryOut : out std_logic; 					            -- Flag
      ZERO     : out std_logic);						          -- Flag for branching
  end component;
  
  component register_block 
    port (
      rd, rs, rt     : in STD_LOGIC_VECTOR(4 downto 0);
      write_data     : in STD_LOGIC_VECTOR (31 downto 0);
      clk            : in std_logic;
      write_enable   : in std_logic;
      rs_out, rt_out : out STD_LOGIC_VECTOR(31 downto 0));
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
  
  signal writereg: STD_LOGIC_VECTOR(4 downto 0);
  signal PCjump, PCnext, PCnextbr, PCplus4, PCbranch: STD_LOGIC_VECTOR(31 downto 0);
  signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
  signal srca, srcb, result: STD_LOGIC_VECTOR(31 downto 0);
  signal carryOut: STD_LOGIC;

begin
  –– calculate next PC logic
  PCjump <= PCplus4(31 downto 28) & instr(25 downto 0) & "00";
  PCreg: flopr generic map(32) 
    port map(clk, reset, PCnext, PC);
  PCadd1: adder 
    port map(PC, X"00000004", PCplus4);
  immsh: sl2 
    port map(signimm, signimmsh);
  PCadd2: adder 
    port map(PCplus4, signimmsh, PCbranch);
  PCbrmux: mux2 generic map(32) 
    port map(PCplus4, PCbranch, PCsrc, PCnextbr);
  PCmux: mux2 generic map(32) 
    port map(PCnextbr, PCjump, jump, PCnext);
    
  –– register file logic
  regBlock: register_block
    port map(writereg, instr(25 downto 21), instr(20 downto 16), result, clk, regwrite, srca, writedata);
  wrmux: mux2 generic map(5)
    port map(instr(20 downto 16), instr(15 downto 11), regdst, writereg);
  resmux: mux2 generic map(32)
    port map(ALUOut, readdata, memtoreg, result);
  se: signext 
    port map(instr(15 downto 0), signimm);
    
  –– ALU logic
  srcbmux: mux2 generic map(32) 
    port map(writedata, signimm, ALUsrc, srcb);
  mainALU: ALU 
    port map(srca, srcb, ALUControl, ALUOut, carryOut, zero);
end structural;