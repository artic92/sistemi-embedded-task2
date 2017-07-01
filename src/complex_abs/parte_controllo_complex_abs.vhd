----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    15:25:37 06/26/2017
-- Design Name:
-- Module Name:    parte_controllo_complex_abs - Behavioral
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

entity parte_controllo_complex_abs is
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           done_mul : in STD_LOGIC;
           reset_n_all : out STD_LOGIC;
           enable_mul : out STD_LOGIC;
           done : out STD_LOGIC);
end parte_controllo_complex_abs;

architecture Behavioral of parte_controllo_complex_abs is

type state is (reset, waiting_mul, add, op_done);
signal current_state, next_state : state := reset;

begin

  registro_stato : process(clock, reset_n)
  begin
  	if(reset_n = '0') then
  		current_state <= reset;
  	elsif(clock = '1' and clock'event) then
  		current_state <= next_state;
  	end if;
  end process;

  fsm : process(current_state, reset_n, done_mul)
  begin

  	enable_mul <= '0';
    reset_n_all <= '1';
    done <= '0';

  	case current_state is
  		when reset =>
                      reset_n_all <= '0';
  										if(reset_n = '1') then
  											next_state <= waiting_mul;
  										else
  											next_state <= reset;
  										end if;
  		when waiting_mul =>
                          enable_mul <= '1';
                          if(done_mul = '1') then
                            next_state <= add;
                          else
                            next_state <= waiting_mul;
                          end if;
      when add =>
                    next_state <= op_done;
      when op_done =>
                    done <= '1';
                    next_state <= reset;
  	end case;
  end process;

end Behavioral;
