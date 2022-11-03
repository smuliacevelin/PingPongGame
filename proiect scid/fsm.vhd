----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2022 11:41:04 AM
-- Design Name: 
-- Module Name: fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity fsm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           btn : in STD_LOGIC_VECTOR (2 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 to 0);
           dp : out STD_LOGIC);
end fsm;

architecture Behavioral of fsm is

type states is (led_15, led_0, count_up, count_down, add_scor_l, add_scor_r);
signal current_state, next_state : states;
signal btn_l, btn_r, cnt, cy, en_up, en_dwn : std_logic;

signal i : integer range 0 to 15;    
signal score : STD_LOGIC_VECTOR (15 downto 0);
signal start, stop : std_logic;

signal clk_div : std_logic;
signal en_cnt : std_logic;

component driver7seg is
    Port ( clk : in STD_LOGIC; --100MHz board clock input
           Din : in STD_LOGIC_VECTOR (15 downto 0); --16 bit binary data for 4 displays
           an : out STD_LOGIC_VECTOR (3 downto 0); --anode outputs selecting individual displays 3 to 0
           seg : out STD_LOGIC_VECTOR (0 to 6); -- cathode outputs for selecting LED-s in each display
           dp_in : in STD_LOGIC_VECTOR (3 downto 0); --decimal point input values
           dp_out : out STD_LOGIC; --selected decimal point sent to cathodes
           rst : in STD_LOGIC); --global reset
end component driver7seg;

begin

u : driver7seg port map (clk => clk,
                         Din => score,
                         an => an,
                         seg => seg,
                         dp_in => "0000",
                         dp_out => dp,
                         rst => rst);
                        
-- timer
process(clk, rst)
variable q : integer := 0;
begin
  if rst = '1' then
    q := 0;
    clk_div <= '0';
  elsif rising_edge(clk) then
    if en_cnt = '1' then  
      if q = 10**8 - 1 then
        q := 1;
        clk_div <= '1';
      else
        q := q + 1;
        clk_div <= '0';
      end if;
    end if;        
  end if;  
end process;

process(rst, clk_div)
begin
    if rst ='1' then
        current_state <= led_15;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;


process (current_state, clk_div)
begin
  case current_state is
    when led_15 => next_state <= count_down;
    when count_down => en_dwn <= '1';
    when count_down => if cnt = '1' then 
        led <= "100000000000000";
        led <= "010000000000000" after 5 ns;
        led <= "001000000000000" after 5 ns;
        led <= "000100000000000" after 5 ns;
        led <= "000010000000000" after 5 ns;
        led <= "000001000000000" after 5 ns;
        led <= "000000100000000" after 5 ns;
        led <= "000000010000000" after 5 ns;
        led <= "000000001000000" after 5 ns;
        led <= "000000000100000" after 5 ns;
        led <= "000000000010000" after 5 ns;
        led <= "000000000001000" after 5 ns;
        led <= "000000000000100" after 5 ns;
        led <= "000000000000010" after 5 ns;
        led <= "000000000000001" after 5 ns;
        en_dwn <= '0';
        end if;
   
   -- when count_up => en_up <= '1';
    when count_up => if (cnt = '1' and btn_r = '1' and cy = '0') then
        led <= "000000000000001";
        led <= "000000000000010" after 5 ns;
        led <= "000000000000100" after 5 ns;
        led <= "000000000001000" after 5 ns;
        led <= "000000000010000" after 5 ns;
        led <= "000000000100000" after 5 ns;
        led <= "000000001000000" after 5 ns;
        led <= "000000010000000" after 5 ns;
        led <= "000000100000000" after 5 ns;
        led <= "000001000000000" after 5 ns;
        led <= "000010000000000" after 5 ns;
        led <= "000100000000000" after 5 ns;
        led <= "001000000000000" after 5 ns;
        led <= "010000000000000" after 5 ns;
        led <= "100000000000000" after 5 ns;
        en_up <= '0';
        -- if (cnt = '1' and cy = '1') then add_scor_l <= add_scor_l + 1;
        -- when led_0 => if cy then next_state <= led_15;
           next_state <= led_15;
        end if;
      
    end case;
                                         
end process;

    
-- SSD display       
--generate_scor: process (clk, rst)
--  variable mii, sute, zeci, unitati: integer range 0 to 9 := 0;
--begin
--  if rst = '1' then
--    score <= (others => '0');
--    mii := 0;
--    sute := 0;
--    zeci := 0;
--    unitati := 0;
--  elsif rising_edge(clk) then
--    if current_state = count then
--      if unitati = 9 then
--        unitati := 0;
--        if zeci = 9 then
--          zeci := 0;
--          if sute = 9 then
--            sute := 0;
--            if mii = 9 then
--              mii := 0;
--            else
--              mii := mii+1;
--            end if;
--          else
--            sute := sute+1;
--          end if;
--        else
--          zeci := zeci+1;
--        end if;
--      else
--        unitati := unitati+1;
--    end if;
    
--    score <= std_logic_vector(to_unsigned(mii,4)) &
--             std_logic_vector(to_unsigned(sute,4)) &
--             std_logic_vector(to_unsigned(zeci,4)) &
--             std_logic_vector(to_unsigned(unitati,4));
    
--    end if;
--  end if;
--end process;  
  
end Behavioral;
