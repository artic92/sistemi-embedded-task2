----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:59:58 11/21/2015 
-- Design Name: 
-- Module Name:    parte_operativa - Structural 
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

-- Prodotto m*n
entity parte_operativa is
	 generic ( n : natural := 4;
						 m : natural := 4);
    Port ( X : in  STD_LOGIC_VECTOR (n-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (m-1 downto 0);
			  load_a : in STD_LOGIC;
           load_q : in  STD_LOGIC;
           load_m : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           shift : in  STD_LOGIC;
           sub : in  STD_LOGIC;
           clock : in  STD_LOGIC;
			  q0 : out STD_LOGIC;
			  q_1 : out STD_LOGIC;
			  P : out STD_LOGIC_VECTOR (n+m-1 downto 0)
			  );
end parte_operativa;

architecture Structural of parte_operativa is

COMPONENT register_n_bit
	generic (n : natural := 8;
					delay : time := 0 ns);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT add_sub
	 generic ( n : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           subtract : in  STD_LOGIC;
           ovfl : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT shift_register_n_bit
	 generic (n : natural := 8;
						delay : time := 0 ns);
    Port (D_IN : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  clock : in STD_LOGIC;
	        reset_n : in  STD_LOGIC;
           load : in  STD_LOGIC;
           shift : in  STD_LOGIC;
           lt_rt : in  STD_LOGIC;
			  sh_in : in STD_LOGIC;
			  sh_out : out STD_LOGIC;
           D_OUT : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

signal ingresso_a, uscita_a, moltiplicando : std_logic_vector(n-1 downto 0)  := (others => '0');
signal uscita_q : std_logic_vector(m-1 downto 0)  := (others => '0');
signal q_1_sig, sh_out_a_q : std_logic := '0';

alias AI is ingresso_a;
alias AU is uscita_a;
alias QU is uscita_q;
alias QU0 is uscita_q(0);
alias QU_1 is q_1_sig;

begin

P <= (AU & QU);
q0 <= QU0;
q_1 <= QU_1;

registro_moltiplicando : register_n_bit
	generic map(n)
	PORT MAP(I => X, clock => clock,	load => load_m, reset_n => reset_n, 
								O => moltiplicando);
	
a : shift_register_n_bit 
	generic map(n)
	PORT MAP(D_IN => AI, clock => clock, reset_n => reset_n, load => load_a, shift => shift,   
								lt_rt => '1', sh_in => uscita_a(n-1), sh_out => sh_out_a_q , D_OUT => AU);								

q : shift_register_n_bit 
	generic map(m)
	PORT MAP(D_IN=> Y, clock => clock, reset_n => reset_n, load => load_q, shift => shift,   
								lt_rt => '1', sh_in => sh_out_a_q, sh_out => q_1_sig,  D_OUT => QU);											

adder_subtracter : add_sub
	generic map(n)
	PORT MAP(A => AU,	B => moltiplicando, subtract => sub, ovfl => open, S => AI);
								
end Structural;
