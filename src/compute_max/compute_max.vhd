----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    11:23:18 06/28/2017
-- Design Name:
-- Module Name:    compute_max - Behavioral
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
--! @brief Blocco che calcola il massimo in un insieme di campioni
--! @anchor compute_max
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--! @brief Componente che calcola il massimo in un insieme di campioni di dimensione s*d*c
--! @details Il componente calcola il massimo di un insieme di campioni espressi
--!   mediante il loro modulo
entity compute_max is
    Generic ( sample_width : natural := 32; --! Parallelismo in bit  del campione
              s : natural := 2;             --! Numero di satelliti
              d : natural := 2;             --! Numero di intervalli doppler
              c : natural := 3);            --! Numero di campioni per intervallo doppler
    Port ( clock : in  STD_LOGIC;           --! Segnale di temporizzazione
           reset_n : in  STD_LOGIC;         --! Segnale di reset 0-attivo
           sample_abs : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);                   --! Modulo del campione
           sample : in STD_LOGIC_VECTOR(sample_width-1 downto 0);                         --! Valore complesso del campione associato al modulo
           pos_campione : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);  --! Posizione del massimo nell'intervallo doppler
           pos_doppler : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);   --! Intervallo di frequenze doppler al quale appartiene il massimo
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0); --! Satellite associato al massimo
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);                         --! Modulo del massimo
           sample_max : out STD_LOGIC_VECTOR(sample_width-1 downto 0);                    --! Valore complesso del massimo
           done : out STD_LOGIC);                                                         --! Segnale di terminazione delle operazioni
end compute_max;

--! @brief Architettura del componente descritta nel dominio comportamentale
--! @details L'architettura è stata specificata in fase di prototipazione del componente
--!   per verificarne la correttezza funzionale.
--!   E' caratterizzata da due processi: uno che elabora il valore dei conteggi e l'altro
--!   che effettua i confronti necessari al calcolo del massimo.
--!   Per approfondimenti riguardanti le singole fasi dell'algoritmo si rimanda al
--!   codice sorgente
architecture Behavioral of compute_max is

--! Contatore dei campioni di un intervallo doppler
signal cont_campioni : std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0) := (others => '0');
--! Registro che memorizza la posizione, nell'intervallo doppler, del massimo
signal posizione_campione : std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0) := (others => '0');
--! Contatore degli intervalli di frequenze doppler
signal cont_doppler : std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0) := (others => '0');
--! Registro che memorizza l'intervallo di frequenze doppler al quale appartiene il massimo
signal posizione_doppler : std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0) := (others => '0');
--! Contatore dei satelliti
signal cont_satelliti : std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0) := (others => '0');
--! Registro che memorizza il satellite associato al massimo
signal posizione_satellite : std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0) := (others => '0');

signal max_satellite, sample_sig : std_logic_vector(sample_width-1 downto 0);

begin

--! @brief Processo che elabora i contatori
--! @details Il processo resetta i contatori opportunamente in base alla posizione del campione attuale
compute_counters : process(clock, reset_n, sample_abs, cont_campioni, cont_doppler, cont_satelliti)
begin

  if(reset_n = '0') then

    cont_campioni <= (others => '0');
    cont_doppler <= (others => '0');
    cont_satelliti <= (others => '0');
    done <= '0';

    elsif (rising_edge(clock)) then

    -- Se il campione appena arrivato appartiene allo stesso intervallo di frequenze
    -- doppler del campione precedente
    -- ovvero il campione è INTERNO ad un intervallo doppler ma non è il primo dell'intervallo
    if(cont_campioni < c) then

      -- Incrementa il contatore dei campioni per quella frequenza doppler
      cont_campioni <= cont_campioni + 1;

    else -- Il campione appena arrivato è il PRIMO di un intervallo di frequenze

        -- Resetta il contatore dei campioni
        cont_campioni <= (0 => '1', others => '0');

        -- Segnala l'inizio dell'analisi di un nuovo intervallo di frequenze
        -- incrementando il contatore delle frequenze doppler
        cont_doppler <= cont_doppler + 1;

        -- Se ho finito le frequenze doppler per questo satellite
        -- ovvero il campione è l'ULTIMO campione del satellite
        if(cont_doppler >= d-1) then

          -- Resetta il contatore degli intervalli doppler
          cont_doppler <= (others => '0');

          -- Segnala la terminazione dell'analisi del satellite
          -- incrementandone il relativo contatore
          cont_satelliti <= cont_satelliti + 1;

          -- Se ho finito di analizzare tutti i satelliti l'algoritmo termina
          -- ovvero viene asserito il segnale done
          if(cont_satelliti >= s-1) then
            done <= '1';
            end if;
		      end if;
      end if;
    end if;
