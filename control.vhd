library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is
    port (
        opcode     : in std_logic_vector(5 downto 0);
	reset 	   : in std_logic;
        EX         : out std_logic_vector(3 downto 0);
        M          : out std_logic_vector(2 downto 0);
        WB         : out std_logic_vector(1 downto 0));
end control;

architecture behavior of control is
begin
process (reset, opcode)
begin
if reset = '1' then
    EX <= "0000";
    M <= "000";
    WB <= "00";
-- rtype
elsif opcode = "000000" then
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
    EX <= "-001";
    M <= "001";
    WB <= "0-";

-- beq
elsif opcode = "000100" then
    EX <= "-010";
    M <= "100";
    WB <= "0-";

-- j
elsif opcode = "000010" then
    EX <= "----";
    M <= "100";
    WB <= "0-";

-- reset instruction
elsif opcode = "111111" then
    EX <= "0000";
    M <= "000";
    WB <= "00";

-- currently undefined   
else
    EX <= "XXXX";
    M <= "XXX";
    WB <= "XX";

end if; 
end process;
end behavior;