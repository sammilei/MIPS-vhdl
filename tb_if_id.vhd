-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 4.6.2018 23:43:15 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_IF_ID_register is
end tb_IF_ID_register;

architecture tb of tb_IF_ID_register is

    component IF_ID_register
        port (PC                 : in std_logic_vector (31 downto 0);
              r_type_instruction : in std_logic_vector (31 downto 0);
              clk                : in std_logic;
              opcode             : out std_logic_vector (5 downto 0);
              rs                 : out std_logic_vector (4 downto 0);
              rt                 : out std_logic_vector (4 downto 0);
              rd                 : out std_logic_vector (4 downto 0);
              imm                : out std_logic_vector (15 downto 0);
              PC_out             : out std_logic_vector (31 downto 0));
    end component;

    signal PC                 : std_logic_vector (31 downto 0);
    signal r_type_instruction : std_logic_vector (31 downto 0);
    signal clk                : std_logic;
    signal opcode             : std_logic_vector (5 downto 0);
    signal rs                 : std_logic_vector (4 downto 0);
    signal rt                 : std_logic_vector (4 downto 0);
    signal rd                 : std_logic_vector (4 downto 0);
    signal imm                : std_logic_vector (15 downto 0);
    signal PC_out             : std_logic_vector (31 downto 0);

    constant TbPeriod : time := 100 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : IF_ID_register
    port map (PC                 => PC,
              r_type_instruction => r_type_instruction,
              clk                => clk,
              opcode             => opcode,
              rs                 => rs,
              rt                 => rt,
              rd                 => rd,
              imm                => imm,
              PC_out             => PC_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
	loop
        -- EDIT Adapt initialization as needed

        PC <=  X"1021FFFF";
        r_type_instruction <= X"8C020000"; --1000 110(25)0 000(21)0(20) 0010(16) 0(15)000 0(11)000 000(5)0 0000
	--rs 25-21
	--rt 20-16
	--rd 15-11
	wait for 1 * TbPeriod;
	assert opcode = "100011" report "8C020000 opcode is wrong";
	assert rs = "00000" report "8C020000 rs is wrong";
	assert rt = "00010" report "8C020000 rt is wrong";
	assert rd = "00000" report "8C020000 rd is wrong";

	r_type_instruction <= X"8C030001"; --1000 1100 0000 0011 0000 0000 0000 0001
	wait for 1 * TbPeriod;
	assert opcode = "100011" report "8C030001 opcode is wrong";
	assert rs = "00000" report "8C030001 rs is wrong";
	assert rt = "00011" report "8C030001 rt is wrong";
	assert rd = "00000" report "8C030001 rd is wrong";
	wait for 1 * TbPeriod;

	r_type_instruction <= X"00430820"; --0000 0000 0100 0011 0000 1000 0010 0000
	wait for 1 * TbPeriod;
	assert opcode = "000000" report "00430820 opcode is wrong";
	assert rs = "00010" report "00430820 rs is wrong";
	assert rt = "00011" report "00430820 rt is wrong";
	assert rd = "00001" report "00430820 rd is wrong";
	

	---r_type_instruction <= X"AC010003"; --1010 1100 0000 0001 0000 0000 0000 0011
	--wait for 1 * TbPeriod;
	
	--r_type_instruction <= X"1022FFFF"; --0001 0000 0010 0010 1111 1111 1111 1111
	--wait for 1 * TbPeriod;
	
	--r_type_instruction <= X"1021FFFF"; --0001 0000 0010 0001 1111 1111 1111 1111
	--wait for 1 * TbPeriod;

	end loop;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_IF_ID_register of tb_IF_ID_register is
    for tb
    end for;
end cfg_tb_IF_ID_register;
