library IEEE;
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;


entity imem_testbench is
end imem_testbench;


architecture sim of imem_testbench is

  signal reset: std_logic := '0';
  signal address_in: STD_LOGIC_VECTOR(5 downto 0) := "000000";

  signal instruction_out: std_logic_vector(31 downto 0);

begin
  imem_test : entity work.imem(behavior) port map(
    reset => reset,
    address_in => address_in,
    instruction_out => instruction_out
  );

  process is
  begin
    wait for 100 ns;
    address_in <= "000000";
		wait for 2 ns;
    assert instruction_out = "10001100000000100000000000000000" report "instruction 000000 not matching" severity ERROR;

    wait for 100 ns;
    address_in <= "000001";
		wait for 2 ns;
    assert instruction_out = "10001100000000110000000000000001" report "instruction 000001 not matching" severity ERROR;

    wait for 100 ns;
    address_in <= "000010";
		wait for 2 ns;
    assert instruction_out = "00000000010000110000100000100000" report "instruction 000010 not matching" severity ERROR;

    wait for 100 ns;
    address_in <= "000011";
		wait for 2 ns;
    assert instruction_out = "10101100000000010000000000000011" report "instruction 000011 not matching" severity ERROR;

    wait for 100 ns;
    address_in <= "000100";
		wait for 2 ns;
    assert instruction_out = "00010000001000101111111111111111" report "instruction 000100 not matching" severity ERROR;
  
  end process;
end sim;
