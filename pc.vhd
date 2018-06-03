-- 32 bit Program counter unit for MIPS
-- PC has 4 behaviors: 
--0. Increment PC
--1. Set PC to new value
--2. Do nothing (halt)
--3. Set PC to our reset vector, which is 0x0000.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.ALL;
entity pc is
    Port ( clk : in  STD_LOGIC; --TODO: based on the MIPS control unit
           PC_in : in  STD_LOGIC_VECTOR (31 downto 0); --instruction address to be rewritten with
           PC_op : in  STD_LOGIC_VECTOR (1 downto 0); --signal for PC's operation choice
           PC_out : out  STD_LOGIC_VECTOR (31 downto 0) -- instructiion address for output
           );
end pc;

architecture Behavioral of pc is
  signal cur_pc: std_logic_vector( 31 downto 0) := X"00000000";

  constant NOP: std_logic_vector(1 downto 0):= "00"; -- no op
  constant INC: std_logic_vector(1 downto 0):= "01"; -- increment
  constant OP_ASSIGN: std_logic_vector(1 downto 0):= "10"; -- copy a brand new address
  constant OP_RESET: std_logic_vector(1 downto 0):= "11"; -- reset to be X"00000000"
begin
 
  process (clk)
  begin
    if rising_edge(clk) then
      case PC_op is
        when NOP =>   -- do nothing, keep PC the same/halt
        when INC =>   
          cur_pc <= cur_pc + 1; -- increment by 1: 4 bytes
        when OP_ASSIGN =>    -- load external input
          cur_pc <= PC_in;
        when OP_RESET =>     -- Reset
          cur_pc <= X"00000000";
        when others =>
      end case;
    end if;
  end process;
 
  PC_out <= cur_pc;
 
end Behavioral;