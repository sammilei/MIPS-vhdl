library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_EX_interface is
    port (
        opcode, funct     : in std_logic_vector(5 downto 0);
        EX_RegDst, EX_ALUSrc : out std_logic;
        EX_ALUOp : out std_logic_vector(1 downto 2);
        M_Branch, M_MemRead, M_MemWrite : out std_logic;
        WB_RegWrite, WB_MemtoReg: out std_logic);
end ID_EX_interface;

architecture behavior of ID_EX_interface is
begin
-- rtype
if opcode = "000000" then
    EX_RegDst <= '1';
    EX_ALUOp <= "10";
    EX_ALUSrc <= '0';

    M_Branch <= '0';
    M_MemRead <= '0';
    M_MemWrite <= '0';

    WB_RegWrite <= '1';
    WB_MemtoReg <= '0';

-- lw
elsif opcode = "100011" then
    EX_RegDst <= '0';
    EX_ALUOp <= "00";
    EX_ALUSrc <= '1';

    M_Branch <= '0';
    M_MemRead <= '1';
    M_MemWrite <= '0';

    WB_RegWrite <= '1';
    WB_MemtoReg <= '1';

-- sw
elsif opcode = "101011" then
    EX_RegDst <= 'x';
    EX_ALUOp <= "00";
    EX_ALUSrc <= '1';

    M_Branch <= '0';
    M_MemRead <= '0';
    M_MemWrite <= '1';

    WB_RegWrite <= '0';
    WB_MemtoReg <= 'x';

-- beq
elsif opcode = "101011" then
    EX_RegDst <= 'x';
    EX_ALUOp <= "01";
    EX_ALUSrc <= '0';

    M_Branch <= '1';
    M_MemRead <= '0';
    M_MemWrite <= '0';

    WB_RegWrite <= '0';
    WB_MemtoReg <= 'x';

-- j
elsif opcode "101011" then
    EX_RegDst <= 'x';
    EX_ALUOp <= "11";
    EX_ALUSrc <= 'x';

    M_Branch <= '1';
    M_MemRead <= '0';
    M_MemWrite <= '0';

    WB_RegWrite <= '0';
    WB_MemtoReg <= 'x';
 
-- currently undefined   
else
    EX_RegDst <= 'x';
    EX_ALUOp <= "xx";
    EX_ALUSrc <= 'x';

    M_Branch <= 'x';
    M_MemRead <= 'x';
    M_MemWrite <= 'x';

    WB_RegWrite <= 'x';
    WB_MemtoReg <= 'x';

end if; 
end behavior;