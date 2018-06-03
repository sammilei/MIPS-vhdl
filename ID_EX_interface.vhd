library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_EX_interface is
    port (
        PC             : in std_logic_vector(31 downto 0);
        rs_val, rt_val : in std_logic_vector(31 downto 0);
	    rd             : in std_logic_vector(4 downto 0);
	    --shamt should be sign extended by now
	    shamt          : in std_logic_vector(31 downto 0);
	    funct          : in std_logic_vector(5 downto 0);
	    clk            : in std_logic;
	    PC_out                 : out std_logic_vector(31 downto 0);
	    rs_val_out, rt_val_out : out std_logic_vector(31 downto 0);
	    rd_out                 : out std_logic_vector(4 downto 0);
	    shamt_out              : out std_logic_vector(31 downto 0);
	    funct_out              : out std_logic_vector(5 downto 0));
end ID_EX_interface;

architecture behavior of ID_EX_interface is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            PC_out <= PC;
            rt_val_out <= rt_val;
            rs_val_out <= rs_val;
            rd_out <= rd;
            shamt_out <= shamt;
            funct_out <= funct;
        end if;
    end process;
end behavior;
