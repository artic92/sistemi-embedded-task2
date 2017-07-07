----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:45 11/23/2015 
-- Design Name: 
-- Module Name:    contatore_modulo_n - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contatore_modulo_n is
	 generic (n : natural := 4);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           count_en : in  STD_LOGIC;
			  up_down : in STD_LOGIC;
           mod_n : out  STD_LOGIC);
end contatore_modulo_n;

architecture Behavioral of contatore_modulo_n is

begin

process (clock, reset_n, up_down)

variable conteggio : natural range 0 to n-1 := 0;

begin
if (reset_n = '0') then
	mod_n <= '0';
	if(up_down = '0') then
		conteggio := 0;
	else
		conteggio := n-1;
	end if;
elsif (clock = '1' and clock'event) then
	if (count_en = '1') then
		if (up_down = '0') then
			if(conteggio = n-1) then
				mod_n <= '1';
				conteggio := 0;
			else 
				mod_n <= '0';
				conteggio := conteggio + 1;
			end if;
		else
			if(conteggio = 0) then
				mod_n <= '1';
				conteggio := n-1;
			else 
				mod_n <= '0';
				conteggio := conteggio - 1;
			end if;
		end if;
	end if;
end if;

end process;

end Behavioral;

