-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: ALU control unit
--
-- ALU control unit for detect the ALU_op and function 
-- for ALU to do the certain operation by yielding 
-- ALU_control_input for passing to ALU
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.ALL;-- for shift
 
entity ALU_ctl is
 Port (
 funct 	      : in STD_LOGIC_VECTOR (5 downto 0);
 ALU_op       : in STD_LOGIC_VECTOR(1 downto 0);
 ALU_control_input: out STD_LOGIC_VECTOR(3 downto 0)
      );

end ALU_ctl;
 
architecture Behavioral of ALU_ctl is
 constant ADD: std_logic_vector(3 downto 0):= "0010";
 constant SUB: std_logic_vector(3 downto 0):= "0110"; 
 constant const_AND: std_logic_vector(3 downto 0):= "0000"; 
 constant const_OR: std_logic_vector(3 downto 0):= "0001";
 constant set_on_less_than: std_logic_vector(3 downto 0):= "0111";

begin

process(funct)
begin
	case ALU_op is
	  when "00" => ALU_control_input <= ADD;       -- LW/SW 
	  when "01" => ALU_control_input <= SUB;       -- BEQ
	  when "10" => 
		if funct = "100000" then               -- R add
			ALU_control_input <= ADD;
		elsif funct = "100010" then            -- R sub
		        ALU_control_input <= SUB;
		elsif funct = "100100" then            -- R and
	  	      ALU_control_input <= const_AND;
     	        elsif funct = "100101" then            -- R or
	 	       ALU_control_input <= const_OR;
		elsif funct = "101010" then            -- R <
	 	       ALU_control_input <= set_on_less_than;
		end if;
	  
  	when others => NULL;
end case; 
end process; 
end Behavioral;