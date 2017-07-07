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

entity parte_controllo is
	 generic ( n : natural := 4;
						 m : natural := 4);
    Port ( clock : in  STD_LOGIC;
           reset_n_all : in  STD_LOGIC;
           q0 : in  STD_LOGIC;
			  q_1 : in STD_LOGIC;
           enable : in  STD_LOGIC;
           conteggio : in  STD_LOGIC;
           load_a : out  STD_LOGIC;
           load_m : out  STD_LOGIC;
           load_q : out  STD_LOGIC;
           reset_n : out  STD_LOGIC;
           shift : out  STD_LOGIC;
           sub : out  STD_LOGIC;
           count_en : out  STD_LOGIC;
           done : out  STD_LOGIC);
end parte_controllo;

architecture Behavioral of parte_controllo is

type state is (reset, init, scan, add, subtract, rshift, output, load);
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

f_stato_prossimo : process(current_state, reset_n_all, q0, q_1, enable, conteggio)
begin
	case current_state is
		when reset =>
									if(enable = '1') then
										next_state <= init;	
									else
										next_state <= reset;	
									end if;
		when init =>
									next_state <= scan;
		when scan =>				
										if(conteggio = '0') then
											if(q0 = q_1) then
												next_state <= rshift;
											elsif(q0 = '0') then
												next_state <= add;
											elsif(q0 = '1') then
												next_state <= subtract;
											end if;
										else
											next_state <= output;
									end if;
		when add =>
									next_state <= load;
		when subtract =>
									next_state <= load;
		when rshift =>
										next_state <= scan;
		when output =>
												next_state <= output;		
		when load =>
										-- Stato fittizio incluso per far commutare l'uscita sh_out in maniera corretta
										-- non so xkè ma questa si aggiorna un ciclo di clock dopo l'op di add o sub
										next_state <= rshift;
	end case;
end process;

f_uscita : process(current_state) --MOORE
begin
	
	load_a <= '0';
	load_m <= '0';
	load_q <= '0';
	reset_n <= '1';
	shift <= '0';
	sub <= '0';
	count_en <= '0';
	done <= '0';
	
	case current_state is
		when reset =>
											reset_n <= '0';
		when init =>
										load_m <= '1';
										load_q <= '1';
		when scan =>
		when add =>
										load_a <= '1';
		when subtract =>
													load_a <= '1';
													sub <= '1';
		when rshift =>
											shift <= '1';
											count_en <= '1';
		when output =>
												done <= '1';
		when load =>
	end case;								
end process;

end Behavioral;

