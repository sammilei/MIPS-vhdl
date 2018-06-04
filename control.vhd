-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: pipeline controller
--
-- Depending on opcode, sends control signals for the EX, M, and WB stages 
-- to ID_EX_register. From there, the control signals are passed (with the
-- corresponding instruction execution) and partially consumed at each stage
-- of the datapath.
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is
    port (
        opcode     : in std_logic_vector(5 downto 0);
        EX         : out std_logic_vector(3 downto 0);
        M          : out std_logic_vector(2 downto 0);
        WB         : out std_logic_vector(1 downto 0));
end control;

architecture behavior of control is
begin
-- rtype
if opcode = "000000" then
    EX <= "1100";
    M <= "000";
    WB <= "10";

-- lw
elsif opcode = "100011" then
    EX <= "0001";
    M <= "010";
    WB <= "11";

-- sw
elsif opcode = "101011" then
    EX <= "x001";
    M <= "001";
    WB <= "0x";

-- beq
elsif opcode = "101011" then
    EX <= "x010";
    M <= "100";
    WB <= "0x";

-- j
elsif opcode "101011" then
    EX <= "xxxx";
    M <= "100";
    WB <= "0x";
 
-- currently undefined   
else
    EX <= "xxxx";
    M <= "xxx";
    WB <= "xx";

end if; 
end behavior;