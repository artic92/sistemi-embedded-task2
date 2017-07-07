----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:51 11/08/2015 
-- Design Name: 
-- Module Name:    shift_register_n_bit - Behavioral 
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

entity shift_register_n_bit is
	 generic (n : natural := 8;
						delay : time := 0 ns);
    Port ( D_IN : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  clock : in STD_LOGIC;
	        reset_n : in  STD_LOGIC;
           load : in  STD_LOGIC;
           shift : in  STD_LOGIC;
           lt_rt : in  STD_LOGIC;
			  sh_in : in STD_LOGIC;
			  sh_out : out STD_LOGIC;
           D_OUT : out  STD_LOGIC_VECTOR (n-1 downto 0));
end shift_register_n_bit;

architecture Behavioral of shift_register_n_bit is

signal pre_o : STD_LOGIC_VECTOR (n-1 downto 0);

begin

process (clock, reset_n)
--variable pre_o : STD_LOGIC_VECTOR (n-1 downto 0);
begin
if (reset_n = '0') then
	pre_o <= (others => '0');
--	pre_o := (others => '0');
	sh_out <= '0';
elsif (clock = '1' and clock'event) then
	if (load = '1') then
		pre_o <= D_IN;
--		pre_o := D_IN;
	elsif(shift = '1') then
		if (lt_rt = '0') then
			pre_o <= pre_o (n-2 downto 0) & sh_in;
--			pre_o := pre_o (n-2 downto 0) & sh_in;
		elsif(lt_rt = '1') then
			pre_o  <= sh_in & pre_o (n-1 downto 1);
--			pre_o  := sh_in & pre_o (n-1 downto 1);
		end if;
	end if;
	-- sia che faccio load che shift devo aggiornare sh_out al suo valore reale
	if(lt_rt = '0') then
		sh_out <= pre_o(n-1);
	elsif(lt_rt = '1') then
		sh_out <= pre_o(0);
	end if;
end if;
--D_OUT <= pre_o;
end process;

-- MI ESCE X CON QSTA ASSEGNAZIONE
--sh_out <= pre_o(n-1) when (lt_rt = '0') else
--					  pre_o(0);
D_OUT <= pre_o;

end Behavioral;