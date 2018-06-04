library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_EX_interface is
    port (
        PC             : in std_logic_vector(31 downto 0);
        rs_val, rt_val : in std_logic_vector(31 downto 0);
        imm            : in std_logic_vector(31 downto 0);
	    rs, rd         : in std_logic_vector(4 downto 0);
	    clk            : in std_logic;

        
        EX                : in std_logic_vector(3 downto 0);
        M                 : in std_logic_vector(2 downto 0);
        WB                : in std_logic_vector(1 downto 0));

	    PC_out                 : out std_logic_vector(31 downto 0);
	    rs_val_out, rt_val_out : out std_logic_vector(31 downto 0);
        imm_out                : out std_logic_vector(31 downto 0);
	    rs_out, rd_out         : out std_logic_vector(4 downto 0);

        EX_RegDst, EX_ALUSrc  : out std_logic;
        EX_ALUOp              : out std_logic_vector(1 downto 2);
        M_out                 : out std_logic_vector(2 downto 0);
        WB_out                : out std_logic_vector(1 downto 0));
end ID_EX_interface;

architecture behavior of ID_EX_interface is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            PC_out <= PC;
            rt_val_out <= rt_val;
            rs_val_out <= rs_val;
            imm_out <= imm;
            rs_out <= rs;
            rd_out <= rd;
            EX_RegDst <= EX(3);
            EX_ALUOp <= EX(2 downto 1);
            EX_ALUSrc <= EX(0);
            M_out <= M;
            WB_out <= WB;
        end if;
    end process;
end behavior;
