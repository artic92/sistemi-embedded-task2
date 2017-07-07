----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.07.2017 12:35:04
-- Design Name: 
-- Module Name: tb_wrapper_complex_abs - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_wrapper_complex_abs is
end tb_wrapper_complex_abs;

architecture Behavioral of tb_wrapper_complex_abs is

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
    
 stim_proc: process
    begin    
    
    reset_n <= '0';
    wait for 100 ns;
    reset_n <='1';
    
    complex_value <= x"00010001";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 50;
    ready_in <= '1';
    valid_in <= '0';
    
    wait for clock_period;
    complex_value <= x"00020002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 50;
    ready_in <= '1';
    valid_in <= '0';
    
    wait for clock_period;
    complex_value <= x"00030003";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 50;
    ready_in <= '1';
    valid_in <= '0';
    
    wait;
 end process;


end Behavioral;
