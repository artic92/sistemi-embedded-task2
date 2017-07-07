----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:05:40 11/13/2015 
-- Design Name: 
-- Module Name:    full_adder - Structural 
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

entity full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c_in : in  STD_LOGIC;
           c_out : out  STD_LOGIC;
           s : out  STD_LOGIC);
end full_adder;

architecture Structural of full_adder is

COMPONENT half_adder
	PORT(
		a : IN std_logic;
		b : IN std_logic;          
		c : OUT std_logic;
		s : OUT std_logic
		);
END COMPONENT;

signal internal_sig : std_logic_vector (2 downto 0);

begin

half_adder1: half_adder 
		port map(a => a, b => b, c=> internal_sig(1), s => internal_sig(0));
																				
half_adder2: half_adder
		port map(a => internal_sig(0), b => c_in, c=> internal_sig(2), s => s);																

c_out <= internal_sig(2) or internal_sig(1);

end Structural;

