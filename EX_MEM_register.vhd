library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EX_MEM_register is
    port (
        branch_addr    : in std_logic_vector(31 downto 0);
        zero           : in std_logic;
        ALU_result     : in std_logic_vector(31 downto 0);
        write_data     : in std_logic_vector(31 downto 0);
        reg_to_write   : in std_logic_vector(4 downto 0);
        reset          : in std_logic;
	    clk            : in std_logic;

        M                 : in std_logic_vector(2 downto 0);
        WB                : in std_logic_vector(1 downto 0);

        branch_addr_out    : out std_logic_vector(31 downto 0);
        zero_out           : out std_logic;
        ALU_result_out     : out std_logic_vector(31 downto 0);
        write_data_out     : out std_logic_vector(31 downto 0);
        reg_to_write_out   : out std_logic_vector(4 downto 0);

        M_Branch, M_MemRead, M_MemWrite : out std_logic;
        WB_out                          : out std_logic_vector(1 downto 0));
end EX_MEM_register;

architecture behavior of EX_MEM_register is
begin
    process(clk)
    begin
        if reset = '1' then
            M_Branch <= '0';
            M_MemRead <= '0';
            M_MemWrite <= '0';
            WB_out <= "00";
        elsif rising_edge(clk) then
            branch_addr_out <= branch_addr;
            zero_out <= zero;
            ALU_result_out <= ALU_result;
            write_data_out <= write_data;
            reg_to_write_out <= reg_to_write;
            M_Branch <= M(2);
            M_MemRead <= M(1);
            M_MemWrite <= M(0);
            WB_out <= WB;
        end if;
    end process;
end behavior;