----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.07.2017 16:57:25
-- Design Name:
-- Module Name: tb_wrapper_compute_max - Behavioral
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

entity tb_wrapper_compute_max is
end tb_wrapper_compute_max;

architecture Behavioral of tb_wrapper_compute_max is

component wrapper_compute_max is
    Generic ( sample_width : natural := 32;
          s : natural := 2;
          d : natural := 2;
          c : natural := 3);
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           sample_abs : in STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample : in STD_LOGIC_VECTOR (sample_width-1 downto 0);
           pos_campione : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
           pos_doppler : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample_max : out STD_LOGIC_VECTOR(sample_width-1 downto 0);
           valid_in : in STD_LOGIC;
           ready_out : out STD_LOGIC;
           valid_out : out STD_LOGIC);
end component wrapper_compute_max;

--Constants
constant clock_period : time := 10 ns;
constant sample_width : natural := 32;
constant s : natural := 5;
constant d: natural := 4;
constant c : natural := 5;
constant num_cicli : natural := s*c*d;

--Inputs
signal clock : std_logic := '0';
signal reset_n : std_logic := '1';
signal sample_abs :  STD_LOGIC_VECTOR (sample_width-1 downto 0) := (others => '0');
signal sample :  STD_LOGIC_VECTOR (sample_width-1 downto 0) := (others => '0');
signal valid_in :  STD_LOGIC := '0';
signal ready_in : STD_LOGIC := '0';

--Outputs
signal pos_campione : STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0) := (others => '0');
signal pos_doppler : STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0) := (others => '0');
signal pos_satellite : STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0) := (others => '0');
signal max : STD_LOGIC_VECTOR (sample_width-1 downto 0) := (others => '0');
signal sample_max : STD_LOGIC_VECTOR(sample_width-1 downto 0) := (others => '0');
signal ready_out : STD_LOGIC := '0';
signal valid_out : STD_LOGIC := '0';

begin

uut : wrapper_compute_max
 Generic map ( sample_width => sample_width,
               s => s,
               d => d,
               c => c)
 Port map(clock => clock,
          reset_n => reset_n,
          ready_in => ready_in,
          valid_in => valid_in,
          sample_abs => sample_abs,
          sample => sample,
          pos_campione => pos_campione,
          pos_doppler => pos_doppler,
          pos_satellite => pos_satellite,
          max => max,
          sample_max => sample_max,
          ready_out => ready_out,
          valid_out => valid_out );

clock_process :process
 begin
  clock <= '0';
  wait for clock_period/2;
  clock <= '1';
  wait for clock_period/2;
end process;

--! processo di stimolazione esaustivo
 stim_proc: process
    variable sample_abs_variable, massimo : std_logic_vector(sample_width-1 downto 0) := (others => '0');
    variable massimo_complesso : std_logic_vector(sample_width-1 downto 0) := (others => '0');
    variable pos_campione_variable : integer :=0;
    variable pos_doppler_variable : integer :=0;
    variable pos_satellite_variable : integer :=0;

    begin
        -- hold reset state for 100 ns.
        reset_n<='0';
        sample_abs <= (others => '0');
        wait for 95 ns;
        reset_n<='1';
        ready_in <= '1';

        for j in 0 to num_cicli-1 loop
            --ready_in <= '0';
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
                    pos_campione_variable := i mod c;
                    pos_doppler_variable := (i/c)mod d;
                    pos_satellite_variable := i/(c*d);
                    massimo_complesso := std_logic_vector(to_unsigned(i*10, sample_width));
                end if;
                wait for clock_period * 2;
                valid_in <='1';
                wait for clock_period * 2;
                valid_in <= '0';
                wait until ready_out = '1';
            end loop;
            assert(max = massimo) report "Test Fallito massimo trovato errato!";
            assert(sample_max = massimo_complesso) report "Test Fallito complesso trovato errato!";
            assert(pos_campione_variable = pos_campione) report "Test Fallito pos_campione trovata errata!";
            assert(pos_doppler_variable = pos_doppler) report "Test Fallito pos_doppler trovata errata!";
            assert(pos_satellite_variable = pos_satellite) report "Test Fallito pos_satellite trovata errata!";

            massimo := (others => '0');
            reset_n <= '0';
            wait for clock_period;
            reset_n <= '1';
            --ready_in <= '1';
        end loop;

        wait;
 end process;

end Behavioral;
