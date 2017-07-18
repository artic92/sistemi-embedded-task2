----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Scognamiglio, Riccio, Sorrentino
-- 
-- Create Date: 17.07.2017 16:04:17
-- Design Name: 
-- Module Name: integrazione_task - Structural
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

entity integrazione_task is
    Generic ( campione : natural := 20460;
              doppler : natural := 11;
              satellite : natural := 10);    
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           poff_pinc : in STD_LOGIC_VECTOR (47 downto 0);
           dds_out : out STD_LOGIC_VECTOR (31 downto 0); --SI PUO' TOGLIERE
           dds_done : out STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           ready_out : out STD_LOGIC;
           fft1_in : in STD_LOGIC_VECTOR(31 downto 0);
           fft1_ready_out : out STD_LOGIC;
           fft1_valid_in : in STD_LOGIC;
           ifft_out : out STD_LOGIC_VECTOR (31 downto 0); --SI PUO' TOGLIERE
           fft1_out : out STD_LOGIC_VECTOR (31 downto 0); --SI PUO' TOGLIERE
           fft2_out : out STD_LOGIC_VECTOR (31 downto 0); --SI PUO' TOGLIERE
           pos_campione : out STD_LOGIC_VECTOR (natural(ceil(log2(real(campione))))-1 downto 0);
           pos_doppler : out STD_LOGIC_VECTOR (natural(ceil(log2(real(doppler))))-1 downto 0);
           pos_satellite : out STD_LOGIC_VECTOR (natural(ceil(log2(real(satellite))))-1 downto 0);
           sample_max : out STD_LOGIC_VECTOR (31 downto 0);
           max : out STD_LOGIC_VECTOR (31 downto 0)); 
end integrazione_task;

architecture Structural of integrazione_task is

component test_dds_wrapper is
  generic ( campioni : natural := 20460 );                    --! Numero di campioni da generare
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
end component test_dds_wrapper;


component design_1_wrapper is
  port (
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    ifft_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ifft_tready : in STD_LOGIC;
    ifft_tvalid : out STD_LOGIC;
    mul_out : out STD_LOGIC_VECTOR ( 79 downto 0 );
    sgn_1_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    sgn_1_tready : out STD_LOGIC;
    sgn_1_tvalid : in STD_LOGIC;
    sgn_2_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    sgn_2_tready : out STD_LOGIC;
    sgn_2_tvalid : in STD_LOGIC;
    sig_1_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    sig_2_out : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end component design_1_wrapper;

component complex_max is
    Generic ( sample_width : natural := 32; --! Parallelismo in bit del del campione
              s : natural := 5;             --! Numero di satelliti
              d : natural := 4;             --! Numero di intervalli doppler
              c : natural := 5 );           --! Numero di campioni per intervallo doppler
    Port ( clock : in  STD_LOGIC;           --! Segnale di temporizzazione
           reset_n : in  STD_LOGIC;         --! Segnale di reset 0-attivo
           valid_in : in STD_LOGIC;         --! Indica che il dato sulla linea di ingresso è valido
           ready_in : in STD_LOGIC;         --! Indica che il componente a valle è pronto ad accettare valori in ingresso
           sample : in  STD_LOGIC_VECTOR(sample_width-1 downto 0);                       --! Valore complesso del campione associato al modulo
           sample_max : out  STD_LOGIC_VECTOR(sample_width-1 downto 0);                  --! Valore complesso del massimo
           max : out  STD_LOGIC_VECTOR(sample_width-1 downto 0);                         --! Modulo del campione massimo
           pos_campione  : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0); --! Posizione del massimo nell'intervallo doppler
           pos_doppler   : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0); --! Intervallo di frequenze doppler al quale appartiene il massimo
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0); --! Satellite associato al massimo
           valid_out : out STD_LOGIC;       --! Indica che il dato sulla linea di uscita è valido
           ready_out : out STD_LOGIC);      --! Indica che questo componente è pronto ad accettare valori in ingresso
end component complex_max;

--!Signal
signal ready_out_fft2, valid_in_fft2, valid_out_ifft, ready_out_complex_max : STD_LOGIC :=  '0';
signal fft2_in : STD_LOGIC_VECTOR(31 downto 0);
signal ifft_out_sig : STD_LOGIC_VECTOR(31 downto 0);

begin

--Collegamenti che andranno eliminati
ifft_out <= ifft_out_sig;
dds_out <= fft2_in;

dds_inst: test_dds_wrapper
 generic map ( campioni => campione )
 port map ( clock => clock,
            reset_n => reset_n,
            poff_pinc => poff_pinc,
            valid_in => valid_in,
            ready_in => ready_out_fft2,
            valid_out => valid_in_fft2,
            ready_out => ready_out,
            sine_cosine => fft2_in,
            done => dds_done); 
            
task1_inst: design_1_wrapper
 port map ( aclk => clock,
            aclken => '1',
            aresetn => reset_n,
            ifft_out => ifft_out_sig,
            ifft_tready => ready_out_complex_max,
            ifft_tvalid => valid_out_ifft,
            mul_out => open,
            sgn_1_in => fft1_in,
            sgn_1_tready => fft1_ready_out,
            sgn_1_tvalid => fft1_valid_in,
            sgn_2_in => fft2_in,
            sgn_2_tready => ready_out_fft2,
            sgn_2_tvalid => valid_in_fft2,
            sig_1_out => fft1_out, --SI PUO' METTERE OPEN 
            sig_2_out => fft2_out); --SI PUO' METTERE OPEN
            
complex_max_inst: complex_max
  generic map ( sample_width => 32,
                s => satellite,
                d => doppler,
                c => campione)
  port map ( clock => clock,
             reset_n => reset_n,
             valid_in => valid_out_ifft,
             ready_in => ready_in,
             sample => ifft_out_sig,
             sample_max => sample_max,
             max => max,
             pos_campione => pos_campione,
             pos_doppler => pos_doppler,
             pos_satellite => pos_satellite,
             valid_out => valid_out,
             ready_out => ready_out_complex_max);
  

end Structural;
