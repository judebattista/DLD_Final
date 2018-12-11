--  vga_top is responsible for all the output to the screen
--  It integrates the output from the comparator with the user input via switches and buttons
--  then displays the user's guess and whether that guess is too high, too low, or on target


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_top is
   port(
      SW : in STD_LOGIC_VECTOR(15 downto 0);
      CLK100MHZ: in std_logic;
      VGA_HS, VGA_VS: out  std_logic;
      VGA_R: out std_logic_vector(3 downto 0);
      VGA_G: out std_logic_vector(3 downto 0);
      VGA_B: out std_logic_vector(3 downto 0);       
      BTN: in STD_LOGIC_VECTOR(4 downto 0);
      LED: out STD_LOGIC_VECTOR(15 downto 0)  
   );
end vga_top;

    architecture vga_top of vga_top is
    signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
    signal video_on, pixel_tick: std_logic;
    signal red_reg, red_next: std_logic_vector(3 downto 0) := (others => '0');
    signal green_reg, green_next: std_logic_vector(3 downto 0) := (others => '0');
    signal blue_reg, blue_next: std_logic_vector(3 downto 0) := (others => '0');     
    signal th_xl, th_yt, th_xr, th_yb : integer := 0;
    signal tl_xl, tl_yt, tl_xr, tl_yb : integer := 0; 
    signal tr_xl, tr_yt, tr_xr, tr_yb : integer := 0; 
    signal mh_xl, mh_yt, mh_xr, mh_yb : integer := 0; 
    signal bl_xl, bl_yt, bl_xr, bl_yb : integer := 0; 
    signal br_xl, br_yt, br_xr, br_yb : integer := 0; 
    signal bh_xl, bh_yt, bh_xr, bh_yb : integer := 0; 
    signal eu_xl, eu_yt, eu_xr, eu_yb, el_xl, el_yt, el_xr, el_yb : integer := 0;
    signal lt_first_xl, lt_first_yt, lt_first_xr, lt_first_yb, second_xl, second_yt, second_xr, second_yb, lt_third_xl, lt_third_yt, lt_third_xr, lt_third_yb, fourth_xl, fourth_yt, fourth_xr, fourth_yb, lt_fifth_xl, lt_fifth_yt, lt_fifth_xr, lt_fifth_yb : integer := 0;
    signal gt_first_xl, gt_first_yt, gt_first_xr, gt_first_yb, gt_third_xl, gt_third_yt, gt_third_xr, gt_third_yb, gt_fifth_xl, gt_fifth_yt, gt_fifth_xr, gt_fifth_yb : integer := 0;
    signal reg_out: STD_LOGIC_VECTOR(7 downto 0);
    signal b: STD_LOGIC_VECTOR(7 downto 0);
    signal y: STD_LOGIC_VECTOR(2 downto 0);
    signal decimal: integer range 0 to 100;
    signal place_value_shift : integer := 130;
    
component comparator is
  Port (
        a : in STD_LOGIC_VECTOR(7 downto 0);
        b : in STD_LOGIC_VECTOR(7 downto 0);
        BTN: in STD_LOGIC_VECTOR(4 downto 0);
        clk: in STD_LOGIC;
        y: out STD_LOGIC_VECTOR(2 downto 0)
  );
  
end component;

component reg8bit is
Port (
        load: in STD_LOGIC;
        inp0: in STD_LOGIC_VECTOR(7 downto 0);
        clk: in STD_LOGIC;
        clr: in STD_LOGIC;
        q0: out STD_LOGIC_VECTOR(7 downto 0)
        );
end component;

begin
   -- instantiate VGA sync circuit
   
   c1 : comparator
       port map(
           a => SW(7 downto 0),
           --b => SW(15 downto 8),
           b => reg_out,
           clk=>CLK100MHZ,
           BTN=>BTN,
           --y => LED(2 downto 0)
           y => y
       );
       
       bitreg: reg8bit
       port map(
           inp0 => SW(15 downto 8),
           load => BTN(3),
           clk => CLK100MHZ,
           clr => BTN(2),
           --q0 => LED(15 downto 8)
           q0 => reg_out
       );
       
   vga_sync_unit: entity work.vga_sync
    port map(clk=>CLK100MHZ, reset=>BTN(1), hsync=>VGA_HS,
               vsync=>VGA_VS, video_on=>video_on,
               pixel_x=>pixel_x, pixel_y=>pixel_y,
               p_tick=>pixel_tick);
               
    -- box position
