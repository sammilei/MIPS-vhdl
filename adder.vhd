-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: Adder
--
-- Takes 2 numbers and outputs the sum. 
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;


entity adder is –– adder
    port (
        a: in STD_LOGIC_VECTOR(31 downto 0);
        b: in STD_LOGIC_VECTOR(31 downto 0);
        y: out STD_LOGIC_VECTOR(31 downto 0));
end adder;

architecture behavior of adder is
begin
    y <= a + b;
end behavior;