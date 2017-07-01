----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:00:31 11/13/2015 
-- Design Name: 
-- Module Name:    add_sub - Structural 
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

entity add_sub is
	 generic ( n : natural := 8);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           subtract : in  STD_LOGIC;
           ovfl : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (n-1 downto 0));
end add_sub;

architecture Structural of add_sub is

COMPONENT ripple_carry_adder
	generic ( n : natural := 4);
	PORT(
		A : IN std_logic_vector(n-1 downto 0);
		B : IN std_logic_vector(n-1 downto 0);
		c_in : IN std_logic;          
		ovfl : OUT std_logic;
		S : OUT std_logic_vector(n-1 downto 0)
		);
	END COMPONENT;

COMPONENT carry_lookahead_n_bit
	generic ( n : natural := 4);
	PORT(
		A : IN std_logic_vector(n-1 downto 0);
		B : IN std_logic_vector(n-1 downto 0);
		c_in : IN std_logic;          
		ovfl : OUT std_logic; 
		S : OUT std_logic_vector(n-1 downto 0)
		);
END COMPONENT;

COMPONENT carry_select_4n_bit
	generic ( n : natural := 8);
   PORT ( 
		A : in  STD_LOGIC_VECTOR (n-1 downto 0);
	  B : in  STD_LOGIC_VECTOR (n-1 downto 0);
	  c_in : in  STD_LOGIC;
	  ovfl : out  STD_LOGIC;
	  S : out  STD_LOGIC_VECTOR (n-1 downto 0)
			  );
END COMPONENT;

signal b_sig: std_logic_vector (n-1 downto 0);

begin

b_sig <= B xor (B'range => subtract);

ripple_carry : ripple_carry_adder 
	generic map (n)
	PORT MAP(A => A, B => b_sig, c_in => subtract, ovfl => ovfl, S => S);

--carry_lookahead : carry_lookahead_n_bit 
--	generic map (n)
--	PORT MAP(A => A, B => b_sig, c_in => subtract, ovfl => ovfl, S => S);
	
--carry_select : carry_select_4n_bit 
--	generic map (n)
--	PORT MAP(A => A, B => b_sig, c_in => subtract, ovfl => ovfl, S => S);
	
end Structural;

