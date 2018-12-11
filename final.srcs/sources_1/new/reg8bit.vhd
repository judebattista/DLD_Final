--  Reg8bit provides a register to store up to 8 bits of binary data
--  It stores the data incoming over inp0 when it receives the load signal and clears the stored data when it receives the clr signal
--  It outputs the stored data via q0

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8bit is
  Port (
        -- load triggers the register to store the current input
        load: in STD_LOGIC;
        -- the current input
        inp0: in STD_LOGIC_VECTOR(7 downto 0);
        clk: in STD_LOGIC;
        -- clr replaces the contents of the register with zeroes
        clr: in STD_LOGIC;
        -- the value currently stored in the register
        q0: out STD_LOGIC_VECTOR(7 downto 0)
        );
end reg8bit;

-- When clr is true, set the stored data to zero
-- Otherwise, on the rising edge of the clock, if load is true, store the data incoming over inp0
architecture Behavioral of reg8bit is

begin
    process(clk, clr)
    begin
        if clr = '1' then
            q0 <= "00000000";
        elsif clk'event and clk = '1' then
            if load = '1' then
                q0 <= inp0;
            end if;
        end if;
    end process;

end Behavioral;
