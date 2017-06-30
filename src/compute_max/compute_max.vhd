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

entity compute_max is
    Generic ( sample_width : natural := 32;
              s : natural := 2;   -- Numero di satelliti
              d : natural := 2;   -- Numero di intervalli doppler
              c : natural := 3);  -- Numero di campioni per intervallo doppler
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sample_abs : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample : in STD_LOGIC_VECTOR( sample_width-1 downto 0);
           pos_campione : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
           pos_doppler : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample_max : out STD_LOGIC_VECTOR(sample_width-1 downto 0);
           done : out STD_LOGIC);
end compute_max;

architecture Behavioral of compute_max is

signal cont_campioni, posizione_campione : std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0) := (others => '0');
signal cont_doppler, posizione_doppler : std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0) := (others => '0');
signal cont_satelliti, posizione_satellite : std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0) := (others => '0');
signal max_satellite, sample_sig : std_logic_vector(sample_width-1 downto 0);

begin

compute_cont : process(clock, reset_n, sample_abs, cont_campioni, cont_doppler, cont_satelliti)
begin

  if(reset_n = '0') then

    cont_campioni <= (others => '0');
    cont_doppler <= (others => '0');
    cont_satelliti <= (others => '0');
    done <= '0';

    elsif (rising_edge(clock)) then

    -- Se il campione appena arrivato appartiene allo stesso intervallo di frequenze
    -- doppler del campione precedente
    -- ovvero il campione è INTERNO ad un intervallo
    if(cont_campioni < c) then

      -- Incrementa il contatore dei campioni per quella frequenza doppler
      cont_campioni <= cont_campioni + 1;

      else -- il campione appena arrivato è il PRIMO di un nuovo intervallo di frequenze

        -- Resetta il contatore dei campioni
        cont_campioni <= (0 => '1', others => '0');

        -- Segnala l'inizio dell'analisi di un nuovo intervallo di frequenze doppler
        cont_doppler <= cont_doppler + 1;

        -- Se ho finito le frequenze doppler per questo satellite
        -- ovvero il campione è l'ultimo campione del satellite
        if(cont_doppler >= d-1) then

          -- Resetta il contatore degli intervalli doppler
          cont_doppler <= (others => '0');

          -- Segnala la terminazione dell'analisi del satellite
          cont_satelliti <= cont_satelliti + 1;

          -- Se ho finito di analizzare tutti i satelliti l'algoritmo termina
          if(cont_satelliti >= s-1) then
            done <= '1';
            end if;
		      end if;
      end if;
    end if;
end process;

compute_max : process(clock, reset_n, sample_abs, cont_campioni, cont_doppler, cont_satelliti, posizione_campione, posizione_doppler, posizione_satellite, max_satellite, sample)
begin

  if(reset_n = '0') then

    posizione_campione <= (others => '0');
    posizione_doppler <= (others => '0');
    posizione_satellite <= (others => '0');
    sample_sig <= (others => '0');
    max_satellite <= (others => '0');

    elsif (rising_edge(clock)) then

      -- Confronta il campione appena arrivato con l'attuale max_satellite (massimo assoluto)
      if(sample_abs > max_satellite) then

        -- Se il sample_abs è maggiore di max_satellite allora quest'ulitmo viene aggiornato
        max_satellite <= sample_abs;
        sample_sig <= sample;

        -- Se il campione NON è il primo di un intervallo di frequenze doppler
        -- e se il campione è INTERNO oppure è il primo campione in assoluto
        if(cont_campioni < c) then

          -- Aggiorna la posizione del campione massimo opportunamente
          posizione_campione <= cont_campioni;
          posizione_doppler <= cont_doppler;
          posizione_satellite <= cont_satelliti;

          else -- Il campione è il primo di un intervallo di frequenze doppler

            posizione_campione <= (others => '0');

            -- Se il campione è il primo di un intervallo di frequenze doppler
            -- ed è il primo campione di un nuovo satellite
            if(cont_doppler >= d-1) then

                -- Aggiorna la posizione del campione massimo opportunamente
                posizione_doppler <= (others => '0');
                posizione_satellite <= cont_satelliti + 1;

              else -- Il campione è il primo di un intervallo di frequenze doppler
                   -- ma NON è il primo campione di un nuovo satellite

                -- Aggiorna la posizione del campione massimo opportunamente
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

