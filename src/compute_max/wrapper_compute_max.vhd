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

entity wrapper_compute_max is
    Generic ( sample_width : natural := 32; --! Parallelismo in bit  del campione
          s : natural := 2;             --! Numero di satelliti
          d : natural := 2;             --! Numero di intervalli doppler
          c : natural := 3);            --! Numero di campioni per intervallo doppler
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           sample_abs : in STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample : in STD_LOGIC_VECTOR (sample_width-1 downto 0);
           pos_campione : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);  --! Posizione del massimo nell'intervallo doppler
           pos_doppler : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);   --! Intervallo di frequenze doppler al quale appartiene il massimo
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0); --! Satellite associato al massimo
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);                         --! Modulo del massimo
           sample_max : out STD_LOGIC_VECTOR(sample_width-1 downto 0);                    --! Valore complesso del massimo
           valid_in : in STD_LOGIC;
           ready_out : out STD_LOGIC;
           valid_out : out STD_LOGIC);
end wrapper_compute_max;

architecture Structural of wrapper_compute_max is

component compute_max is
    Generic ( sample_width : natural := 32; --! Parallelismo in bit  del campione
              s : natural := 2;             --! Numero di satelliti
              d : natural := 2;             --! Numero di intervalli doppler
              c : natural := 3);            --! Numero di campioni per intervallo doppler
    Port ( clock : in  STD_LOGIC;           --! Segnale di temporizzazione
           reset_n : in  STD_LOGIC;         --! Segnale di reset 0-attivo
           enable : in STD_LOGIC;           --! Segnale di enable 1-attivo
           sample_abs : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);                   --! Modulo del campione
           sample : in STD_LOGIC_VECTOR(sample_width-1 downto 0);                         --! Valore complesso del campione associato al modulo
           pos_campione : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);  --! Posizione del massimo nell'intervallo doppler
           pos_doppler : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);   --! Intervallo di frequenze doppler al quale appartiene il massimo
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0); --! Satellite associato al massimo
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);                         --! Modulo del massimo
           sample_max : out STD_LOGIC_VECTOR(sample_width-1 downto 0);                    --! Valore complesso del massimo
           done : out STD_LOGIC);                                                         --! Segnale di terminazione delle operazioni
end component compute_max;

component fsm_compute_max is
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           max_done : in STD_LOGIC;
           start : out STD_LOGIC;
           valid_out : out STD_LOGIC;
           ready_out : out STD_LOGIC;
           reset_n_all : out STD_LOGIC);
end component fsm_compute_max;

signal max_done, start, reset_n_all_sig : std_logic := '0';

begin

compute_max_inst: compute_max
    generic map ( sample_width => sample_width,
                    s => s,
                    d => d,
                    c => c )
    port map ( clock => clock,
                reset_n => reset_n_all_sig,
                enable => start,
                sample_abs => sample_abs,
                sample => sample,
                pos_campione => pos_campione,
                pos_doppler => pos_doppler,
                pos_satellite => pos_satellite,
                max => max,
                sample_max => sample_max,
                done => max_done );

fsm_compute_max_inst: fsm_compute_max
    port map ( clock => clock,
                reset_n => reset_n,
                valid_in => valid_in,
                ready_in => ready_in,
                max_done => max_done,
                start => start,
                valid_out => valid_out,
                ready_out => ready_out,
                reset_n_all => reset_n_all_sig );

end Structural;
