library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;


entity testbench is
end;


architecture test of testbench is
  component top
    port (
      clk, reset: in STD_LOGIC;
      writedata, dataAddress: out STD_LOGIC_VECTOR(31 downto 0);
      memwrite: out STD_LOGIC);
  end component;
  
  signal writedata, dataAddress: STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset, memwrite: STD_LOGIC;

begin
  -- instantiate device under test
  dut: top port map(clk, reset, writedata, dataAddress, memwrite);
  
  -- Generate clock with 10 ns period
  process 
    begin
      clk <= '1';
      wait for 5 ns;
      clk <= '0';
      wait for 5 ns;
  end process;
  
  -- Generate reset for first two clock cycles
  process 
    begin
      reset <= '1';
      wait for 22 ns;
      reset <= '0';
      wait;
  end process;
  
  -- check that 7 gets written to address 84 at end of program
  -- test code goes here
  process(clk) 
    begin
      if (clk'event and clk = '0' and memwrite = '1') then
        if (to_integer(dataAddress) = 84 and to_integer(writedata) = 7) then
          report "NO ERRORS: Simulation succeeded" severity failure;
        elsif (dataAddress /= 80) then
          report "Simulation failed" severity failure;
        end if;
      end if;
  end process;
end test;
