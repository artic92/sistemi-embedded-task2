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
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         input_value : IN  std_logic_vector(31 downto 0);
         abs_value : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal input_value : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal abs_value : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: complex_abs PORT MAP (
          clock => clock,
          reset_n => reset_n,
          input_value => input_value,
          abs_value => abs_value
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

		reset_n <= '1';
		input_value <= x"00050004";
      
		wait for clock_period*10;
		
      -- insert stimulus here
		wait for 100 ns;
		input_value <= x"00050003";

      wait;
   end process;

END;
