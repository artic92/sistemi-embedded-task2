----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.07.2017 17:24:32
-- Design Name: 
-- Module Name: tb_wrapper_complex_abs_esaustivo - Behavioral
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
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_wrapper_complex_abs_esaustivo is
end tb_wrapper_complex_abs_esaustivo;

architecture Behavioral of tb_wrapper_complex_abs_esaustivo is

component wrapper_complex_abs is
    Generic ( complex_width : natural := 32 );
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           complex_value : in STD_LOGIC_VECTOR (complex_width-1 downto 0);
           complex_value_out :out STD_LOGIC_VECTOR(complex_width-1 downto 0);
           abs_value : out STD_LOGIC_VECTOR (complex_width-1 downto 0);
           valid_out : out STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_out : out STD_LOGIC;
           ready_in : in STD_LOGIC);
end component wrapper_complex_abs;

--Constants
constant clock_period : time := 10 ns;
constant complex_width : natural := 32;
constant num_cicli : natural := 2 ** (complex_width-1)-1;
--constant num_cicli : natural := 10;

--Inputs
signal clock : std_logic := '0';
signal reset_n : std_logic := '1';
signal complex_value : std_logic_vector(complex_width-1 downto 0) := (others => '0');
signal valid_in : std_logic := '0';
signal ready_in : std_logic := '0';

--Outputs
signal abs_value : std_logic_vector(complex_width-1 downto 0);
signal valid_out: std_logic := '0';
signal ready_out : std_logic := '0';
signal complex_value_out : STD_LOGIC_VECTOR(complex_width-1 downto 0);


begin

 clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
   
uut : wrapper_complex_abs
   port map(
       clock => clock,
       reset_n => reset_n,
       complex_value => complex_value,
       complex_value_out => complex_value_out,
       abs_value => abs_value,
       valid_out => valid_out,
       valid_in => valid_in,
       ready_out => ready_out,
       ready_in => ready_in);
      
--Questo test incrementa ad ogni colpo di clock il valore in ingresso di 1 da 1 a 2^31 (non 2^32 perche in vivado non si puo rappresentare
-- come intero un numero piu grande di 2^31).
-- le due variabili rappresentano la parte real e quella immaginaria del segnale in ingresso in particolare
-- devo considerare che i valori ammissibili per entrambi siano compresi tra (-32768,32767) cioe
-- -2^complex_width-1 e 2^(complex_width-1)-1
stim_proc: process
variable modulo : std_logic_vector(complex_width-1 downto 0) := (others=> '0');
variable complex_value_variable_real, complex_value_variable_img : integer := 0;
begin    
    -- TEST partenza da 0
    reset_n <= '0';
    complex_value <= x"00000000";
    complex_value_variable_real := 0;
    complex_value_variable_img := 0;
    --TEST PARTENZA DAL PRIMO NEGATIVO
--    complex_value <=x"7fff7fff";
--    complex_value_variable_real := 32767;
--    complex_value_variable_img := 32767;
    wait for 100 ns;
    reset_n <= '1';
    ready_in <= '1';
    --Gli if sono messi per evitare che l'assert dia problemi durante la simulazione
    --I trattini indicano dei don't care.
    for i in 0 to num_cicli loop
        complex_value <= complex_value + 1;
        complex_value_variable_real := complex_value_variable_real + 1;
        --Se ho esaminato tutti i negativi della parte reale cioe il segnale in ingresso valeva al ciclo precedente
        -- ----FFFF e ora quindi mi trovo che  la parte reale è 0 e devo incrementare quella immaginaria
        if(complex_value_variable_real = 0) then
            complex_value_variable_img :=  complex_value_variable_img + 1;
        --Se ho esaminato tutti i numeri positivi della parte reale cioè il segnale in ingresso valeva al ciclo
        --precedente ----7FFF e ora quindi mi trovo che la parte reale deve essere portata al numero negativo piu grande
        elsif(complex_value_variable_real = 32768)then
            complex_value_variable_real := -2**((complex_width/2)-1);
        end if;
        --stessa considerazione del commento precendete solo applicata alla parte immaginaria
        if(complex_value_variable_img = 32768)then
            complex_value_variable_img := -2**((complex_width/2)-1);
        end if;
        valid_in <= '1';
        wait for clock_period * 2;
        valid_in <= '0';
        wait until valid_out<= '1';
        modulo := std_logic_vector(to_signed(complex_value_variable_real * complex_value_variable_real + complex_value_variable_img * complex_value_variable_img , 32));
        assert(abs_value = modulo)report "Modulo calcolato sbagliato!";
        wait until ready_out <= '1';
    end loop;
    
    wait;
end process;
end Behavioral;
