-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: IF_ID_register
--
-- Pipeline register located between the IFetch and IDecode pipe stages.
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity IF_ID_register is
	port (
	    PC    : in std_logic_vector(31 downto 0);
	    instr : inout std_logic_vector(31 downto 0);
	    reset : in std_logic;
	    clk   : in std_logic;
	    instr_out	: out std_logic_vector(31 downto 0);
	    PC_out      : out std_logic_vector(31 downto 0));
end IF_ID_register;

 

architecture behavior of IF_ID_register is
begin
	process(clk)
	begin
        if rising_edge(clk) then
		if reset='1' then
			instr(31 downto 26) <= "111111";
		else
        		PC_out <= PC;
        		instr_out <= instr;
		end if;
        end if;
	end process;
end behavior;