-- top horizontal
th_xl <= 10;
th_yt <= 0;
th_xr <= 110;
th_yb <= 10; 

-- top left
tl_xl <= 0;  
tl_yt <= 10;
tl_xr <= 10;
tl_yb <= 110; 

-- top right
tr_xl <= 110;  
tr_yt <= 10;
tr_xr <= 120;
tr_yb <= 110; 

-- mid horizontal
mh_xl <= 10;  
mh_yt <= 110;
mh_xr <= 110;
mh_yb <= 120; 

-- bottom left
bl_xl <= 0;  
bl_yt <= 120;
bl_xr <= 10;
bl_yb <= 220;

-- bottom right
br_xl <= 110;  
br_yt <= 120;
br_xr <= 120;
br_yb <= 220; 

-- bottom horizontal
bh_xl <= 10;  
bh_yt <= 220;
bh_xr <= 110;
bh_yb <= 230;  


--equal sign
eu_xl <= 300;  
eu_yt <= 90;
eu_xr <= 390;
eu_yb <= 110;  
el_xl <= 300;  
el_yt <= 140;
el_xr <= 390;
el_yb <= 160;  

--common lines between signs
second_xl <= 350;  
second_yt <= 70;
second_xr <= 400;
second_yb <= 100;
fourth_xl <= 350;  
fourth_yt <= 130;
fourth_xr <= 400;
fourth_yb <= 160;

--less than sign
lt_first_xl <= 300;  
lt_first_yt <= 100;
lt_first_xr <= 350;
lt_first_yb <= 130;  
lt_third_xl <= 400;  
lt_third_yt <= 40;
lt_third_xr <= 450;
lt_third_yb <= 70;
lt_fifth_xl <= 400;  
lt_fifth_yt <= 160;
lt_fifth_xr <= 450;
lt_fifth_yb <= 190;

--greater than sign
gt_first_xl <= 300;  
gt_first_yt <= 40;
gt_first_xr <= 350;
gt_first_yb <= 70;  
gt_third_xl <= 400;  
gt_third_yt <= 100;
gt_third_xr <= 450;
gt_third_yb <= 130;
gt_fifth_xl <= 300;  
gt_fifth_yt <= 160;
gt_fifth_xr <= 350;
gt_fifth_yb <= 190;

