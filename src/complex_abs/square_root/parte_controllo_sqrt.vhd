----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:36:01 11/23/2015 
-- Design Name: 
-- Module Name:    parte_controllo - Behavioral 
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

entity parte_controllo_sqrt is
    Port ( clock : in  STD_LOGIC;
           reset_n_all : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           count_hit : in  STD_LOGIC;
           load_qd : out  STD_LOGIC;
           load_r : out  STD_LOGIC;
           reset_n : out  STD_LOGIC;
           shift : out  STD_LOGIC;
           count_en : out  STD_LOGIC;
           done : out  STD_LOGIC);
end parte_controllo_sqrt;

architecture Behavioral of parte_controllo_sqrt is

type state is (reset, init, operation, lshift, output);
signal current_state, next_state : state := reset; 

begin

registro_stato : process(clock, reset_n_all)
begin
	if(reset_n_all = '0') then
		current_state <= reset;
	elsif(clock = '1' and clock'event) then
		current_state <= next_state;
	end if;
end process;

fsm : process(current_state, reset_n_all, enable, count_hit)
begin

	load_qd <= '0';
	load_r <= '0';
	reset_n <= '1';
	shift <= '0';
	count_en <= '0';
	done <= '0';
	
	case current_state is
		when reset =>
										reset_n <= '0';
										if(enable = '1') then
											next_state <= init;
										else
											next_state <= reset;
										end if;
		when init =>
										load_qd <= '1';
										next_state <= operation;
		when operation =>
														load_r <= '1';
														count_en <= '1';
														next_state <= lshift;
		when lshift =>
											shift <= '1';
											if(count_hit = '0') then
													next_state <= operation;
											else
													next_state <= output;
											end if;
		when output => 
											-- Stato che mostra solo il risultato
											done <= '1';
											next_state <= output;
	end case;
end process;

end Behavioral;

