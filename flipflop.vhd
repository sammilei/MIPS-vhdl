-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
--
-- Module: Flip Flop with Reset
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity flopr is –– flip-flop with synchronous reset
    generic (width: integer);
    port (
        clk   : in STD_LOGIC;
        reset : in STD_LOGIC;
        d     : in STD_LOGIC_VECTOR(width-1 downto 0);
        q     : out STD_LOGIC_VECTOR(width-1 downto 0));
end flopr;


architecture asynchronous of flopr is
begin
    process(clk, reset) 
    begin
        if reset then q <= (others => '0');
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end asynchronous;