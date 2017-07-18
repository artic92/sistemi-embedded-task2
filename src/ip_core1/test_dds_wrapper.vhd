--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
--Date        : Mon Jul 10 15:30:57 2017
--Host        : sistemiEmbedded running 64-bit Ubuntu 16.10
--Command     : generate_target test_dds_wrapper.bd
--Design      : test_dds_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
--! @file test_dds_wrapper.vhd
--! @author Antonio Riccio, Andrea Scognamiglio, Stefano Sorrentino
--! @brief Entità top-level
--! @example tb_wrapper_dds.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

--! @brief Componente top-level
--! @details Il componente genera campioni di un segnale periodico la cui frequenza
--!   e fase possono essere configurate dinamicamente.
--!
--!   Gli incrementi di fase e di frequenza sono dei valori espressi su 24 bit e
--!   sono concatenati nel segnale poff_pinc con poff che occupa i primi 24 bit e pinc
--!   che occupa gli ultimi 24 bit.
--!
--!   Il segnale di uscita è un valore complesso che ha la
--!   parte immaginaria nella metà più significativa e la parte reale nella metà meno significativa.
--!
--!   Il componente inizia a generare il numero richiesto di campioni ogni volta che
--!   il segnale valid_in è alto. Il segnale done viene asserito ogni volta
--!   che termina la generazione dei campioni, in tal caso il blocco si mette in attesa che valid_in sia nuovamente alto
--!   per poter generare altri campioni.
entity test_dds_wrapper is
  generic (
    campioni : natural := 20460 );                    --! Numero di campioni da generare
  port (
    clock : in STD_LOGIC;                             --! Segnale di temporizzazione
    reset_n : in STD_LOGIC;                           --! Segnale di reset 0-attivo
    poff_pinc : in STD_LOGIC_VECTOR(47 downto 0);     --! Spiazzamenti di fase e di frequenza (poff + pinc)
    valid_in : in STD_LOGIC;                          --! Indica che il dato sulla linea di ingresso è valido
    ready_in : in STD_LOGIC;                          --! Indica che il componente a valle è pronto ad accettare valori in ingresso
    valid_out : out STD_LOGIC;                        --! Indica che il dato sulla linea di uscita è valido
    ready_out : out STD_LOGIC;                        --! Indica che questo componente è pronto ad accettare valori in ingresso
    sine_cosine : out STD_LOGIC_VECTOR(31 downto 0);  --! Campioni complessi del segnale periodico (immaginaria + reale)
    done : out STD_LOGIC                              --! Segnale di terminazione delle operazioni
  );
end test_dds_wrapper;

