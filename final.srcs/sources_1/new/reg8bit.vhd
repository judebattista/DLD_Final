library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8bit is
  Port (
        load: in STD_LOGIC;
        inp0: in STD_LOGIC_VECTOR(7 downto 0);
        clk: in STD_LOGIC;
        clr: in STD_LOGIC;
        q0: out STD_LOGIC_VECTOR(7 downto 0)
        );
end reg8bit;

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
