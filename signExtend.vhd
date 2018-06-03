-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- Module: Sign Extension
-- Author: Allen Kim
--
-- Takes a 16-bit signed number and outputs the equivalent 32-bit signed number. 
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity signext is –– sign extender
    port (
        signedIn: in STD_LOGIC_VECTOR(15 downto 0);
        signedOut: out STD_LOGIC_VECTOR(31 downto 0));
end signext;


architecture behavior of signext is
begin
    signedOut <= X"ffff" & signedIn when signedIn(15) else X"0000" & signedIn;
end behavior;