----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.07.2017 11:30:11
-- Design Name:
-- Module Name: fsm_complex_abs - Behavioral
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

entity fsm_complex_abs is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           abs_done : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           ready_out : out STD_LOGIC);
end fsm_complex_abs;

architecture Behavioral of fsm_complex_abs is

type state is (reset , waiting_for_valid_in , elaborazione , waiting_for_ready_in);
signal current_state, next_state : state := reset;


begin

registro_stato : process(clk, reset_n, next_state)
begin
	if(reset_n = '0') then
		  current_state <= reset;
	  elsif(rising_edge(clk)) then
		  current_state <= next_state;
	  end if;
end process;

fsm_next_state : process(current_state, reset_n, valid_in, abs_done, ready_in)
begin
  case current_state is
      when reset =>
                  if(reset_n = '0') then
                      next_state <= reset;
                  else
                      next_state <= waiting_for_valid_in;
                  end if;
      when waiting_for_valid_in =>
                                  if(valid_in = '0') then
                                      next_state <= waiting_for_valid_in;
                                  else
                                      next_state <= elaborazione;
                                  end if;
      when elaborazione =>
                          if(abs_done <= '0') then
                              next_state <= elaborazione;
                          else
                              next_state <= waiting_for_ready_in;
                          end if;
      when waiting_for_ready_in =>
                                  if(ready_in = '0') then
                                      next_state <= waiting_for_ready_in;
                                  else
                                      next_state <= waiting_for_valid_in;
                                  end if;
      end case;
end process;


fsm_uscita : process(current_state)
begin
  valid_out <= '0';
  ready_out <= '0';

  case current_state is
      when reset =>
      when waiting_for_valid_in =>
                                  ready_out<='1';
      when elaborazione =>
      when waiting_for_ready_in =>
                                  valid_out <= '1';
  end case;
end process;


end Behavioral;