--decimal <= to_integer(unsigned(SW(6 downto 0)));

    -- process to generate next colors           
    process (pixel_x, pixel_y, SW)
    begin
        -- when the user presses btn(0) capture the switches as a decimal value
            decimal <= to_integer(unsigned(SW(6 downto 0)));
          
            -- figure out the tens digit
            if decimal >= 10 and decimal <= 19 then
            -- if it's in the tr box
                if (unsigned(pixel_x) > tr_xl) and (unsigned(pixel_x) < tr_xr) and
                       (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the br box
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";                           
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            elsif decimal >= 20 and decimal <= 29 then
                -- If the number is 2
               if (unsigned(pixel_x) > th_xl) and (unsigned(pixel_x) < th_xr) and
               (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";
                -- if it's in the tr box
                elsif (unsigned(pixel_x) > tr_xl) and (unsigned(pixel_x) < tr_xr) and
                       (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the mh box
                elsif (unsigned(pixel_x) > mh_xl) and (unsigned(pixel_x) < mh_xr) and
                      (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";    
                -- if it's in the bl box
                elsif (unsigned(pixel_x) > bl_xl) and (unsigned(pixel_x) < bl_xr) and
                      (unsigned(pixel_y) > bl_yt) and (unsigned(pixel_y) < bl_yb) then
                      -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                -- if it's in the bh box    
                elsif (unsigned(pixel_x) > bh_xl) and (unsigned(pixel_x) < bh_xr) and
                      (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";                                
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            elsif decimal >= 30 and decimal <= 39 then
                --if the number is a 3
                if (unsigned(pixel_x) > th_xl) and (unsigned(pixel_x) < th_xr) and
                   (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
                       -- number box color blue
                       red_next <= "0000";
                       green_next <= "0000";
                       blue_next <= "1111";
                    -- if it's in the tr box
                elsif (unsigned(pixel_x) > tr_xl) and (unsigned(pixel_x) < tr_xr) and
                       (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the mh box
                elsif (unsigned(pixel_x) > mh_xl) and (unsigned(pixel_x) < mh_xr) and
                      (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";    
                --if it's in the br box             
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the bh box    
                elsif (unsigned(pixel_x) > bh_xl) and (unsigned(pixel_x) < bh_xr) and
                      (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";                                
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
        elsif decimal >= 40 and decimal <= 49 then
            -- If the number is 4
                -- if it's in the tl box
                if (unsigned(pixel_x) > tl_xl) and (unsigned(pixel_x) < tl_xr) and
                      (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                      -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                -- if it's in the tr box
                elsif (unsigned(pixel_x) > tr_xl) and (unsigned(pixel_x) < tr_xr) and
                       (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the mh box
                elsif (unsigned(pixel_x) > mh_xl) and (unsigned(pixel_x) < mh_xr) and
                      (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";    
                --if it's in the br box             
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";              
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            elsif decimal >= 50 and decimal <= 59 then
            -- If the number is 5
               if (unsigned(pixel_x) > th_xl) and (unsigned(pixel_x) < th_xr) and
               (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";
                -- if it's in the tl box
                elsif (unsigned(pixel_x) > tl_xl) and (unsigned(pixel_x) < tl_xr) and
                      (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                      -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                -- if it's in the mh box
                elsif (unsigned(pixel_x) > mh_xl) and (unsigned(pixel_x) < mh_xr) and
                      (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";  
                --if it's in the br box             
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the bh box    
                elsif (unsigned(pixel_x) > bh_xl) and (unsigned(pixel_x) < bh_xr) and
                      (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";                                
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            elsif decimal >= 60 and decimal <= 69 then
                if (unsigned(pixel_x) > th_xl) and (unsigned(pixel_x) < th_xr) and
                (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";
                -- if it's in the tl box
                elsif (unsigned(pixel_x) > tl_xl) and (unsigned(pixel_x) < tl_xr) and
                      (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                      -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                -- if it's in the mh box
                elsif (unsigned(pixel_x) > mh_xl) and (unsigned(pixel_x) < mh_xr) and
                      (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";    
                -- if it's in the bl box
                elsif (unsigned(pixel_x) > bl_xl) and (unsigned(pixel_x) < bl_xr) and
                      (unsigned(pixel_y) > bl_yt) and (unsigned(pixel_y) < bl_yb) then
                      -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                --if it's in the br box             
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the bh box    
                elsif (unsigned(pixel_x) > bh_xl) and (unsigned(pixel_x) < bh_xr) and
                      (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";                                
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            elsif decimal >= 70 and decimal <= 79 then
                if (unsigned(pixel_x) > th_xl) and (unsigned(pixel_x) < th_xr) and
                   (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
                       -- number box color blue
                       red_next <= "0000";
                       green_next <= "0000";
                       blue_next <= "1111";
                -- if it's in the tr box
                elsif (unsigned(pixel_x) > tr_xl) and (unsigned(pixel_x) < tr_xr) and
                       (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                --if it's in the br box             
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            elsif decimal >= 80 and decimal <= 89 then
                if (unsigned(pixel_x) > th_xl) and (unsigned(pixel_x) < th_xr) and
                   (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";
                -- if it's in the tl box
                elsif (unsigned(pixel_x) > tl_xl) and (unsigned(pixel_x) < tl_xr) and
                  (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                  -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                -- if it's in the tr box
                elsif (unsigned(pixel_x) > tr_xl) and (unsigned(pixel_x) < tr_xr) and
                       (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the mh box
                elsif (unsigned(pixel_x) > mh_xl) and (unsigned(pixel_x) < mh_xr) and
                      (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";    
                -- if it's in the bl box
                elsif (unsigned(pixel_x) > bl_xl) and (unsigned(pixel_x) < bl_xr) and
                      (unsigned(pixel_y) > bl_yt) and (unsigned(pixel_y) < bl_yb) then
                      -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                --if it's in the br box             
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the bh box    
                elsif (unsigned(pixel_x) > bh_xl) and (unsigned(pixel_x) < bh_xr) and
                      (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";                                
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            -- If the number is 9
            elsif decimal >= 90 and decimal <= 99 then
               if (unsigned(pixel_x) > th_xl) and (unsigned(pixel_x) < th_xr) and
               (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";
                -- if it's in the tl box
                elsif (unsigned(pixel_x) > tl_xl) and (unsigned(pixel_x) < tl_xr) and
                      (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                      -- number box color blue
                     red_next <= "0000";
                     green_next <= "0000";
                     blue_next <= "1111";
                -- if it's in the tr box
                elsif (unsigned(pixel_x) > tr_xl) and (unsigned(pixel_x) < tr_xr) and
                       (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the mh box
                elsif (unsigned(pixel_x) > mh_xl) and (unsigned(pixel_x) < mh_xr) and
                      (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";    
                --if it's in the br box             
                elsif (unsigned(pixel_x) > br_xl) and (unsigned(pixel_x) < br_xr) and
                      (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                    -- number box color blue
                    red_next <= "0000";
                    green_next <= "0000";
                    blue_next <= "1111";
                -- if it's in the bh box    
                elsif (unsigned(pixel_x) > bh_xl) and (unsigned(pixel_x) < bh_xr) and
                      (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
                   -- number box color blue
                   red_next <= "0000";
                   green_next <= "0000";
                   blue_next <= "1111";                                
                else    
                   -- background color blue
                   red_next <= "1111";
                   green_next <= "0000";
                   blue_next <= "1111";
                end if;
            else    
               -- background color blue
               red_next <= "1111";
               green_next <= "0000";
               blue_next <= "1111";
            end if;
        -- One's digit
        -- If the number is 0
        if decimal mod 10 = 0 then
           if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
           (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";
        -- if it's in the tl box
        elsif (unsigned(pixel_x) > tl_xl + place_value_shift) and (unsigned(pixel_x) < tl_xr + place_value_shift) and
              (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
              -- number box color blue
             red_next <= "0000";
             green_next <= "0000";
             blue_next <= "1111";
        -- if it's in the tr box
        elsif (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
               (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";   
        -- if it's in the bl box
        elsif (unsigned(pixel_x) > bl_xl + place_value_shift) and (unsigned(pixel_x) < bl_xr + place_value_shift) and
              (unsigned(pixel_y) > bl_yt) and (unsigned(pixel_y) < bl_yb) then
              -- number box color blue
             red_next <= "0000";
             green_next <= "0000";
             blue_next <= "1111";
        --if it's in the br box             
        elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
              (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        -- if it's in the bh box    
        elsif (unsigned(pixel_x) > bh_xl + place_value_shift) and (unsigned(pixel_x) < bh_xr + place_value_shift) and
              (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
           -- number box color blue
           red_next <= "0000";
           green_next <= "0000";
           blue_next <= "1111";                                
        end if;
    end if;
            -- If the number is 1
        if decimal mod 10 = 1 then
        -- if it's in the tr box
            if (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
                   (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";
            -- if it's in the br box
            elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
                  (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";                           
            end if;
    end if;
        -- If the number is 2
        if decimal mod 10 = 2 then
           if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
           (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";
        -- if it's in the tr box
        elsif (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
               (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        -- if it's in the mh box
        elsif (unsigned(pixel_x) > mh_xl + place_value_shift) and (unsigned(pixel_x) < mh_xr + place_value_shift) and
              (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";    
        -- if it's in the bl box
        elsif (unsigned(pixel_x) > bl_xl + place_value_shift) and (unsigned(pixel_x) < bl_xr + place_value_shift) and
              (unsigned(pixel_y) > bl_yt) and (unsigned(pixel_y) < bl_yb) then
              -- number box color blue
             red_next <= "0000";
             green_next <= "0000";
             blue_next <= "1111";
        -- if it's in the bh box    
        elsif (unsigned(pixel_x) > bh_xl + place_value_shift) and (unsigned(pixel_x) < bh_xr + place_value_shift) and
              (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
           -- number box color blue
           red_next <= "0000";
           green_next <= "0000";
           blue_next <= "1111";                                
        end if;
    end if;
        -- If the number is 3
        if decimal mod 10 = 3 then
           if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
           (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";
        -- if it's in the tr box
        elsif (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
               (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        -- if it's in the mh box
        elsif (unsigned(pixel_x) > mh_xl + place_value_shift) and (unsigned(pixel_x) < mh_xr + place_value_shift) and
              (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";    
        --if it's in the br box             
        elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
              (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        -- if it's in the bh box    
        elsif (unsigned(pixel_x) > bh_xl + place_value_shift) and (unsigned(pixel_x) < bh_xr + place_value_shift) and
              (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
           -- number box color blue
           red_next <= "0000";
           green_next <= "0000";
           blue_next <= "1111";                                
        end if;
    end if;
        -- If the number is 4
        if decimal mod 10 = 4 then
        -- if it's in the tl box
            if (unsigned(pixel_x) > tl_xl + place_value_shift) and (unsigned(pixel_x) < tl_xr + place_value_shift) and
                  (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                  -- number box color blue
                 red_next <= "0000";
                 green_next <= "0000";
                 blue_next <= "1111";
            -- if it's in the tr box
            elsif (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
                   (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";
            -- if it's in the mh box
            elsif (unsigned(pixel_x) > mh_xl + place_value_shift) and (unsigned(pixel_x) < mh_xr + place_value_shift) and
                  (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";    
            --if it's in the br box             
            elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
                  (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";              
            end if;
    end if;
        -- If the number is 5
        if decimal mod 10 = 5 then
           if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
           (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";
            -- if it's in the tl box
            elsif (unsigned(pixel_x) > tl_xl + place_value_shift) and (unsigned(pixel_x) < tl_xr + place_value_shift) and
                  (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                  -- number box color blue
                 red_next <= "0000";
                 green_next <= "0000";
                 blue_next <= "1111";
            -- if it's in the mh box
            elsif (unsigned(pixel_x) > mh_xl + place_value_shift) and (unsigned(pixel_x) < mh_xr + place_value_shift) and
                  (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";  
            --if it's in the br box             
            elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
                  (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";
            -- if it's in the bh box    
            elsif (unsigned(pixel_x) > bh_xl + place_value_shift) and (unsigned(pixel_x) < bh_xr + place_value_shift) and
                  (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";                                
            end if;
    end if;
        -- If the number is 6
    if decimal mod 10 = 6 then
       if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
           (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";
        -- if it's in the tl box
        elsif (unsigned(pixel_x) > tl_xl + place_value_shift) and (unsigned(pixel_x) < tl_xr + place_value_shift) and
              (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
              -- number box color blue
             red_next <= "0000";
             green_next <= "0000";
             blue_next <= "1111";
        -- if it's in the mh box
        elsif (unsigned(pixel_x) > mh_xl + place_value_shift) and (unsigned(pixel_x) < mh_xr + place_value_shift) and
              (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";    
        -- if it's in the bl box
        elsif (unsigned(pixel_x) > bl_xl + place_value_shift) and (unsigned(pixel_x) < bl_xr + place_value_shift) and
              (unsigned(pixel_y) > bl_yt) and (unsigned(pixel_y) < bl_yb) then
              -- number box color blue
             red_next <= "0000";
             green_next <= "0000";
             blue_next <= "1111";
        --if it's in the br box             
        elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
              (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        -- if it's in the bh box    
        elsif (unsigned(pixel_x) > bh_xl + place_value_shift) and (unsigned(pixel_x) < bh_xr + place_value_shift) and
              (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
           -- number box color blue
           red_next <= "0000";
           green_next <= "0000";
           blue_next <= "1111";                                
        end if;
    end if;
        -- If the number is 7
        if decimal mod 10 = 7 then
           if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
           (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";
        -- if it's in the tr box
        elsif (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
               (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        --if it's in the br box             
        elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
              (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        end if;
    end if;
        -- If the number is 8
        if decimal mod 10 = 8 then
           if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
           (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";
            -- if it's in the tl box
            elsif (unsigned(pixel_x) > tl_xl + place_value_shift) and (unsigned(pixel_x) < tl_xr + place_value_shift) and
                  (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
                  -- number box color blue
                 red_next <= "0000";
                 green_next <= "0000";
                 blue_next <= "1111";
            -- if it's in the tr box
            elsif (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
                   (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";
            -- if it's in the mh box
            elsif (unsigned(pixel_x) > mh_xl + place_value_shift) and (unsigned(pixel_x) < mh_xr + place_value_shift) and
                  (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";    
            -- if it's in the bl box
            elsif (unsigned(pixel_x) > bl_xl + place_value_shift) and (unsigned(pixel_x) < bl_xr + place_value_shift) and
                  (unsigned(pixel_y) > bl_yt) and (unsigned(pixel_y) < bl_yb) then
                  -- number box color blue
                 red_next <= "0000";
                 green_next <= "0000";
                 blue_next <= "1111";
            --if it's in the br box             
            elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
                  (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";
                blue_next <= "1111";
            -- if it's in the bh box    
            elsif (unsigned(pixel_x) > bh_xl + place_value_shift) and (unsigned(pixel_x) < bh_xr + place_value_shift) and
                  (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
               -- number box color blue
               red_next <= "0000";
               green_next <= "0000";
               blue_next <= "1111";                                
        end if;
    end if;
        -- If the number is 9
    if decimal mod 10 = 9 then
       if (unsigned(pixel_x) > th_xl + place_value_shift) and (unsigned(pixel_x) < th_xr + place_value_shift) and
       (unsigned(pixel_y) > th_yt) and (unsigned(pixel_y) < th_yb) then
           -- number box color blue
           red_next <= "0000";
           green_next <= "0000";
           blue_next <= "1111";
        -- if it's in the tl box
        elsif (unsigned(pixel_x) > tl_xl + place_value_shift) and (unsigned(pixel_x) < tl_xr + place_value_shift) and
              (unsigned(pixel_y) > tl_yt) and (unsigned(pixel_y) < tl_yb) then
              -- number box color blue
             red_next <= "0000";
             green_next <= "0000";
             blue_next <= "1111";
        -- if it's in the tr box
        elsif (unsigned(pixel_x) > tr_xl + place_value_shift) and (unsigned(pixel_x) < tr_xr + place_value_shift) and
               (unsigned(pixel_y) > tr_yt) and (unsigned(pixel_y) < tr_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        -- if it's in the mh box
        elsif (unsigned(pixel_x) > mh_xl + place_value_shift) and (unsigned(pixel_x) < mh_xr + place_value_shift) and
              (unsigned(pixel_y) > mh_yt) and (unsigned(pixel_y) < mh_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";    
        --if it's in the br box             
        elsif (unsigned(pixel_x) > br_xl + place_value_shift) and (unsigned(pixel_x) < br_xr + place_value_shift) and
              (unsigned(pixel_y) > br_yt) and (unsigned(pixel_y) < br_yb) then
            -- number box color blue
            red_next <= "0000";
            green_next <= "0000";
            blue_next <= "1111";
        -- if it's in the bh box    
        elsif (unsigned(pixel_x) > bh_xl + place_value_shift) and (unsigned(pixel_x) < bh_xr + place_value_shift) and
              (unsigned(pixel_y) > bh_yt) and (unsigned(pixel_y) < bh_yb) then
           -- number box color blue
           red_next <= "0000";
           green_next <= "0000";
           blue_next <= "1111";                                
        end if;
    end if;
    
        if y = "100" and BTN(0) = '1' then
            if (unsigned(pixel_x) > gt_first_xl) and (unsigned(pixel_x) < gt_first_xr) and
               (unsigned(pixel_y) > gt_first_yt) and (unsigned(pixel_y) < gt_first_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";   
                blue_next <= "1111";
            elsif (unsigned(pixel_x) > second_xl) and (unsigned(pixel_x) < second_xr) and
               (unsigned(pixel_y) > second_yt) and (unsigned(pixel_y) < second_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";   
                blue_next <= "1111";
            elsif (unsigned(pixel_x) > gt_third_xl) and (unsigned(pixel_x) < gt_third_xr) and
               (unsigned(pixel_y) > gt_third_yt) and (unsigned(pixel_y) < gt_third_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";   
                blue_next <= "1111";
            elsif (unsigned(pixel_x) > fourth_xl) and (unsigned(pixel_x) < fourth_xr) and
               (unsigned(pixel_y) > fourth_yt) and (unsigned(pixel_y) < fourth_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";   
                blue_next <= "1111";
            elsif (unsigned(pixel_x) > gt_fifth_xl) and (unsigned(pixel_x) < gt_fifth_xr) and
               (unsigned(pixel_y) > gt_fifth_yt) and (unsigned(pixel_y) < gt_fifth_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";   
                blue_next <= "1111";
            end if;
            
        elsif y = "010" and BTN(0) = '1' then
            if (unsigned(pixel_x) > lt_first_xl) and (unsigned(pixel_x) < lt_first_xr) and
                       (unsigned(pixel_y) > lt_first_yt) and (unsigned(pixel_y) < lt_first_yb) then
                        -- number box color blue
                        red_next <= "0000";
                        green_next <= "0000";   
                        blue_next <= "1111";
                    elsif (unsigned(pixel_x) > second_xl) and (unsigned(pixel_x) < second_xr) and
                       (unsigned(pixel_y) > second_yt) and (unsigned(pixel_y) < second_yb) then
                        -- number box color blue
                        red_next <= "0000";
                        green_next <= "0000";   
                        blue_next <= "1111";
                    elsif (unsigned(pixel_x) > lt_third_xl) and (unsigned(pixel_x) < lt_third_xr) and
                       (unsigned(pixel_y) > lt_third_yt) and (unsigned(pixel_y) < lt_third_yb) then
                        -- number box color blue
                        red_next <= "0000";
                        green_next <= "0000";   
                        blue_next <= "1111";
                    elsif (unsigned(pixel_x) > fourth_xl) and (unsigned(pixel_x) < fourth_xr) and
                       (unsigned(pixel_y) > fourth_yt) and (unsigned(pixel_y) < fourth_yb) then
                        -- number box color blue
                        red_next <= "0000";
                        green_next <= "0000";   
                        blue_next <= "1111";
                    elsif (unsigned(pixel_x) > lt_fifth_xl) and (unsigned(pixel_x) < lt_fifth_xr) and
                       (unsigned(pixel_y) > lt_fifth_yt) and (unsigned(pixel_y) < lt_fifth_yb) then
                        -- number box color blue
                        red_next <= "0000";
                        green_next <= "0000";   
                        blue_next <= "1111";
                    end if;
                    
        elsif y = "001" and BTN(0) = '1' then
            if (unsigned(pixel_x) > eu_xl) and (unsigned(pixel_x) < eu_xr) and
               (unsigned(pixel_y) > eu_yt) and (unsigned(pixel_y) < eu_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";   
                blue_next <= "1111";
            elsif (unsigned(pixel_x) > el_xl) and (unsigned(pixel_x) < el_xr) and
                (unsigned(pixel_y) > el_yt) and (unsigned(pixel_y) < el_yb) then
                -- number box color blue
                red_next <= "0000";
                green_next <= "0000";   
                blue_next <= "1111";
            end if;
    end if;
end process;

   -- generate r,g,b registers
   process ( video_on, pixel_tick, red_next, green_next, blue_next)
   begin
      if rising_edge(pixel_tick) then
          if (video_on = '1') then
            red_reg <= red_next;
            green_reg <= green_next;
            blue_reg <= blue_next;   
          else
            red_reg <= "0000";
            green_reg <= "0000";
            blue_reg <= "0000";                    
          end if;
      end if;
   end process;
   
   VGA_R <= STD_LOGIC_VECTOR(red_reg);
   VGA_G <= STD_LOGIC_VECTOR(green_reg); 
   VGA_B <= STD_LOGIC_VECTOR(blue_reg);

end vga_top;