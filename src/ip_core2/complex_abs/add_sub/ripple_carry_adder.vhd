----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:21:14 11/13/2015 
-- Design Name: 
-- Module Name:    ripple_carry_adder - Structural 
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

entity ripple_carry_adder is
	generic ( n : natural := 4 );
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  c_in : in STD_LOGIC;
			  c_out : out STD_LOGIC;
           ovfl : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (n-1 downto 0));
end ripple_carry_adder;

architecture Structural of ripple_carry_adder is

COMPONENT full_adder
	PORT(
		a : IN std_logic;
		b : IN std_logic;
		c_in : IN std_logic;          
		c_out : OUT std_logic;
		s : OUT std_logic
		);
END COMPONENT;

signal d_sig : std_logic_vector (n downto 0);
	
begin

d_sig(0) <= c_in;
-- Uscita di overflow (overflow per numeri in complementi a 2)
ovfl <= d_sig(n) xor d_sig(n-1);
-- Uscita di carry_out (overflow per numeri binari naturali)
c_out <= d_sig(n);

adder_gen : for k in n-1 downto 0 generate
	full_adder_i: full_adder
	port map(a => A(k), b => B(k), c_in => d_sig(k), c_out => d_sig(k+1), s => S(k));
end generate;

end Structural;