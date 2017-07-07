--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   21:15:44 06/26/2017
-- Design Name:
-- Module Name:   /media/sf_SistemiEmbedded/workbench/ISE/SE/complex_modulus/tb_complex_abs.vhd
-- Project Name:  complex_modulus
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: complex_abs
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_complex_abs IS
END tb_complex_abs;

ARCHITECTURE behavior OF tb_complex_abs IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT complex_abs
    GENERIC ( complex_width : natural := 32 );
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         enable : IN std_logic;
         complex_value : IN  std_logic_vector(complex_width-1 downto 0);
         abs_value : OUT  std_logic_vector(complex_width-1 downto 0);
         done : OUT std_logic
        );
    END COMPONENT;

   constant complex_width : natural := 32;

   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal enable : std_logic := '0';
   signal complex_value : std_logic_vector(complex_width-1 downto 0) := (others => '0');

 	--Outputs
   signal abs_value : std_logic_vector(complex_width-1 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: complex_abs PORT MAP (
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
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;

		  wait for clock_period*10;

      -- insert stimulus here
      enable <= '1';
      wait for 5 ns;
      complex_value <= x"00050004"; -- 0x00000029
      wait for 5 ns;
      reset_n <= '1';

      wait until done = '1';
	  	complex_value <= x"00020003"; -- 0x0000000D

      wait until done = '1';
      complex_value <= x"FFFF0006"; -- 0x00000025

      wait until done = '1';
      complex_value <= x"00051000"; -- 0x01000019

      wait;
   end process;

END;
