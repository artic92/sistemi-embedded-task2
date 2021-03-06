--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   12:30:47 06/28/2017
-- Design Name:
-- Module Name:   tb_compute_max.vhd
-- Project Name:  compute_max
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
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_compute_max IS
END tb_compute_max;

ARCHITECTURE behavior OF tb_compute_max IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT compute_max
    GENERIC ( sample_width : natural := 32;
              s : natural := 2;
              d : natural := 2;
              c : natural := 3);
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         enable : IN std_logic;
         sample_abs : IN  std_logic_vector(sample_width-1 downto 0);
			   sample : IN std_logic_vector(sample_width-1 downto 0);
         pos_campione : OUT std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0);
         pos_doppler : OUT std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0);
         pos_satellite : OUT std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0);
         max : OUT  std_logic_vector(sample_width-1 downto 0);
			   sample_max : OUT std_logic_vector(sample_width-1 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;

--   	for all : compute_max use entity work.compute_max(Behavioral);
    	for all : compute_max use entity work.compute_max(Structural);

	constant sample_width : natural:= 32;
	constant s : natural:= 5;
	constant d : natural:= 4;
	constant c : natural:= 5;

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
  signal done : std_logic;
	signal sample_max : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: compute_max
   GENERIC MAP(
          sample_width => 32,
          s => 5,
          d => 4,
          c => 5
   )
   PORT MAP (
          clock => clock,
          reset_n => reset_n,
          enable => enable,
          sample_abs => sample_abs,
			    pos_campione => pos_campione,
			    sample => sample,
			    sample_max => sample_max,
			    pos_doppler => pos_doppler,
			    pos_satellite => pos_satellite,
          max => max,
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
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;

      wait for clock_period*10;

      -- insert stimulus here
		reset_n <= '1';
  		wait for clock_period;
		wait for 5 ns;

  		sample <= x"00010001";
      -- TEST CASE: primo in assoluto (0,0,0,0x00010001)
      --sample_abs <= x"00000050";
  		sample_abs <= x"00000002";
		  enable <= '1';
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000008";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000007";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000001E";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000b";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000f";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000009";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000008";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000a";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000b";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000c";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000007";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000a";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000008";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000f";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000014";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000010";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000011";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000012";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000013";
  		wait for clock_period;

  		sample <= sample + 65537;
      -- TEST CASE: ultimo di un satellite (4,3,1,0x00280028)
      --sample_abs <= x"00000050";
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
      -- TEST CASE: primo di un satellite in mezzo (0,0,2,0x00290029)
      --sample_abs <= x"00000050";
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000005";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000a";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000f";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000e";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000c";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000b";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000008";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000007";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000006";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000005";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000001c";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000010";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000008";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000006";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
      -- TEST CASE: massimo interno all'intervallo doppler (2,1,3,0x00440044)
--      sample_abs <= x"00000050";
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"0000000a";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000009";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000007";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000002";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000005";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000006";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000008";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000008";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000001";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000005";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000004";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000005";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000000";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000006";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
  		sample_abs <= x"00000003";
  		wait for clock_period;

  		sample <= sample + 65537;
      -- TEST CASE: ultimo in assoluto (4,3,4,0x00640064)
--      sample_abs <= x"00000050";
  		sample_abs <= x"0000000a";
  		wait for clock_period;

  		wait until done = '1';
  		wait for 20 ns;
  		reset_n <= '0';

      wait;
   end process;

END;
