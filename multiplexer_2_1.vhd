-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- Module: 2 Input Multiplexer
-- Author: Allen Kim
--
-- Takes 2 inputs and selects one to output based on selector signal.
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity mux2 is –– two-input multiplexer
    generic(width: integer := 8);
    port (
        d0        : in STD_LOGIC_VECTOR(width-1 downto 0);
        d1        : in STD_LOGIC_VECTOR(width-1 downto 0);
        selector  : in STD_LOGIC;
        y         : out STD_LOGIC_VECTOR(width-1 downto 0));
end mux2;

architecture behavior of mux2 is
begin
    y <= d1 when selector else d0;
end behavior;