-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
--
-- Module: Data Memory
--
-- This module represents the Data Memory (MEM) as a 64 item array that
-- holds 32-bit STD_LOGIC_VECTORs. 
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;


entity dmem is -- data memory
  port (
    clk          : in STD_LOGIC;
    reset        : in STD_LOGIC;
    readEnabled  : in STD_LOGIC;
    writeEnabled : in STD_LOGIC;
    memAddress   : in STD_LOGIC_VECTOR (31 downto 0);
    writeData    : in STD_LOGIC_VECTOR (31 downto 0);
    readData     : out STD_LOGIC_VECTOR (31 downto 0));
end;


architecture behavior of dmem is
begin
  process
    type memtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem: memtype;
    variable memIndex: integer;
  begin
    -- read or write memory
    loop
      if rising_edge(clk) then
        if (reset = '1') then
          for memIndex in 0 to 63 loop 
            mem(memIndex) := (others => '0');
          end loop;
        end if;
        if (writeEnabled = '1') then 
          -- memAddress(7 downto 2) == memAddress/4
          -- We use this because mem is indexed by word, not bytes
          mem (to_integer(memAddress(7 downto 2))) := writeData;
        end if;
      end if;
      if (readEnabled = '1') then
        readData <= mem (to_integer(memAddress(7 downto 2)));
      end if;
      wait on clk, memAddress;
    end loop;
  end process;
end behavior;
