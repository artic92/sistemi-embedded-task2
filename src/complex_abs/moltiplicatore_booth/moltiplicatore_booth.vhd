----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:39:58 11/23/2015 
-- Design Name: 
-- Module Name:    moltiplicatore_booth - Structural 
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Moltilplicando A, moltplicatore B
entity moltiplicatore_booth is
	 generic ( n : natural := 4;
						 m : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (m-1 downto 0);
			  enable : in STD_LOGIC;
			  reset_n : in STD_LOGIC;
			  clock : in STD_LOGIC;
			  done : out STD_LOGIC;
           P : out  STD_LOGIC_VECTOR (n+m-1 downto 0));
end moltiplicatore_booth;

architecture Structural of moltiplicatore_booth is

COMPONENT parte_controllo
 generic ( n : natural := 4;
					 m : natural := 4);
PORT(
		clock : in  STD_LOGIC;
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
END COMPONENT;
	
COMPONENT parte_operativa
 generic ( n : natural := 4;
					 m : natural := 4);
PORT(
				X : in  STD_LOGIC_VECTOR (n-1 downto 0);
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
END COMPONENT;

COMPONENT contatore_modulo_n
 generic (n : natural := 4);
 PORT ( clock : in  STD_LOGIC;
		  reset_n : in  STD_LOGIC;
		  count_en : in  STD_LOGIC;
		  up_down : in STD_LOGIC;
		  mod_n : out  STD_LOGIC);
END COMPONENT;

signal reset_n_sig, q0_sig, load_a_sig, load_q_sig, load_m_sig, q_1_sig, 
			shift_sig, sub_sig, cnt_en_sig, mod_n_sig, done_sig : std_logic := '0';
signal p_sig : std_logic_vector(n+m-1 downto 0);

signal sign : std_logic := '0';

begin

-- L'assegnazione condizionata viene utilizzata per risolvere il problema del segno dello zero (la prima)
-- e della moltiplicazione per il massimo numero rappresentabile con n bit quando questo è il moltiplicatore
-- (seconda riga: risolto complementando a 2 il risultato) es. 1*(-8),
sign <= '0' when (A = (A'range => '0')) or (B = (B'range => '0')) else
				 (A(n-1) xor B(m-1));
P <= ((not p_sig) + 1) and (p_sig'range => done_sig) when ((A(n-1) = '1') and (unsigned(A(n-2 downto 0)) = 0)) else
			(sign & p_sig(n+m-2 downto 0)) and (p_sig'range => done_sig);
done <= done_sig;

PC: parte_controllo 
	generic map(n,m)
	PORT MAP(
		clock => clock,
		reset_n_all => reset_n,
		q0 => q0_sig,
		q_1 => q_1_sig,
		enable => enable,
		conteggio => mod_n_sig,
		load_a => load_a_sig,
		load_m => load_m_sig,
		load_q => load_q_sig,
		reset_n => reset_n_sig,
		shift => shift_sig,
		sub => sub_sig,
		count_en => cnt_en_sig,
		done => done_sig
);
	
PO: parte_operativa
	generic map(n,m)
	PORT MAP(
		X => A,
		Y => B,
		sub => sub_sig,
		load_a => load_a_sig,
		load_q => load_q_sig,
		load_m => load_m_sig,
		reset_n => reset_n_sig,
		shift => shift_sig,
		clock => clock,
		q0 => q0_sig,
		q_1 => q_1_sig,
		P => p_sig
);

contatore: contatore_modulo_n
generic map(m) 
PORT MAP(
		clock => clock,
		reset_n => reset_n_sig,
		count_en => cnt_en_sig,
		up_down => '0',
		mod_n => mod_n_sig
	);

end Structural;