--! @brief Architettura top-level descritta nel dominio strutturale
--! @details Il componente fa uso del blocco DDS_compiler della Xilinx per generare
--!   campioni di un segnale periodico con una fase ed una frequenza configurabili.
architecture STRUCTURE of test_dds_wrapper is

  --! @brief Blocco che genera i campioni del segnale periodico
  component test_dds is
  port (
    ready_out : out STD_LOGIC;
    valid_in : in STD_LOGIC;
    clock : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    sine_cosine : out STD_LOGIC_VECTOR(31 downto 0);
    ready_in : in STD_LOGIC;
    valid_out : out STD_LOGIC;
    poff_pinc : in STD_LOGIC_VECTOR(47 downto 0)
  );
  end component test_dds;

  --! @brief Registro a parallelismo generico che opera sul fronte di salita del clock
  component register_n_bit is
  generic (
    n : natural := 8
  );
  port (
    I : in  STD_LOGIC_VECTOR(n-1 downto 0);
    clock : in  STD_LOGIC;
    load : in  STD_LOGIC;
    reset_n : in  STD_LOGIC;
    O : out  STD_LOGIC_VECTOR(n-1 downto 0)
  );
  end component register_n_bit;

  --! @brief Contatore modulo-n di tipo up-down con caricamento del valore di conteggio e
  --!   segnali di uscita indicanti valore e fine del conteggio
  component counter_modulo_n
  generic (
    n : natural := 16
  );
  port (
    clock          : in  STD_LOGIC;
    count_en       : in  STD_LOGIC;
    reset_n        : in  STD_LOGIC;
    up_down        : in  STD_LOGIC;
    load_conteggio : in  STD_LOGIC;
    conteggio_in   : in  STD_LOGIC_VECTOR(natural(ceil(log2(real(n))))-1 downto 0);
    conteggio_out  : out STD_LOGIC_VECTOR((natural(ceil(log2(real(n)))))-1 downto 0);
    count_hit      : out STD_LOGIC
  );
  end component counter_modulo_n;

  --! @brief Parte di controllo del blocco
  component fsm_dds_wrapper
  port (
    clock        : in  STD_LOGIC;
    reset_n      : in  STD_LOGIC;
    valid_in     : in  STD_LOGIC;
    count_hit    : in  STD_LOGIC;
    valid_in_out : out STD_LOGIC;
    reset_n_all  : out STD_LOGIC;
    done         : out STD_LOGIC
  );
  end component fsm_dds_wrapper;

  signal sine_cosine_sig : std_logic_vector(31 downto 0);
  signal reset_n_all, counter_enable_sig, count_hit_sig, valid_out_sig, valid_in_sig, load_complex_value_reg : std_logic;

begin

valid_out <= valid_out_sig;
load_complex_value_reg <= counter_enable_sig and reset_n_all;

-- Il contatore si incrementa solo quando si è sicuri che il blocco a valle abbia
-- prelevato il dato in uscita. Questa situazione accade quando il blocco DDS ha
-- generato un'uscita valida ed il blocco a valle è pronto a ricevere il dato (asserendo ready_in).
counter_enable_sig <= valid_out_sig and ready_in;

--! @brief Il DDS genera dei campioni complessi campionati ad una frequenza di 20.46 Mhz
test_dds_i : component test_dds
port map (
  clock => clock,
  poff_pinc(47 downto 0) => poff_pinc(47 downto 0),
  ready_in => ready_in,
  ready_out => ready_out,
  reset_n => reset_n_all,
  sine_cosine(31 downto 0) => sine_cosine_sig(31 downto 0),
  valid_in => valid_in_sig,
  valid_out => valid_out_sig
);

--! @brief Il registro memorizza il valore complesso generato dal DDS
reg_complex_value_out : register_n_bit
generic map (
  n => 32
)
port map (
  I => sine_cosine_sig,
  clock => clock,
  load => load_complex_value_reg,
  reset_n => reset_n,
  O => sine_cosine
);

--! @brief Contatore che controlla il numero di campioni da generare
--! @details Una volta raggiunto il massimo conteggio, il contatore asserisce un segnale
--!   (count_hit) che porta l'entità top-level a portarsi in uno stato di reset
counter_campioni : counter_modulo_n
generic map (
  n => campioni
)
port map (
  clock          => clock,
  count_en       => counter_enable_sig,
  reset_n        => reset_n_all,
  up_down        => '0',
  load_conteggio => '0',
  conteggio_in   => (others => '0'),
  conteggio_out  => open,
  count_hit      => count_hit_sig
);

--! @brief Automa a stati finiti per la gestione dei segnali di controllo del DDS.
--! @details Attende la terminazione del conteggio e resetta il DDS_compiler.
--!   Questo componente è necessario per gestire opportunamente il segnale
--!   di reset del blocco DDS, il quale deve mantenersi basso per almeno due periodi di clock.
fsm_dds_wrapper_i : fsm_dds_wrapper
port map (
  clock       => clock,
  reset_n     => reset_n,
  valid_in    => valid_in,
  count_hit   => count_hit_sig,
  valid_in_out => valid_in_sig,
  reset_n_all => reset_n_all,
  done        => done
);

end STRUCTURE;