end process;

--! @brief Processo che elabora il massimo
--! @details Il processo memorizza il valore ed il modulo del massimo e ne aggiorna
--!   opportunamente le coordinate in base alla posizione nell'insime di campioni
compute_maximum : process(clock, reset_n, sample_abs, cont_campioni, cont_doppler, cont_satelliti, posizione_campione, posizione_doppler, posizione_satellite, max_satellite, sample)
begin

  if(reset_n = '0') then

    posizione_campione <= (others => '0');
    posizione_doppler <= (others => '0');
    posizione_satellite <= (others => '0');
    sample_sig <= (others => '0');
    max_satellite <= (others => '0');

    elsif (rising_edge(clock)) then

      -- Confronta il campione appena arrivato con l'attuale max_satellite (valore massimo)
      if(sample_abs > max_satellite) then

        -- Se il sample_abs è maggiore di max_satellite allora quest'ulitmo viene aggiornato
        -- sia nell'informazione riguardante il modulo che nel valore complesso
        max_satellite <= sample_abs;
        sample_sig <= sample;

        -- Vengono aggiornate anche le posizioni del massimo
        -- Se il campione appena arrivato appartiene allo stesso intervallo di frequenze
        -- doppler del campione precedente
        -- ovvero il campione è INTERNO ad un intervallo doppler ma non è il primo dell'intervallo
        if(cont_campioni < c) then

          posizione_campione <= cont_campioni;
          posizione_doppler <= cont_doppler;
          posizione_satellite <= cont_satelliti;

        else -- Il campione appena arrivato è il PRIMO di un intervallo di frequenze

            posizione_campione <= (others => '0');

            -- Se il campione è l'ULTIMO campione del satellite
            if(cont_doppler >= d-1) then

                posizione_doppler <= (others => '0');
                posizione_satellite <= cont_satelliti + 1;

              else -- Il campione è il primo di un intervallo di frequenze doppler
                   -- ma NON è il primo campione di un nuovo satellite

                posizione_doppler <= cont_doppler + 1;
                posizione_satellite <= cont_satelliti;
              end if;
          end if;
        end if;
    end if;

    pos_campione <= posizione_campione;
    pos_doppler <= posizione_doppler;
    pos_satellite <= posizione_satellite;
    sample_max <= sample_sig;

    max <= max_satellite;
end process;

end Behavioral;

--! @brief Architettura del componente descritta nel dominio strutturale
--! @details L'architettura fa uso di componenti già sviluppati in precedenza
architecture Structural of compute_max is

--! @brief Registro a parallelismo generico che opera sul fronte di salita del clock
component register_n_bit
generic (
  n     : natural := 8
);
port (
  I       : in  STD_LOGIC_VECTOR (n-1 downto 0);
  clock   : in  STD_LOGIC;
  load    : in  STD_LOGIC;
  reset_n : in  STD_LOGIC;
  O       : out STD_LOGIC_VECTOR (n-1 downto 0)
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
  conteggio_in   : in  STD_LOGIC_VECTOR (natural(ceil(log2(real(n))))-1 downto 0);
  conteggio_out  : out STD_LOGIC_VECTOR ((natural(ceil(log2(real(n)))))-1 downto 0);
  count_hit      : out STD_LOGIC
);
end component counter_modulo_n;

