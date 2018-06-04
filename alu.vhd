-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: ALU
--
-- AlU For MIPS for 6 basic operations
-- performing arithmetic operation: +, -
-- performing logical operation: and, or, set on less than
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.ALL; -- for shift
 
entity ALU is
  Port (
    A, B : in STD_LOGIC_VECTOR(31 downto 0);                      -- operands
    ALU_control_input : in STD_LOGIC_VECTOR (3 downto 0);	  -- operation (4-bit ALUControl)
    ALU_Out : out STD_LOGIC_VECTOR(31 downto 0);                  -- 32-bit result of ALU operation
    CarryOut: out std_logic);					  -- carryout Flag					  -- Flag for branching

end ALU;
 
architecture Behavioral of ALU is
signal temp: std_logic_vector (32 downto 0); 
begin

process(A, B, ALU_control_input)
begin
case ALU_control_input is
  when "0010" => ALU_Out <= A + B; 	   --add
  when "0110" => ALU_Out <= A - B;         --sub
  when "0000" => ALU_Out <= A and B;       --and
  when "0001" => ALU_Out <= A or B;        --or
  when "0111" =>                           --set on less than
	if(A < B) then ALU_Out <="00000000000000000000000000000001";
	else ALU_Out <="00000000000000000000000000000000";
	end if;
  when others => ALU_Out <= "00000000000000000000000000000000";

end case; 
end process; 

temp <= ('0' & A) + ('0' & B);
Carryout <= temp(32); -- Carryout flag
end Behavioral;