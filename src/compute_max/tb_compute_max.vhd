--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   12:30:47 06/28/2017
-- Design Name:
-- Module Name:   /media/sf_SistemiEmbedded/workbench/ISE/SE/compute_max/tb_compute_max.vhd
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_compute_max IS
END tb_compute_max;

ARCHITECTURE behavior OF tb_compute_max IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT compute_max
    GENERIC ( sample_width : natural := 32;
              m : natural := 2;
              n : natural := 2;
              p : natural := 3);
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         sample_abs : IN  std_logic_vector(sample_width-1 downto 0);
			campione : OUT STD_LOGIC_VECTOR(31 downto 0);
         doppler : OUT STD_LOGIC_VECTOR(31 downto 0);
         satellite : OUT STD_LOGIC_VECTOR(31 downto 0);
         max : OUT  std_logic_vector(sample_width-1 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;

	constant sample_width : natural:= 32;
   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal sample_abs : std_logic_vector(sample_width-1 downto 0) := (others => '0');

 	--Outputs
	signal campione : std_logic_vector(31 downto 0);
   signal doppler : std_logic_vector(31 downto 0);
   signal satellite : std_logic_vector(31 downto 0);
   signal max : std_logic_vector(sample_width-1 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: compute_max
   GENERIC MAP(
          sample_width => 32,
          m => 5,
          n => 4,
          p => 5
   )
   PORT MAP (
          clock => clock,
          reset_n => reset_n,
          sample_abs => sample_abs,
			 campione => campione,
			 doppler => doppler,
			 satellite => satellite,
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
		wait for 5 ns;
		sample_abs <= x"00000000";
		reset_n <= '1';
		wait for clock_period;

		sample_abs <= x"00000008";
		wait for clock_period;

		sample_abs <= x"00000007";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"0000001E";
		wait for clock_period;

		sample_abs <= x"0000000b";
		wait for clock_period;

		sample_abs <= x"0000000f";
		wait for clock_period;

		sample_abs <= x"00000009";
		wait for clock_period;

		sample_abs <= x"00000008";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"0000000a";
		wait for clock_period;

		sample_abs <= x"0000000b";
		wait for clock_period;

		sample_abs <= x"0000000c";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000007";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"0000000a";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"00000008";
		wait for clock_period;

		sample_abs <= x"0000000f";
		wait for clock_period;

		sample_abs <= x"00000014";
		wait for clock_period;

		sample_abs <= x"00000010";
		wait for clock_period;

		sample_abs <= x"00000011";
		wait for clock_period;

		sample_abs <= x"00000012";
		wait for clock_period;

		sample_abs <= x"00000013";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"00000005";
		wait for clock_period;

		sample_abs <= x"0000000a";
		wait for clock_period;

		sample_abs <= x"0000000f";
		wait for clock_period;

		sample_abs <= x"0000000e";
		wait for clock_period;

		sample_abs <= x"0000000c";
		wait for clock_period;

		sample_abs <= x"0000000b";
		wait for clock_period;

		sample_abs <= x"00000008";
		wait for clock_period;

		sample_abs <= x"00000007";
		wait for clock_period;

		sample_abs <= x"00000006";
		wait for clock_period;

		sample_abs <= x"00000005";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"0000001c";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000010";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"00000008";
		wait for clock_period;

		sample_abs <= x"00000006";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"0000000a";
		wait for clock_period;

		sample_abs <= x"00000009";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000007";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000002";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000005";
		wait for clock_period;

		sample_abs <= x"00000006";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000008";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000008";
		wait for clock_period;

		sample_abs <= x"00000001";
		wait for clock_period;

		sample_abs <= x"00000005";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000004";
		wait for clock_period;

		sample_abs <= x"00000005";
		wait for clock_period;

		sample_abs <= x"00000000";
		wait for clock_period;

		sample_abs <= x"00000006";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"00000003";
		wait for clock_period;

		sample_abs <= x"0000000a";
		wait for clock_period;

		wait until done = '1';
		wait for 20 ns;
		reset_n <= '0';

      wait;
   end process;

END;
