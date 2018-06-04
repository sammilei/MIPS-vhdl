-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: MEM_WB_register
--
-- Pipeline register located between the MEM and WB pipe stages.
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEM_WB_register is
    port (
        reg_data       : in std_logic_vector(31 downto 0);
        mem_data       : in std_logic_vector(31 downto 0);
        reg_to_write   : in std_logic_vector(4 downto 0);
	    clk            : in std_logic;

        WB                : in std_logic_vector(1 downto 0);

        reg_data_out     : out std_logic_vector(31 downto 0);
        mem_data_out     : out std_logic_vector(31 downto 0);
        reg_to_write_out   : out std_logic_vector(4 downto 0);

        WB_RegWrite, WB_MemtoReg : out std_logic_vector(1 downto 0));
end MEM_WB_register;

architecture behavior of MEM_WB_register is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            reg_data_out <= reg_data;
            mem_data_out <= mem_data;
            reg_to_write_out <= reg_to_write_out;
            WB_RegWrite <= WB(1);
            WB_MemtoReg <= WB(0);
        end if;
    end process;
end behavior;