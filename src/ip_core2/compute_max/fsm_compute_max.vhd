----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.07.2017 16:36:50
-- Design Name:
-- Module Name: fsm_compute_max - Behavioral
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

entity fsm_compute_max is
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           max_done : in STD_LOGIC;
           start : out STD_LOGIC;
           valid_out : out STD_LOGIC;
           ready_out : out STD_LOGIC;
           reset_n_all : out STD_LOGIC);
end fsm_compute_max;

architecture Behavioral of fsm_compute_max is

type state is (reset, waiting_for_valid_in, elaboration, done, waiting_for_ready_in, waiting_1, waiting_2, waiting_3, waiting_4);
signal current_state, next_state : state := reset;

begin

registro_stato : process(clock, reset_n, next_state)
begin
	if(reset_n = '0') then
		current_state <= reset;
	elsif(rising_edge(clock)) then
		current_state <= next_state;
	end if;
end process;

fsm_next_state : process(current_state, reset_n, valid_in, ready_in, max_done)
begin

  case current_state is
      when reset =>
                  if(reset_n = '0')then
                      next_state <= reset;
                  else
                      next_state <= waiting_for_valid_in;
                  end if;
      when waiting_for_valid_in =>
                                  if(valid_in = '0')then
                                      next_state <= waiting_for_valid_in;
                                  else
                                      next_state <= elaboration;
                                  end if;
      when elaboration =>
                        next_state <= waiting_1;
      when waiting_1 =>
                        next_state <= waiting_2;
      when waiting_2 =>
                        next_state <= waiting_3;
      when waiting_3 =>
                        next_state <= waiting_4;
      when waiting_4 =>
                        next_state <= done;
      when done =>
                  if(max_done = '1') then
                      next_state <= waiting_for_ready_in;
                  else
                      next_state <= waiting_for_valid_in;
                  end if;
      when waiting_for_ready_in =>
                                  if(ready_in = '1')then
                                      next_state <= reset;
                                  else
                                      next_state <= waiting_for_ready_in;
                                  end if;
      end case;
end process;


fsm_output : process(current_state)
begin

 valid_out <= '0';
 ready_out <= '0';
 start <= '0';
 reset_n_all <= '1';

case current_state is
   when reset =>
                reset_n_all <= '0';
   when waiting_for_valid_in =>
                              ready_out <= '1';
   when elaboration =>
                      start <= '1';
   when waiting_1 =>
   when waiting_2 =>
   when waiting_3 =>
   when waiting_4 =>
   when done =>
   when waiting_for_ready_in =>
                                valid_out <= '1';
   end case;
end process;


end Behavioral;
