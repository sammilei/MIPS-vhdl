-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 4.6.2018 23:45:41 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_control is
end tb_control;

architecture tb of tb_control is

    component control
        port (opcode : in std_logic_vector (5 downto 0);
              reset  : in std_logic;
              EX     : out std_logic_vector (3 downto 0);
              M      : out std_logic_vector (2 downto 0);
              WB     : out std_logic_vector (1 downto 0));
    end component;

    signal opcode : std_logic_vector (5 downto 0);
    signal reset  : std_logic;
    signal EX     : std_logic_vector (3 downto 0);
    signal M      : std_logic_vector (2 downto 0);
    signal WB     : std_logic_vector (1 downto 0);

begin

    dut : control
    port map (opcode => opcode,
              reset  => reset,
              EX     => EX,
              M      => M,
              WB     => WB);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        opcode <= (others => 'X');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
	wait for 2 ns;
	assert EX = "0000" and  M = "000" and WB = "00";
        wait for 100 ns;

        reset <= '0';
	wait for 2 ns;
	-- undefined
	assert EX = "XXXX";
	assert M = "XXX";
	assert WB = "XX";
	wait for 100 ns;


        -- EDIT Add stimuli here
	--rtype
	opcode <= "000000";
	wait for 2 ns;
	assert EX = "1100";
	assert M = "000";
	assert WB = "10";
        wait for 100 ns;

	-- lw
	opcode <= "100011";
	wait for 2 ns;
	assert EX = "0001";
	assert M = "010";
	assert WB = "11";
        wait for 100 ns;
	
	-- sw
	opcode <= "101011";
	wait for 2 ns;
	assert EX = "-001";
	assert M = "001";
	assert WB = "0-";
        wait for 100 ns;

	-- beq
	opcode <= "000100";
	wait for 2 ns;
	assert EX = "-010";
	assert M = "100";
	assert WB = "0-";
        wait for 100 ns;

	-- j
	opcode <= "000010";
	wait for 2 ns;
	assert EX = "----";
	assert M = "100";
	assert WB = "0-";
        wait for 100 ns;

	-- undefined
	opcode <= "111111";
	wait for 2 ns;
	assert EX = "XXXX";
	assert M = "XXX";
	assert WB = "XX";
        wait for 100 ns;
	

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_control of tb_control is
    for tb
    end for;
end cfg_tb_control;
