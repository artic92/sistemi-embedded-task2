----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.07.2017 16:36:50
-- Design Name:
-- Module Name: fsm_dds_wrapper - Behavioral
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

entity fsm_dds_wrapper is
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           count_hit : in STD_LOGIC;
           valid_in_out : out STD_LOGIC;
           reset_n_all : out STD_LOGIC;
           done : out STD_LOGIC);
end fsm_dds_wrapper;

architecture Behavioral of fsm_dds_wrapper is

type state is (idle, reset_dds, waiting_for_count_hit, op_done);
signal current_state, next_state : state := idle;

begin

registro_stato : process(clock, reset_n, next_state)
begin
	if(reset_n = '0') then
		current_state <= idle;
	elsif(rising_edge(clock)) then
		current_state <= next_state;
	end if;
end process;

fsm_next_state : process(current_state, reset_n, valid_in, count_hit)
begin

  case current_state is
      when idle =>
                          if(valid_in = '1') then
                              next_state <= reset_dds;
                          else
                              next_state <= idle;
                          end if;
      when reset_dds =>
                          next_state <= waiting_for_count_hit;
      when waiting_for_count_hit =>
                                    if(count_hit = '1') then
                                        next_state <= op_done;
                                    else
                                        next_state <= waiting_for_count_hit;
                                    end if;
      when op_done =>
                      if(valid_in = '1') then
                          next_state <= reset_dds;
                      else
                          next_state <= op_done;
                      end if;
      end case;
end process;


fsm_output : process(current_state)
begin

 valid_in_out <= '0';
 reset_n_all <= '1';
 done <= '0';

case current_state is
   when idle =>
                reset_n_all <= '0';
   when reset_dds =>
                      valid_in_out <= '1';
                      reset_n_all <= '0';
   when waiting_for_count_hit =>
   when op_done =>
                  reset_n_all <= '0';
                  done <= '1';
   end case;
end process;


end Behavioral;
