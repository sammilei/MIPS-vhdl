-- .,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-
-- CS 525 (Sp 2018): MIPS Project
-- Authors: Matt Dohlen, Allen Kim, Xianmei Lei
--
-- Module: Instruction Memory
-- 
-- Instructions are stored in a text file "memfile.dat" in hexadecimal format,
-- 1 instruction per line.
--
-- This module represents the Instruction Memory (IM) as a 64 item array that
-- holds 32-bit STD_LOGIC_VECTORs. At initialization, "memfile.dat" is parsed
-- and stored in the array.
-- -'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.-'`'-.,.

library IEEE;
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;


entity imem is –– instruction memory
    port (
        -- receives address from PC
        address_in: in STD_LOGIC_VECTOR(5 downto 0);

        -- outputs a 32-bit instruction
        instruction_out: out STD_LOGIC_VECTOR(31 downto 0));
end imem;


architecture behavior of imem is
begin
    process
        file instrMemFile: TEXT;
        variable L: line;
        variable ch: character;
        variable memIndex, lineNumber, chIndex, hexToInt: integer;
        type memtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
        variable mem: memtype;

    begin 
        –– first, we need to load the instructions from the file into the array
        for memIndex in 0 to 63 loop 
            mem(memIndex) := (others => '0');
        end loop;

        lineNumber := 0;
        FILE_OPEN (instrMemFile, "memfile.dat", READ_MODE);
        while not endfile(instrMemFile) loop
            readline(instrMemFile, L);
            hexToInt := 0;
            for chIndex in 1 to 8 loop
            -- build 32-bit STD_LOGIC_VECTOR 4 bits at a time for each hexadecimal
                read (L, ch);
                -- find integer value of each hexadecimal, convert to STD_LOGIC_VECTOR(4)
                if '0' <= ch and ch <= '9' then
                    hexToInt := character'pos(ch) - character'pos('0');
                elsif 'a' <= ch and ch <= 'f' then
                    hexToInt := character'pos(ch) - character'pos('a') + 10;
                elsif 'A' <= ch and ch <= 'F' then
                    hexToInt := character'pos(ch) - character'pos('A') + 10;
                else report "Instruction Memory - Format error (invalid character) on line" & integer'image(lineNumber) severity error;
                end if;
                mem(lineNumber)(35 - chIndex * 4 downto 32 - chIndex * 4) := to_std_logic_vector(hexToInt, 4);
            end loop;
            lineNumber := lineNumber + 1;
        end loop;

        –– fetch instruction at address_in
        loop
            instruction_out <= mem(to_integer(address_in));
            wait on address_in;
        end loop;
    end process;
end behavior;