library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity register_block is
	port(rd, rs, rt: in STD_LOGIC_VECTOR(4 downto 0);
	write_data: in STD_LOGIC_VECTOR (31 downto 0);
	clk: in std_logic;
	write_enable: in std_logic;
	rs_out, rt_out : out STD_LOGIC_VECTOR(31 downto 0));
end register_block;
 
architecture behavior of register_block is
type reg_array is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal regs : reg_array;
begin
	process(clk) 
	begin
		if rising_edge(clk) then
			rs_out <= regs(to_integer(unsigned(rs)));
			rt_out <= regs(to_integer(unsigned(rt)));
			if (write_enable = '1') then
				regs(to_integer(unsigned(rd))) <= write_data;
			end if;
		end if;			
	end process;
end behavior;