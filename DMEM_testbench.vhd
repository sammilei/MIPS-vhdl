library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;


entity tb_dmem is
end tb_dmem;

architecture tb of tb_dmem is

    component dmem
        port (clk          : in std_logic;
              reset        : in std_logic;
              readEnabled  : in std_logic;
              writeEnabled : in std_logic;
              memAddress   : in std_logic_vector (31 downto 0);
              writeData    : in std_logic_vector (31 downto 0);
              readData     : out std_logic_vector (31 downto 0));
    end component;

    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal readEnabled  : std_logic := '1';
    signal writeEnabled : std_logic := '0';
    signal memAddress   : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
    signal writeData    : std_logic_vector (31 downto 0);
    signal readData     : std_logic_vector (31 downto 0);

    constant TbPeriod : time := 100 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : dmem
    port map (clk          => clk,
              reset => reset,
              readEnabled => readEnabled,
              writeEnabled => writeEnabled,
              memAddress   => memAddress,
              writeData    => writeData,
              readData     => readData);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    process
      variable i: integer := 0;
    begin
      reset <= '1';
      wait for 210 ns;
      reset <= '0';
      wait for 10 ns;
    end process;

    writeSomeBlocks : process
      variable i: integer := 0;
    begin
        -- EDIT Adapt initialization as needed
        writeEnabled <= '1';
        memAddress <= (others => '0');
        writeData <= "11110000111100001111000011110000";

        for i in 0 to 15 loop 
          memAddress <= memAddress + i*2;
        end loop;
        wait;
    end process;


    process
      
      begin
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
        writeEnabled <= '0';
        readEnabled <= '1';
        memAddress <= (others => '0');

        memAddress <= memAddress + 0;
        wait for 1 ns;
        assert readData = 252645135;
        wait for 50 ns;

        memAddress <= memAddress + 1;
        wait for 1 ns;
        assert readData = 0;
        wait for 50 ns;


        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_dmem of tb_dmem is
    for tb
    end for;
end cfg_tb_dmem;