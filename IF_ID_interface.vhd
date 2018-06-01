library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity IF_ID_interface is
	port(PC : in std_logic_vector(31 downto 0);
	r_type_instruction : in std_logic_vector(31 downto 0);
	clk : in std_logic;
	opcode, funct : out std_logic_vector(5 downto 0);
	rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
	PC_out : out std_logic_vector(31 downto 0));
end IF_ID_interface;
 
architecture behavior of IF_ID_interface is
begin
	process(clk) 
	begin
		if rising_edge(clk) then
			PC_out <= PC;
			opcode <= r_type_instruction(31 downto 26);
			rs <= r_type_instruction(25 downto 21);
			rt <= r_type_instruction(20 downto 16);
			rd <= r_type_instruction(15 downto 11);
			shamt <= r_type_instruction(10 downto 6);
			funct <= r_type_instruction(5 downto 0);
		end if;			
	end process;
end behavior;