----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03.07.2017 10:01:38
-- Design Name:
-- Module Name: tb_complex_abs_esaustivo - Behavioral
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


LIBRARY ieee;
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

entity tb_complex_abs_esaustivo is
--  Port ( );
end tb_complex_abs_esaustivo;

architecture Behavioral of tb_complex_abs_esaustivo is

component complex_abs is
	Generic ( complex_width : natural := 32 );	--! Parallelismo in bit del numero complesso (inteso come somma di parte reale e immaginaria)
    Port ( clock : in STD_LOGIC;							--! Segnale di temporizzazione
         reset_n : in STD_LOGIC;						--! Segnale di reset 0-attivo
				 enable : in STD_LOGIC;
         complex_value : in  STD_LOGIC_VECTOR (complex_width-1 downto 0); --! Numero complesso di cui calcolare il modulo
         abs_value : out  STD_LOGIC_VECTOR (complex_width-1 downto 0);	  --! Modulo del numero complesso
         done : out STD_LOGIC);																						--! Segnale di terminazione delle operazioni
end component complex_abs;

constant complex_width : natural:= 32;
constant clock_period : time := 10 ns;
constant num_cicli : natural := 10000;

signal clock : std_logic := '0';
signal reset_n : std_logic := '0';
signal enable : std_logic := '0';
signal done : std_logic := '0';
signal complex_value : std_logic_vector(complex_width-1 downto 0) := (others => '0');
signal abs_value : std_logic_vector(complex_width-1 downto 0) := (others => '0');


begin

   uut: complex_abs
    port map (
        clock => clock,
        reset_n => reset_n,
				enable => enable,
        complex_value => complex_value,
        abs_value => abs_value,
        done => done
    );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;

    -- Stimulus process
    stim_proc: process
     variable valore_assoluto : std_logic_vector(complex_width-1 downto 0) := (others => '0');
     variable complex_value_variable : integer := -(2 ** ((complex_width/2)-1));

     begin
      -- hold reset state for 100 ns.
        reset_n<='0';
        complex_value <= (complex_width-1 => '1', (complex_width/2)-1 => '1', others => '0');
        wait for 95 ns;
        reset_n<='1';
				enable <= '1';

        for i in 0 to num_cicli-1 loop
            --sommo in esadecimale 0x00010001 ad ogni iterazione al valore di cui calcolo il valore assoluto
            complex_value <= complex_value + 65537;
            complex_value_variable := complex_value_variable + 1;
            valore_assoluto := std_logic_vector(to_signed(complex_value_variable * complex_value_variable * 2, 32));
            wait until done = '1';

            assert(valore_assoluto = abs_value) report "Test Fallito valore assoluto trovato errato!";
            wait for clock_period;
        end loop;
      wait;
   end process;


end Behavioral;
