----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:49:26 12/20/2015 
-- Design Name: 
-- Module Name:    counter_modulo_n - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_modulo_n is
	 generic ( n : natural := 16 );
    Port ( clock : in  STD_LOGIC;
           count_en : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
			  load_conteggio : in STD_LOGIC;
			  conteggio_in : in STD_LOGIC_VECTOR (natural(ceil(log2(real(n))))-1 downto 0);
           conteggio_out : out  STD_LOGIC_VECTOR ((natural(ceil(log2(real(n)))))-1 downto 0);
           count_hit : out  STD_LOGIC);
end counter_modulo_n;

architecture Behavioral of counter_modulo_n is

signal pre_conteggio_out : std_logic_vector (natural(ceil(log2(real(n))))-1 downto 0);

begin

contatore : process(clock, reset_n)
begin
	if (reset_n = '0') then
		count_hit <= '0';
		if(up_down = '0') then
			pre_conteggio_out <= (others => '0');
		else
			pre_conteggio_out <= conv_STD_LOGIC_VECTOR(n-1, natural(ceil(log2(real(n)))));
		end if;
	elsif (rising_edge(clock)) then
		if (load_conteggio = '1') then
			pre_conteggio_out <= conteggio_in;
		elsif (count_en = '1') then
			if (up_down = '0') then
				if (pre_conteggio_out = n-1) then
					count_hit <= '1';
					pre_conteggio_out <= (others => '0');
				else
					count_hit <= '0';
					pre_conteggio_out <= pre_conteggio_out + 1;
				end if;
			else
				if (pre_conteggio_out = 0) then
					count_hit <= '1';
					pre_conteggio_out <= conv_STD_LOGIC_VECTOR(n-1, natural(ceil(log2(real(n)))));
				else
					count_hit <= '0';
					pre_conteggio_out <= pre_conteggio_out - 1;
				end if;
			end if;
		end if;
	end if;
end process;

conteggio_out <= pre_conteggio_out;

end Behavioral;

