library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_top is
  Port (
        SW: in STD_LOGIC_VECTOR(15 downto 0);
        CLK100MHZ: in STD_LOGIC;
        BTN: in STD_LOGIC_VECTOR(3 downto 2);
        LED: out STD_LOGIC_VECTOR(15 downto 0)
  );
end comparator_top;

architecture Behavioral of comparator_top is
component comparator is
  Port (
        a : in STD_LOGIC_VECTOR(7 downto 0);
        b : in STD_LOGIC_VECTOR(7 downto 0);
        y: out STD_LOGIC_VECTOR(2 downto 0)
  );
  
end component;

component reg4bit is
Port (
        load: in STD_LOGIC;
        inp0: in STD_LOGIC_VECTOR(7 downto 0);
        clk: in STD_LOGIC;
        clr: in STD_LOGIC;
        q0: out STD_LOGIC_VECTOR(7 downto 0)
        );
end component;

signal reg_out: STD_LOGIC_VECTOR(7 downto 0);
signal b: STD_LOGIC_VECTOR(7 downto 0);
signal y: STD_LOGIC_VECTOR(2 downto 0);


begin
    c1 : comparator
    port map(
        a => SW(7 downto 0),
        --b => SW(15 downto 8),
        b => reg_out,
        y => LED(2 downto 0)
    );
    
    bitreg: reg4bit
    port map(
        inp0 => SW(15 downto 8),
        load => BTN(3),
        clk => CLK100MHZ,
        clr => BTN(2),
        --q0 => LED(15 downto 8)
        q0 => reg_out
    );
    
end Behavioral;
