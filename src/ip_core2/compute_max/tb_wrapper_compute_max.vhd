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

stim_proc: process
    variable valore_assoluto : std_logic_vector(sample_width-1 downto 0) := (others => '0');
    variable sample_abs_variable : integer := 0;

    begin
    reset_n <= '0';
    wait for 100 ns;
    reset_n <='1';
    ready_in <= '1';

--    for j in 0 to num_cicli-1 loop
--        if(j = 3) then
--            sample <= sample + 65537;
--            sample_abs_variable := 200;
--            sample_abs <= std_logic_vector(to_unsigned(sample_abs_variable * sample_abs_variable * 2, sample_width));
--        else
--            sample <= sample + 65537;
--            sample_abs_variable := 50;
--            sample_abs <= std_logic_vector(to_unsigned(sample_abs_variable * sample_abs_variable * 2, sample_width));
--        end if;
--        sample <= sample + 65537;
--        sample_abs_variable := sample_abs_variable + 1;
--        sample_abs <= std_logic_vector(to_unsigned(sample_abs_variable * sample_abs_variable * 2, sample_width));
--        wait for clock_period * 2;
--        valid_in <='1';
--        wait for clock_period * 2;
--        valid_in <= '0';
--    end loop;

    --TEST Primo Assoluto
   -- sample <= x"000a000a";
    --sample_abs <= x"000000c8";
    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period;
    reset_n <='1';
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period;
    reset_n <='1';
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    --TEST Ultimo campione del secondo satellite
    --sample <= x"000a000a";
    --sample_abs <= x"000000c8";
    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    --TEST Primo campione del terzo satellite
    --sample <= x"000a000a";
    --sample_abs <= x"000000c8";
    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

     --TEST in mezzo al terzo satellite
   -- sample <= x"000a000a";
    --sample_abs <= x"000000c8";
    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';


    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';


    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';


    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    sample_abs <= x"00000002";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    sample_abs <= x"00000020";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    sample_abs <= x"00000008";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    sample_abs <= x"00000012";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    sample_abs <= x"00000048";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    sample_abs <= x"00000062";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    sample_abs <= x"00000080";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    valid_in <= '0';
    wait until ready_out = '1';

    --TEST Ultimo in assoluto
 --  sample <= x"000a000a";
   -- sample_abs <= x"000000c8";
   sample <= x"00050005";
   sample_abs <= x"00000032";
    wait for clock_period * 2;
    valid_in <='1';
    wait for clock_period * 2;
    --valid_in <= '0';

    --TEST il blocco successivo al compute_max sarebbe pronto a ricevere il dato
    --mentre quello prima non ha generato nuovi dati
    ready_in <= '0';
    wait until valid_out <= '1';
    ready_in <= '1';
    valid_in <= '0';

    wait;
 end process;

end Behavioral;
