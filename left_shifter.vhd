-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- Module: Left Shifter
-- Author: Allen Kim
--
-- Bit-shifts 2 bits to the left. (Same as multiply by 4)
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