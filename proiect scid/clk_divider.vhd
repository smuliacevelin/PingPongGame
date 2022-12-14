----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2022 01:18:05 PM
-- Design Name: 
-- Module Name: clk_divider - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is

signal count: integer:=1;
signal tmp : std_logic := '0';

begin

process(clk,rst)
begin
if(rst='1') then
    count<=1;
    tmp<='0';
elsif(clk'event and clk='1') then
    count <=count+1;
    if (count = 25000) then
        tmp <= NOT tmp;
        count <= 1;
    end if;
end if;
clk_out <= tmp;
end process;

end Behavioral;
