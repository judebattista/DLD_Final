--  Comparator takes two inputs, and decides whether a is greater than, less than, or equal to b
--  It performs this operation when BTN is held and outputs the result as y

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparator is
  Port (
        -- a and b are the inputs to compare
        a : in STD_LOGIC_VECTOR(7 downto 0);
        b : in STD_LOGIC_VECTOR(7 downto 0);
        -- uses a button press and hold to trigger and output the result of the comparison
        BTN: in STD_LOGIC_VECTOR(4 downto 0);
        clk: in STD_LOGIC;
        -- the result of the comparison
        y: out STD_LOGIC_VECTOR(2 downto 0)
  );
end comparator;

architecture Behavioral of comparator is

signal comparison: STD_LOGIC_VECTOR(7 downto 0);

begin
    comparison <= a-b;
    -- if a < b output 100.
    -- if a > b output 010
    -- if a = b output 001
    process(a, b, clk) 
    begin
        y<= "000";
        if clk'event and clk = '1' then
            if BTN(0) = '1' then
                if (a>b) then
                    y<= "100";
                elsif (a<b) then
                    y<= "010";
                elsif (a=b) then
                    y<= "001";
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