--! @brief Comparatore a parallelismo generico che verifica la relazione di maggioranza tra i due input
component comparatore
generic (
  width : natural := 31
);
port (
  A        : in  STD_LOGIC_VECTOR (31 downto 0);
  B        : in  STD_LOGIC_VECTOR (31 downto 0);
  AbiggerB : out STD_LOGIC
);
end component comparatore;

--! @brief Automa a stati per la generazione di un segnale impulsivo a partire da uno a livelli
component livelli2impulsi
port (
  input  : in  STD_LOGIC;
  clock  : in  STD_LOGIC;
  output : out STD_LOGIC
);
end component livelli2impulsi;

--! @brief Flip-flop D con reset 0-attivo asincrono
component d_edge_triggered
port (
  data_in  : in  STD_LOGIC;
  reset_n  : in  STD_LOGIC;
  clock    : in  STD_LOGIC;
  data_out : out STD_LOGIC
);
end component d_edge_triggered;

--! Segnale di uscita del contatore dei campioni (collegato alla linea dato del registro che memorizza la posizione del campione massimo)
signal contatore_campione_out : STD_LOGIC_VECTOR (natural(ceil(log2(real(c))))-1 downto 0);
--! Segnale di uscita del contatore degli intervalli doppler (collegato alla linea dato del registro che memorizza la doppler associata al massimo)
signal contatore_doppler_out : STD_LOGIC_VECTOR (natural(ceil(log2(real(d))))-1 downto 0);
--! Segnale di uscita del contatore dei satelliti (collegato alla linea dato del registro che memorizza il satellite associato al massimo)
signal contatore_satellite_out : STD_LOGIC_VECTOR (natural(ceil(log2(real(s))))-1 downto 0);

signal max_sig, sample_abs_sig, sample_sig : STD_LOGIC_VECTOR(sample_width-1 downto 0);
signal comparatore_out, enable_count_campioni, enable_count_doppler, enable_count_satellite_livelli, enable_count_satellite_impulsi, load_register_doppler_delayed, load_register_satellite_delayed, load_register_satellite_delayed2 : STD_LOGIC;

begin

enable_count_campioni <= reset_n;
max <= max_sig;

--! Contatore dei campioni di un intervallo doppler
counter_campioni : counter_modulo_n
generic map (
  n => c
)
port map (
  clock          => clock,
  count_en       => enable_count_campioni,
  reset_n        => reset_n,
  up_down        => '0',
  load_conteggio => '0',
  conteggio_in   => (others => '0'),
  conteggio_out  => contatore_campione_out,
  count_hit      => enable_count_doppler
);

--! Registro che memorizza la posizione del massimo nell'intervallo doppler
register_campione : register_n_bit
generic map (
  n     => natural(ceil(log2(real(c))))
)
port map (
  I       => contatore_campione_out,
  clock   => clock,
  load    => comparatore_out,
  reset_n => reset_n,
  O       => pos_campione
);

--! @brief Ritardo imposto al segnale di caricamento del registro doppler
--! @details Questo flip-flop è necessario per consentire il caricamento del valore corretto
--!    di conteggio nel registro doppler solo dopo che il contatore abbia commutato la
--!    propria uscita (problema che si pone in corrispondenza del primo campione di
--!    una nuova frame)
ff_load_doppler : d_edge_triggered
port map (
  data_in  => comparatore_out,
  reset_n  => reset_n,
  clock    => clock,
  data_out => load_register_doppler_delayed
);

--! Contatore delle frequenze doppler relative ad un satellite
counter_doppler : counter_modulo_n
generic map (
  n => d
)
port map (
  clock          => clock,
  count_en       => enable_count_doppler,
  reset_n        => reset_n,
  up_down        => '0',
  load_conteggio => '0',
  conteggio_in   => (others => '0'),
  conteggio_out  => contatore_doppler_out,
  count_hit      => enable_count_satellite_livelli
);

