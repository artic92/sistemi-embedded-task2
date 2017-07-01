----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12:14:52 06/26/2017
-- Design Name:
-- Module Name:    complex_abs - Structural
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
--! @file complex_abs.vhd
--! @author Antonio Riccio, Andrea Scognamiglio, Stefano Sorrentino
--! @brief Blocco che calcola il modulo di un numero complesso
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--! @brief Componente che calcola il modulo di un numero complesso
--! @note Il componente non applica la formula completa per il calcolo del modulo
--! 	ma trascura l'operazione di radice quadrata perchè non necessaria ai fini
--! 	dell'applicazione che utilizzerà questo componente.
entity complex_abs is
	 Generic ( complex_width : natural := 32 );	--! Parallelismo in bit del numero complesso (inteso come somma di parte reale e immaginaria)
    Port ( clock : in STD_LOGIC;							--! Segnale di temporizzazione
					 reset_n : in STD_LOGIC;						--! Segnale di reset 0-attivo
					 complex_value : in  STD_LOGIC_VECTOR (complex_width-1 downto 0); --! Numero complesso di cui calcolare il modulo
           abs_value : out  STD_LOGIC_VECTOR (complex_width-1 downto 0);	  --! Modulo del numero complesso
					 done : out STD_LOGIC);																						--! Segnale di terminazione delle operazioni
end complex_abs;

--! @brief Architettura del componente descritta nel dominio strutturale
--! @details L'archittettura fa uso di componenti riutilizzati in altre applicazioni
architecture Structural of complex_abs is

component moltiplicatore_booth
generic (
  n : natural := 4;
  m : natural := 4
);
port (
  A       : in  STD_LOGIC_VECTOR (n-1 downto 0);
  B       : in  STD_LOGIC_VECTOR (m-1 downto 0);
  enable  : in  STD_LOGIC;
  reset_n : in  STD_LOGIC;
  clock   : in  STD_LOGIC;
  done    : out STD_LOGIC;
  P       : out STD_LOGIC_VECTOR (n+m-1 downto 0)
);
end component moltiplicatore_booth;

component ripple_carry_adder
generic (
  n : natural := 4
);
port (
  A     : in  STD_LOGIC_VECTOR (n-1 downto 0);
  B     : in  STD_LOGIC_VECTOR (n-1 downto 0);
  c_in  : in  STD_LOGIC;
  c_out : out STD_LOGIC;
  ovfl  : out STD_LOGIC;
  S     : out STD_LOGIC_VECTOR (n-1 downto 0)
);
end component ripple_carry_adder;

component parte_controllo_complex_abs
port (
  clock       : in  STD_LOGIC;
  reset_n     : in  STD_LOGIC;
  done_mul    : in  STD_LOGIC;
	reset_n_all : out STD_LOGIC;
  enable_mul  : out STD_LOGIC;
	done 				: out STD_LOGIC
);
end component parte_controllo_complex_abs;

signal en_mul_sig, done_real_sig, done_imag_sig, done_mul_sig, reset_n_all_sig : std_logic;
signal power_real_sig, power_imag_sig, res_add_sig : std_logic_vector(complex_width-1 downto 0);

begin

done_mul_sig <= done_real_sig and done_imag_sig;

multiplier_real : moltiplicatore_booth
generic map (
  n => (complex_width)/2,
  m => (complex_width)/2
)
port map (
  A       => complex_value((complex_width/2)-1 downto 0),
  B       => complex_value((complex_width/2)-1 downto 0),
  enable  => en_mul_sig,
  reset_n => reset_n_all_sig,
  clock   => clock,
  done    => done_real_sig,
  P       => power_real_sig
);

multiplier_imag : moltiplicatore_booth
generic map (
  n => (complex_width)/2,
  m => (complex_width)/2
)
port map (
  A       => complex_value(complex_width-1 downto complex_width/2),
  B       => complex_value(complex_width-1 downto complex_width/2),
  enable  => en_mul_sig,
  reset_n => reset_n_all_sig,
  clock   => clock,
  done    => done_imag_sig,
  P       => power_imag_sig
);

mul_results_add : ripple_carry_adder
generic map (
  n => complex_width
)
port map (
  A     => power_real_sig,
  B     => power_imag_sig,
  c_in  => '0',
  c_out => open,
  ovfl  => open,
  S     => abs_value
);

control_unit : parte_controllo_complex_abs
port map (
  clock       => clock,
  reset_n     => reset_n,
  done_mul    => done_mul_sig,
	reset_n_all => reset_n_all_sig,
  enable_mul  => en_mul_sig,
	done 				=> done
);

end Structural;