architecture Structural of compute_max is

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

component livelli2impulsi
port (
  input  : in  STD_LOGIC;
  clock  : in  STD_LOGIC;
  output : out STD_LOGIC
);
end component livelli2impulsi;

signal contatore_campione_out : STD_LOGIC_VECTOR (natural(ceil(log2(real(c))))-1 downto 0);
signal contatore_doppler_out : STD_LOGIC_VECTOR (natural(ceil(log2(real(d))))-1 downto 0);
signal contatore_satellite_out : STD_LOGIC_VECTOR (natural(ceil(log2(real(s))))-1 downto 0);
signal max_sig : STD_LOGIC_VECTOR(sample_width-1 downto 0);
signal comparatore_out, enable_count_satellite_livelli, enable_count_satellite_impulsi, enable_cont_campioni, enable_count_doppler, load_register_doppler_delayed, load_register_satellite_delayed, load_register_satellite_delayed2 : STD_LOGIC;

begin

enable_cont_campioni <= reset_n;
max <= max_sig;

register_campione : register_n_bit
generic map (
  n     => natural(ceil(log2(real(c))))
)
port map (
  I       => contatore_campione_out,
  clock   => not clock,
  load    => comparatore_out,
  reset_n => reset_n,
  O       => pos_campione
);


ff_load_doppler : process(clock, reset_n)
begin
  if(reset_n = '0') then
       load_register_doppler_delayed <= '0';
    else if (falling_edge(clock)) then
       load_register_doppler_delayed <= comparatore_out;
      end if;
    end if;
end process;

ff_load_satellite : process(clock, reset_n)
begin
  if(reset_n = '0') then
       load_register_satellite_delayed <= '0';
    else if (falling_edge(clock)) then
       load_register_satellite_delayed <= load_register_doppler_delayed;
      end if;
    end if;
end process;

ff_load_satellite2 : process(clock, reset_n)
begin
  if(reset_n = '0') then
       load_register_satellite_delayed2 <= '0';
    else if (rising_edge(clock)) then
       load_register_satellite_delayed2 <= load_register_satellite_delayed;
      end if;
    end if;
end process;

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

register_satellite : register_n_bit
generic map (
 n     => natural(ceil(log2(real(s))))
)
port map (
  I       => contatore_satellite_out,
  clock   => not clock,
  load    => load_register_satellite_delayed2,
  reset_n => reset_n,
  O       => pos_satellite
);

register_max : register_n_bit
generic map (
  n     => sample_width
)
port map (
  I       => sample_abs,
  clock   => not clock,
  load    => comparatore_out,
  reset_n => reset_n,
  O       => max_sig
);

register_sample : register_n_bit
generic map (
  n     => sample_width
)
port map (
  I       => sample,
  clock   => clock,
  load    => comparatore_out,
  reset_n => reset_n,
  O       => sample_max
);

counter_campioni : counter_modulo_n
generic map (
  n => c
)
port map (
  clock          => clock,
  count_en       => enable_cont_campioni,
  reset_n        => reset_n,
  up_down        => '0',
  load_conteggio => '0',
  conteggio_in   => (others => '0'),
  conteggio_out  => contatore_campione_out,
  count_hit      => enable_count_doppler
);

counter_doppler : counter_modulo_n
generic map (
  n => d
)
port map (
  clock          => not clock,
  count_en       => enable_count_doppler,
  reset_n        => reset_n,
  up_down        => '0',
  load_conteggio => '0',
  conteggio_in   => (others => '0'),
  conteggio_out  => contatore_doppler_out,
  count_hit      => enable_count_satellite_livelli
);

enable_count_satellite_impulsivo : livelli2impulsi
port map (
  input  => enable_count_satellite_livelli,
  clock  => clock,
  output => enable_count_satellite_impulsi
);


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

comparatore_i : comparatore
generic map (
  width => sample_width
)
port map (
  A        => sample_abs,
  B        => max_sig,
  AbiggerB => comparatore_out
);


end Structural;
