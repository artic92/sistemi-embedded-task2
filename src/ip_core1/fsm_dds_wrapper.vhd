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
           reset_n_all : out STD_LOGIC);
end fsm_dds_wrapper;

architecture Behavioral of fsm_dds_wrapper is

type state is (reset_dds_1, reset_dds_2, waiting_for_count_hit);
signal current_state, next_state : state := reset_dds_1;

begin

registro_stato : process(clock, reset_n, next_state)
begin
	if(reset_n = '0') then
		current_state <= reset_dds_1;
	elsif(rising_edge(clock)) then
		current_state <= next_state;
	end if;
end process;

fsm_next_state : process(current_state, reset_n, valid_in, count_hit)
begin

  case current_state is
      when reset_dds_1 =>
                          if(reset_n = '1' and valid_in = '1')then
                              next_state <= reset_dds_2;
                          else
                              next_state <= reset_dds_1;
                          end if;
      when reset_dds_2 =>
                          next_state <= waiting_for_count_hit;
      when waiting_for_count_hit =>
                                    if(count_hit = '1')then
                                        next_state <= reset_dds_1;
                                    else
                                        next_state <= waiting_for_count_hit;
                                    end if;
      end case;
end process;


fsm_output : process(current_state)
begin

 reset_n_all <= '1';

case current_state is
   when reset_dds_1 =>
                      reset_n_all <= '0';
   when reset_dds_2 =>
                      reset_n_all <= '0';
   when waiting_for_count_hit =>
   end case;
end process;


end Behavioral;
