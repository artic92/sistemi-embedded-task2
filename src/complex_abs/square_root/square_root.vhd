----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:31:16 12/19/2015 
-- Design Name: 
-- Module Name:    square_root - Structural 
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

entity square_root is
	generic ( n : natural := 8 );
	Port( clock : in STD_LOGIC;
				reset_n : in STD_LOGIC;
				enable : in STD_LOGIC;
				D : in STD_LOGIC_VECTOR (n-1 downto 0);
				root : out STD_LOGIC_VECTOR ((n/2)-1 downto 0);
				done : out STD_LOGIC);
end square_root;

architecture Structural of square_root is

	COMPONENT parte_controllo_sqrt
	PORT(
		clock : IN std_logic;
		reset_n_all : IN std_logic;
		enable : IN std_logic;
		count_hit : IN std_logic;          
		load_qd : OUT std_logic;
		load_r : OUT std_logic;
		reset_n : OUT std_logic;
		shift : OUT std_logic;
		count_en : OUT std_logic;
		done : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT parte_operativa_sqrt
	generic ( n : natural := 8 );
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		D : IN std_logic_vector (n-1 downto 0);
		load_qd : IN std_logic;
		load_r : IN std_logic;
		shift : IN std_logic;
		count_en : IN std_logic;          
		mod_n : OUT std_logic;
		root : OUT std_logic_vector ((n/2)-1 downto 0)
		);
	END COMPONENT;
--	for all : parte_operativa use entity work.parte_operativa(Behavioral);
	for all : parte_operativa_sqrt use entity work.parte_operativa_sqrt(Structural);
	
	signal count_hit_sig, load_qd_sig, load_r_sig, reset_n_sig, shift_sig, count_en_sig, done_sig : std_logic := '0';
	signal root_sig : std_logic_vector ((n/2)-1 downto 0) := (others => '0');

begin

	root <= root_sig and (root_sig'range => done_sig);
	done <= done_sig;

	PC: parte_controllo_sqrt 
	PORT MAP(
		clock => clock,
		reset_n_all => reset_n,
		enable => enable,
		count_hit => count_hit_sig,
		load_qd => load_qd_sig,
		load_r => load_r_sig,
		reset_n => reset_n_sig,
		shift => shift_sig,
		count_en => count_en_sig,
		done => done_sig
	);

	PO: parte_operativa_sqrt 
	generic map(n)
	PORT MAP(
		clock => clock,
		reset_n => reset_n_sig,
		D => D,
		load_qd => load_qd_sig,
		load_r => load_r_sig,
		shift => shift_sig,
		count_en => count_en_sig,
		mod_n => count_hit_sig,
		root => root_sig
	);

end Structural;

