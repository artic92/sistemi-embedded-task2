----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    18:16:54 11/06/2015
-- Design Name:
-- Module Name:    d_edge_triggered - Behavioral
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

entity d_edge_triggered is
	 generic (delay : time := 0 ns);
    Port (data_in : in  STD_LOGIC;
          reset_n : in  STD_LOGIC;
          clock : in  STD_LOGIC;
          data_out : out  STD_LOGIC);
end d_edge_triggered;

architecture Behavioral of d_edge_triggered is

begin

process(clock, reset_n, data_in)
begin
	-- Reset asincrono
	if (reset_n = '0') then
		data_out <= '0' after delay;
	--elsif (clk = '1' and clock'event) then
	elsif (rising_edge(clock)) then
		data_out <= data_in after delay;
end if;
end process;

end Behavioral;
