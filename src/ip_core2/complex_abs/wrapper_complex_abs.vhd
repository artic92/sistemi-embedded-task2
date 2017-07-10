----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.07.2017 11:22:27
-- Design Name:
-- Module Name: wrapper_complex_abs - Structural
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
--! @file wrapper_complex_abs.vhd
--! @author Antonio Riccio, Andrea Scognamiglio, Stefano Sorrentino
--! @brief Wrapper di @ref complex_abs che fornisce funzioni di comunicazione
--! @anchor wrapper_complex_abs
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--! @brief Wrapper per l'entità @ref complex_abs
--! @details Questo componente arricchisce il modulo @ref complex_abs con funzionalità
--!   di comunicazione. Queste funzionalità sono necessarie per collegare in cascata questo
--!   blocco con quello di calcolo del massimo.
entity wrapper_complex_abs is
    Generic ( complex_width : natural := 32 ); --! Parallelismo in bit del numero complesso (inteso come somma di parte reale e immaginaria)
    Port ( clock : in STD_LOGIC;               --! Segnale di temporizzazione
           reset_n : in STD_LOGIC;             --! Segnale di reset 0-attivo
           valid_in : in STD_LOGIC;            --! Indica che il dato sulla linea di ingresso è valido
           ready_in : in STD_LOGIC;            --! Indica che il componente a valle è pronto ad accettare valori in ingresso
           complex_value : in STD_LOGIC_VECTOR (complex_width-1 downto 0);     --! Numero complesso di cui calcolare il modulo
           complex_value_out : out STD_LOGIC_VECTOR(complex_width-1 downto 0); --! Valore registrato del numero complesso di cui calcolare il modulo
           abs_value : out STD_LOGIC_VECTOR (complex_width-1 downto 0);        --! Modulo del numero complesso
           valid_out : out STD_LOGIC;          --! Indica che il dato sulla linea di uscita è valido
           ready_out : out STD_LOGIC);         --! Indica che questo componente è pronto ad accettare valori in ingresso
end wrapper_complex_abs;

--! @brief Architettura del componente descritta nel dominio strutturale
--! @details L'archittettura utilizza due registri necessari a memorizzare il valore
--!   complesso ed il suo modulo. Questo consente di svincolare il funzionamento del
--!   calcolo del modulo dalla comunicazione del risultato ai componenti a valle.
architecture Structural of wrapper_complex_abs is

--! @brief Registro a parallelismo generico che opera sul fronte di salita del clock
component register_n_bit is
generic (
  n : natural := 8
);
port (
  I : in  STD_LOGIC_VECTOR (n-1 downto 0);
  clock : in  STD_LOGIC;
  load : in  STD_LOGIC;
  reset_n : in  STD_LOGIC;
  O : out  STD_LOGIC_VECTOR (n-1 downto 0)
);
end component register_n_bit;

--! @brief Calcola il modulo di un numero complesso
--! @see complex_abs
component complex_abs is
generic (
  complex_width : natural := 32
);
port (
  clock : in STD_LOGIC;
  reset_n : in STD_LOGIC;
  enable : in STD_LOGIC;
  complex_value : in  STD_LOGIC_VECTOR (complex_width-1 downto 0);
  abs_value : out  STD_LOGIC_VECTOR (complex_width-1 downto 0);
  done : out STD_LOGIC
);
end component complex_abs;

--! @brief Parte di controllo di questo blocco
component fsm_complex_abs is
port (
  clk : in STD_LOGIC;
  reset_n : in STD_LOGIC;
  valid_in : in STD_LOGIC;
  ready_in : in STD_LOGIC;
  abs_done : in STD_LOGIC;
  valid_out : out STD_LOGIC;
  ready_out : out STD_LOGIC);
end component;

signal done_sig : std_logic := '0';
signal reset_abs_n : std_logic := '0';
signal ready_out_sig : std_logic := '0';
signal abs_value_sig : std_logic_vector(complex_width-1 downto 0) := (others => '0');
signal complex_value_out_sig : std_logic_vector(complex_width-1 downto 0) := (others => '0');

begin

--! @brief Componente che calcola il modulo del valore complesso in ingresso
complex_abs_inst : complex_abs
generic map (
  complex_width => complex_width
)
port map (
  clock => clock,
  reset_n => reset_n,
  enable => valid_in,
  complex_value => complex_value_out_sig,
  abs_value => abs_value_sig,
  done => done_sig
);

--! @brief Automa a stati finiti per la gestione dei segnali di comunicazione
fsm_complex_abs_inst : fsm_complex_abs
port map (
  clk => clock,
  reset_n => reset_n,
  valid_in => valid_in,
  ready_in => ready_in,
  abs_done => done_sig,
  valid_out => valid_out,
  ready_out => ready_out_sig
);

--! @brief Memorizza il modulo del numero complesso in ingresso
--! @details Questo registro è necessario per memorizzare il risultato di complex_abs
--!   dato che il componente si resetta dopo che ha terminato l'elaborazione.
reg_abs_value: register_n_bit
generic map (
  n => complex_width
)
port map (
  I => abs_value_sig,
  clock => clock,
  load => done_sig,
  reset_n => reset_n,
  O => abs_value
);

--! @brief Memorizza il numero complesso in ingresso
--! @details Questo registro è necessario per conservare l'associazione tra valore
--!   complesso in ingresso e modulo appena calcolato.
reg_complex_value_out : register_n_bit
generic map (
  n => complex_width
)
port map (
  I => complex_value,
  clock => clock,
  load => ready_out_sig,
  reset_n => reset_n,
  O => complex_value_out_sig
);

ready_out <= ready_out_sig;
complex_value_out <= complex_value_out_sig;

end Structural;
