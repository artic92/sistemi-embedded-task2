----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.07.2017 16:26:02
-- Design Name:
-- Module Name: wrapper_compute_max - Structural
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
--! @file wrapper_compute_max.vhd
--! @author Antonio Riccio, Andrea Scognamiglio, Stefano Sorrentino
--! @brief Wrapper di @ref compute_max che fornisce funzioni di comunicazione
--! @anchor wrapper_compute_max
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--! @brief Wrapper per l'entità @ref compute_max
--! @details Questo componente arricchisce il modulo @ref compute_max con funzionalità
--!   di comunicazione. Queste funzionalità sono necessarie per il collegamento del
--!   blocco con altri componenti.
entity wrapper_compute_max is
    Generic ( sample_width : natural := 32; --! Parallelismo in bit del campione
          s : natural := 2;                 --! Numero di satelliti
          d : natural := 2;                 --! Numero di intervalli doppler
          c : natural := 3);                --! Numero di campioni per intervallo doppler
    Port ( clock : in STD_LOGIC;            --! Segnale di temporizzazione
           reset_n : in STD_LOGIC;          --! Segnale di reset 0-attivo
           valid_in : in STD_LOGIC;         --! Indica che il dato sulla linea di ingresso è valido
           ready_in : in STD_LOGIC;         --! Indica che il componente a valle è pronto ad accettare valori in ingresso
           sample_abs : in STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample : in STD_LOGIC_VECTOR (sample_width-1 downto 0);
           pos_campione : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);  --! Posizione del massimo nell'intervallo doppler
           pos_doppler : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);   --! Intervallo di frequenze doppler al quale appartiene il massimo
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0); --! Satellite associato al massimo
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);                         --! Modulo del massimo
           sample_max : out STD_LOGIC_VECTOR(sample_width-1 downto 0);                    --! Valore complesso del massimo
           valid_out : out STD_LOGIC;       --! Indica che il dato sulla linea di uscita è valido
           ready_out : out STD_LOGIC);      --! Indica che questo componente è pronto ad accettare valori in ingresso
end wrapper_compute_max;

--! @brief Architettura del componente descritta nel dominio strutturale
architecture Structural of wrapper_compute_max is

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

--! @brief Calcola il massimo per un insieme di s*d*c campioni\
--! @see compute_max
component compute_max is
generic (
  sample_width : natural := 32;
  s : natural := 2;
  d : natural := 2;
  c : natural := 3
);
port (
  clock : in  STD_LOGIC;
  reset_n : in  STD_LOGIC;
  enable : in STD_LOGIC;
  sample_abs : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);
  sample : in STD_LOGIC_VECTOR(sample_width-1 downto 0);
  pos_campione : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
  pos_doppler : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
  pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
  max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);
  sample_max : out STD_LOGIC_VECTOR(sample_width-1 downto 0);
  done : out STD_LOGIC
);
end component compute_max;

--! @brief Parte di controllo di questo blocco
component fsm_compute_max is
port (
  clock : in STD_LOGIC;
  reset_n : in STD_LOGIC;
  valid_in : in STD_LOGIC;
  ready_in : in STD_LOGIC;
  max_done : in STD_LOGIC;
  start : out STD_LOGIC;
  valid_out : out STD_LOGIC;
  ready_out : out STD_LOGIC;
  reset_n_all : out STD_LOGIC
);
end component fsm_compute_max;

-- for all : compute_max use entity work.compute_max(Behavioral);
for all : compute_max use entity work.compute_max(Structural_non_continous);

signal max_done, start, reset_n_all_sig : std_logic := '0';
signal max_sig : std_logic_vector(sample_width-1 downto 0) := (others => '0');
signal sample_max_sig : std_logic_vector(sample_width-1 downto 0) := (others => '0');
signal pos_campione_sig : std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0) := (others => '0');
signal pos_doppler_sig : std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0) := (others => '0');
signal pos_satellite_sig : std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0) := (others => '0');

begin

--! @brief Componente che calcola il massimo sui moduli dei campioni in ingresso
compute_max_inst: compute_max
generic map (
  sample_width => sample_width,
  s => s,
  d => d,
  c => c
)
port map (
  clock => clock,
  reset_n => reset_n_all_sig,
  enable => start,
  sample_abs => sample_abs,
  sample => sample,
  pos_campione => pos_campione_sig,
  pos_doppler => pos_doppler_sig,
  pos_satellite => pos_satellite_sig,
  max => max_sig,
  sample_max => sample_max_sig,
  done => max_done
);

--! @brief Automa a stati finiti per la gestione dei segnali di comunicazione
fsm_compute_max_inst: fsm_compute_max
port map (
  clock => clock,
  reset_n => reset_n,
  valid_in => valid_in,
  ready_in => ready_in,
  max_done => max_done,
  start => start,
  valid_out => valid_out,
  ready_out => ready_out,
  reset_n_all => reset_n_all_sig
);

--! @brief Memorizza il massimo (in valore assoluto) ottenuto dal blocco compute_max
--! @details Questo registro è necessario per memorizzare il risultato(max) di compute_max
--!   dato che il componente si resetta dopo che ha terminato l'elaborazione.
reg_max: register_n_bit
generic map (
  n => sample_width
)
port map (
  I => max_sig,
  clock => clock,
  load => max_done,
  reset_n => reset_n,
  O => max
);

--! @brief Memorizza il massimo campione ottenuto dal blocco compute_max
--! @details Questo registro è necessario per memorizzare il risultato(sample_max) di compute_max
--!   dato che il componente si resetta dopo che ha terminato l'elaborazione.
reg_sample_max: register_n_bit
generic map (
  n => sample_width
)
port map (
  I => sample_max_sig,
  clock => clock,
  load => max_done,
  reset_n => reset_n,
  O => sample_max
);

--! @brief Memorizza la pos_campione del risultato ottenuto dal blocco compute_max
--! @details Questo registro è necessario per memorizzare pos_campione di compute_max
--!   dato che il componente si resetta dopo che ha terminato l'elaborazione.
reg_pos_campione: register_n_bit
generic map (
  n => natural(ceil(log2(real(c))))
)
port map (
  I => pos_campione_sig,
  clock => clock,
  load => max_done,
  reset_n => reset_n,
  O => pos_campione
);

--! @brief Memorizza la pos_doppler del risultato ottenuto dal blocco compute_max
--! @details Questo registro è necessario per memorizzare pos_doppler di compute_max
--!   dato che il componente si resetta dopo che ha terminato l'elaborazione.
reg_pos_doppler: register_n_bit
generic map (
  n => natural(ceil(log2(real(d))))
)
port map (
  I => pos_doppler_sig,
  clock => clock,
  load => max_done,
  reset_n => reset_n,
  O => pos_doppler
);

--! @brief Memorizza la pos_satellite del risultato ottenuto dal blocco compute_max
--! @details Questo registro è necessario per memorizzare pos_satellite di compute_max
--!   dato che il componente si resetta dopo che ha terminato l'elaborazione.
reg_pos_satellite: register_n_bit
generic map (
  n => natural(ceil(log2(real(s))))
)
port map (
  I => pos_satellite_sig,
  clock => clock,
  load => max_done,
  reset_n => reset_n,
  O => pos_satellite
);

end Structural;
