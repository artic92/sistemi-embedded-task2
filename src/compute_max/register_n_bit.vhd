----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:03:04 11/07/2015 
-- Design Name: 
-- Module Name:    register_n_bit - Behavioral 
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

entity register_n_bit is
	generic (n : natural := 8;
					delay : time := 0 ns);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
end register_n_bit;

architecture Behavioral of register_n_bit is

begin
process (clock, load, reset_n)
begin
if (reset_n = '0') then
	O <=  (others => '0');
elsif (clock = '1' and rising_edge(clock)) then
	if (load = '1') then
		O <= I after delay;
	end if;
end if;
end process;

end Behavioral;
