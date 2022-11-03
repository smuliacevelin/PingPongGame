----------------------------------------------------------------------------------

-- Students: Rus Rebeca, Smuliac Evelin, Zinveliu Ioana 
-- 
-- Create Date: 05/21/2022 02:13:19 PM
-- Module Name: main - Behavioral
-- Project Name: Ping Pong Game

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity main_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out std_logic_vector (3 downto 0);
           seg : out std_logic_vector (0 to 6);
           dp : out std_logic
          );
         
end main_control;

architecture Behavioral of main is

type states is (start, led_on, led_off, count_up, count_dwn, add_score_l, add_scor_r);

signal current_state, next_state : states;

signal i : integer range 0 to 15;   
signal score : STD_LOGIC_VECTOR (15 downto 0);

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

process (clk, rst)
begin
  if rst = '1' then
    current_state <= start;
  elsif rising_edge(clk) then
    current_state <= next_state;
  end if;    
end process;



end Behavioral;
