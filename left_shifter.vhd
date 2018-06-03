-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
-- 
-- Module: Left Shifter
--
-- Bit-shifts 2 bits to the left. (Same as multiply by 4).
-- This does not require an ALU because the shift is always the same 2 bits.
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.


library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity sl2 is –– shift left by 2
port (
    signExtendedInput: in STD_LOGIC_VECTOR(31 downto 0);
    shiftedOut: out STD_LOGIC_VECTOR(31 downto 0));
end sl2;

architecture behavior of sl2 is
begin
    shiftedOut <= signExtendedInput(29 downto 0) & "00";
end behavior;