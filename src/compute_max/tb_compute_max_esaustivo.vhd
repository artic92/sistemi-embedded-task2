--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   10:36:27 07/02/2017
-- Design Name:
-- Module Name:   C:/Users/BongoSteie/Desktop/CODICE VHDL/calcolomassimo/tb_esaustivo.vhd
-- Project Name:  calcolomassimo
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: compute_max
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_esaustivo IS
END tb_esaustivo;

ARCHITECTURE behavior OF tb_esaustivo IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT compute_max
	 Generic ( sample_width : natural := 32;
              s : natural := 5;             --! Numero di satelliti
              d : natural := 4;             --! Numero di intervalli pos_doppler
              c : natural := 5); 			--! Numero di campioni per intervallo pos_doppler
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         enable : IN std_logic;
         sample_abs : IN  std_logic_vector(sample_width-1 downto 0);
         sample : IN  std_logic_vector(sample_width-1 downto 0);
         pos_campione : OUT  std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0);
         pos_doppler : OUT  std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0);
         pos_satellite : OUT  std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0);
         max : OUT  std_logic_vector(sample_width-1 downto 0);
         sample_max : OUT  std_logic_vector(sample_width-1 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;

--	 for all : compute_max use entity work.compute_max(Behavioral);
	 for all : compute_max use entity work.compute_max(Structural);

	constant sample_width : natural:= 32;
	constant s : natural:= 5;
	constant d : natural:= 4;
	constant c : natural:= 5;
	constant num_cicli: natural :=s*d*c;

   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal enable : std_logic := '0';
   signal sample_abs : std_logic_vector(sample_width-1 downto 0) := (others => '0');
   signal sample : std_logic_vector(sample_width-1 downto 0) := (others => '0');

 	--Outputs
   signal pos_campione : std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0);
   signal pos_doppler : std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0);
   signal pos_satellite : std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0);
   signal max : std_logic_vector(sample_width-1 downto 0);
   signal sample_max : std_logic_vector(sample_width-1 downto 0);
   signal done : std_logic;
   --signal rand_num : integer := 0;

   -- Clock period definitions
   constant clock_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: compute_max PORT MAP (
          clock => clock,
          reset_n => reset_n,
          enable => enable,
          sample_abs => sample_abs,
          sample => sample,
          pos_campione => pos_campione,
          pos_doppler => pos_doppler,
          pos_satellite => pos_satellite,
          max => max,
          sample_max => sample_max,
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
	 variable sample_abs_variable, massimo : std_logic_vector(sample_width-1 downto 0) := (others => '0');
	 variable massimo_complesso : std_logic_vector(sample_width-1 downto 0) := (others => '0');
	 variable pos_campione : integer :=0;
	 variable pos_doppler : integer :=0;
	 variable pos_satellite : integer :=0;

	 begin
      -- hold reset state for 100 ns.
		reset_n<='0';
		sample_abs <= (others => '0');
      wait for 95 ns;
		reset_n<='1';
    enable <= '1';

        for j in 0 to num_cicli-1 loop
            for i in 0 to num_cicli-1 loop
			     if (i /= j) then
			         sample_abs <= STD_LOGIC_VECTOR(to_unsigned(i, sample_width));
			         sample_abs_variable := STD_LOGIC_VECTOR(to_unsigned(i, sample_width));
			     else
			         sample_abs <= std_logic_vector(to_unsigned(num_cicli, sample_width));
			         sample_abs_variable := std_logic_vector(to_unsigned(num_cicli, sample_width));
			     end if;
			     sample <= std_logic_vector(to_unsigned(i*10, sample_width));
                 if(sample_abs_variable > massimo)then
                     massimo := sample_abs_variable;
                     pos_campione := i mod c;
                     pos_doppler := (i/c)mod d;
                     pos_satellite := i/(c*d);
                     massimo_complesso := std_logic_vector(to_unsigned(i*10, sample_width));
                 end if;
            wait for clock_period;
            end loop;
            assert(max = massimo) report "Test Fallito massimo trovato errato!";
            assert(sample_max = massimo_complesso) report "Test Fallito complesso trovato errato!";
            assert(pos_campione = pos_campione) report "Test Fallito pos_campione trovata errata!";
            assert(pos_doppler = pos_doppler) report "Test Fallito pos_doppler trovata errata!";
            assert(pos_satellite = pos_satellite) report "Test Fallito pos_satellite trovata errata!";

            massimo := (others => '0');
            reset_n <= '0';
            wait for clock_period;
            reset_n <= '1';
        end loop;

      wait;
   end process;

END;