--! Registro che memorizza l'intervallo di frequenza doppler associato al campione massimo
register_doppler : register_n_bit
generic map (
 n     => natural(ceil(log2(real(d))))
)
port map (
  I       => contatore_doppler_out,
  clock   => clock,
  load    => load_register_doppler_delayed,
  reset_n => reset_n,
  O       => pos_doppler
);

--! @brief Automa a stati per la gestione del segnale di count_hit
--! @details Questo automa è necessario per convertire il segnale di count_hit del contatore doppler
--!   in un segnale impulsivo che va ad abilitare il contatore dei satelliti per un solo conteggio. Senza questo
--!   componente il contatore dei satelliti sarebbe abilitato a contare per più di un valore.
enable_count_satellite_impulsivo : livelli2impulsi
port map (
  input  => enable_count_satellite_livelli,
  clock  => clock,
  output => enable_count_satellite_impulsi
);

--! Contatore dei satelliti
counter_satelliti : counter_modulo_n
generic map (
  n => s
)
port map (
  clock          => clock,
  count_en       => enable_count_satellite_impulsi,
  reset_n        => reset_n,
  up_down        => '0',
  load_conteggio => '0',
  conteggio_in   => (others => '0'),
  conteggio_out  => contatore_satellite_out,
  count_hit      => done
);

--! @brief Ritardo imposto al segnale di caricamento del registro satellite
--! @details Questo flip-flop è necessario per consentire il caricamento del valore corretto
--!    di conteggio nel registro satellite solo dopo che il contatore abbia commutato la
--!    propria uscita (problema che si pone in corrispondenza dell'ultimo campione di
--!    un satellite)
ff_load_satellite : d_edge_triggered
port map (
  data_in  => load_register_doppler_delayed,
  reset_n  => reset_n,
  clock    => clock,
  data_out => load_register_satellite_delayed
);

--! @brief Secondo ritardo imposto al segnale di caricamento del registro satellite
--! @details Questo secondo ritardo tiene in conto anche dell'ulteriore ritardo inposto
--!   contatore delle doppler
ff_load_satellite2 : d_edge_triggered
port map (
  data_in  => load_register_satellite_delayed,
  reset_n  => reset_n,
  clock    => clock,
  data_out => load_register_satellite_delayed2
);

--! Registro che memorizza il satellite associato al campione massimo
register_satellite : register_n_bit
generic map (
  n     => natural(ceil(log2(real(s))))
)
port map (
  I       => contatore_satellite_out,
  clock   => clock,
  load    => load_register_satellite_delayed2,
  reset_n => reset_n,
  O       => pos_satellite
);

--! Ritardo che consente la memorizzazione corretta del modulo del campione massimo
register_sample_abs : register_n_bit
generic map (
  n     => sample_width
)
port map (
  I       => sample_abs,
  clock   => clock,
  load    => reset_n,
  reset_n => reset_n,
  O       => sample_abs_sig
);

--! Registro che memorizza il modulo associato al campione massimo
register_max : register_n_bit
generic map (
  n     => sample_width
)
port map (
  I       => sample_abs_sig,
  clock   => clock,
  load    => comparatore_out,
  reset_n => reset_n,
  O       => max_sig
);

--! Ritardo che consente la memorizzazione corretta del campione massimo
register_sample : register_n_bit
generic map (
  n     => sample_width
)
port map (
  I       => sample,
  clock   => clock,
  load    => reset_n,
  reset_n => reset_n,
  O       => sample_sig
);

--! Registro che memorizza il valore complesso associato al campione massimo
register_sample_max : register_n_bit
generic map (
  n     => sample_width
)
port map (
  I       => sample_sig,
  clock   => clock,
  load    => comparatore_out,
  reset_n => reset_n,
  O       => sample_max
);

--! Comparatore necessario a comparare il campione in ingresso con il massimo
comparatore : comparatore
generic map (
  width => sample_width
)
port map (
  A        => sample_abs,
  B        => max_sig,
  AbiggerB => comparatore_out
);

end Structural;
