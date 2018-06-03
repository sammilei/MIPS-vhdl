-- AlU For MIPS for 6 basic operations
-- performing arithmetic operation: +, -
-- performing logical operation: and, or, slt, nor

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.ALL;-- for shift
 
entity ALU is
 Port ( A, B : in STD_LOGIC_VECTOR(31 downto 0);
 ALU_Sel : in STD_LOGIC_VECTOR (5 downto 0);
 ALU_Out : out STD_LOGIC_VECTOR(31 downto 0);
 CarryOut: out std_logic; -- Flag
 ZERO: out std_logic); -- Flag for branching

end ALU;
 
architecture Behavioral of ALU is
signal temp: std_logic_vector (32 downto 0); 
begin

process(A, B, ALU_Sel)
begin
ZERO <= '0';
case ALU_Sel is
  when "100000" => ALU_Out <= A + B; 	     --and
  when "100010" => ALU_Out <= A - B;         --sub
  when "100100" => ALU_Out <= A and B;       --and
  when "100101" => ALU_Out <= A or B;        --or
  when "100111" => ALU_Out <= A nor B;       --nor
  --when "101010" => ALU_Out <= shift_left(A,1); --stl
  
  when "000100" =>                           --BEQ
	if A = B then
		ZERO <= '1';
	else
		ZERO <= '0';
	end if;
	 --ZERO <= '1' when A = B else '0';
	
	
  when "000101" =>                           --BNE
	if A /= B then
		ZERO <= '1';
	else
		ZERO <= '0';
	end if;
	 --ZERO <= '1' when A /= B else '0';
	  
  when others => ALU_Out <= A + B;

end case; 
end process; 

temp <= ('0' & A) + ('0' & B);
Carryout <= temp(32); -- Carryout flag
end Behavioral;