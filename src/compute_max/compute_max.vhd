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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compute_max is
    Generic ( sample_width : natural := 32;
              m : natural := 2;
              n : natural := 2;
              p : natural := 3);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sample_abs : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           campione : out STD_LOGIC_VECTOR(31 downto 0);
           doppler : out STD_LOGIC_VECTOR(31 downto 0);
           satellite : out STD_LOGIC_VECTOR(31 downto 0);
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           done : out STD_LOGIC);
end compute_max;

architecture Behavioral of compute_max is

signal cont_campioni, cont_doppler, cont_satelliti : std_logic_vector(31 downto 0) := (others => '0');
signal max_doppler, max_satellite : std_logic_vector(sample_width-1 downto 0);
signal pos_campione, pos_doppler, pos_satellite : std_logic_vector(31 downto 0);

begin

calcolo_max : process(clock, reset_n, sample_abs)
begin

  if(reset_n = '0') then

    max_doppler <= (others => '0');
    max_satellite <= (others => '0');
    cont_campioni <= (others => '0');
    cont_doppler <= (others => '0');
    cont_satelliti <= (others => '0');
	  campione <= (others => '0');
	  doppler <= (others => '0');
	  satellite <= (others => '0');
    done <= '0';

  elsif (rising_edge(clock)) then

    -- Se il campione appena arrivato appartiene allo stesso intervallo di frequenze
    -- doppler del campione precedente
    if(cont_campioni < p) then

      -- incrementa il contatore dei campioni per quella frequenza doppler
      cont_campioni <= cont_campioni + 1;

      else -- il campione appena arrivato è il PRIMO di un nuovo intervallo di frequenze

        -- Resetta il contatore dei campioni
        cont_campioni <= (0 => '1', others => '0');

        -- Segnala l'inizio dell'analisi di un nuovo intervallo di frequenze doppler
        cont_doppler <= cont_doppler + 1;

        -- Se ho finito le frequenze doppler per questo satellite
        if(cont_doppler >= n-1) then

          -- Confronta il max_doppler (massimo relativo) del satellite appena analizzato
          -- con l'attuale max_satellite (massimo assoluto)
          if(max_doppler > max_satellite) then

            -- Se il max_doppler è maggiore di max_satellite allora quest'ulitmo viene aggiornato
            max_satellite <= max_doppler;

            -- Aggiorna la posizione del campione massimo
            pos_satellite <= cont_satelliti;
          end if;

          -- Resetta il valore di max_doppler (massimo relativo) con il primo campione appena arrivato.
          -- In questo momento il primo campione è il campione più grande per il satellite.
  		    max_doppler <= sample_abs;

          -- Resetta il contatore degli intervalli doppler
          cont_doppler <= (others => '0');

          -- Segnala la terminazione dell'analisi del satellite
          cont_satelliti <= cont_satelliti + 1;

          -- Se ho finito di analizzare tutti i satelliti allora l'algoritmo termina
          if(cont_satelliti >= m-1) then
            done <= '1';
          end if;

		      end if;
      end if;

    -- Confronta il valore del campione appena arrivato con il valore massimo
    -- di questo intervallo di frequenze doppler
    if(sample_abs > max_doppler) then

      -- Se sample_abs è maggiore di max_doppler allora questo viene aggiornato
      max_doppler <= sample_abs;

      -- if(max_doppler > max_satellite) then
      --   pos_campione <= cont_campioni - 1;
      --   pos_doppler <= cont_doppler;
      -- end if;
      end if;

    campione <= pos_campione;
    doppler <= pos_doppler;
    satellite <= pos_satellite;

    max <= max_satellite;
    end if;
end process;

end Behavioral;
