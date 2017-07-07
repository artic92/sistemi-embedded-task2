----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06.07.2017 14:40:20
-- Design Name:
-- Module Name: tb_complex_max - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_complex_max is
end tb_complex_max;

architecture Behavioral of tb_complex_max is

component complex_max is
    Generic ( sample_width : natural := 32;
              s : natural := 5;
              d : natural := 4;
              c : natural := 5 );
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           sample : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample_max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           pos_campione  : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
           pos_doppler   : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
           ready_out : out STD_LOGIC;
           valid_out : out STD_LOGIC);                                                        
end component;

--Constants
constant clock_period : time := 10 ns;
constant sample_width : natural := 32;
constant s : natural := 5;
constant d : natural := 4;
constant c : natural := 5;

--Inputs
signal clock : std_logic := '0';
signal reset_n : std_logic := '1';
signal sample : std_logic_vector(sample_width-1 downto 0) := (others => '0');
signal sample_max : std_logic_vector(sample_width-1 downto 0) := (others => '0');
signal pos_campione  : STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
signal pos_doppler   : STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
signal pos_satellite : STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
signal complex_value : std_logic_vector(sample_width-1 downto 0) := (others => '0');
signal ready_out : std_logic := '0';
signal valid_out : std_logic := '0';
signal valid_in : std_logic := '0';
signal ready_in : std_logic := '0';

begin

uut:  complex_max
    Generic map ( sample_width => sample_width,
              s => s,
              d => d,
              c => c )
    Port map ( clock => clock,
           reset_n => reset_n,
           ready_in => ready_in,
           valid_in => valid_in,
           sample => sample,
           sample_max => sample_max,
           pos_campione  => pos_campione,
           pos_doppler   => pos_doppler,
           pos_satellite => pos_satellite,
           ready_out => ready_out,
           valid_out => valid_out);


clock_process :process
begin
    clock <= '0';
    wait for clock_period/2;
    clock <= '1';
    wait for clock_period/2;
end process;

stim_proc: process
begin
    reset_n <= '0';
    wait for 100 ns;
    reset_n <= '1';
    ready_in <= '0';

    --TEST Primo assoluto
 -- sample <= x"000a000a";
    sample <= x"00010001";

    --TEST dato iniziale non pronto
    --wait for clock_period * 20;
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00090009";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00090009";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';


    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    --TEST attesa simultanea dei blocchi
   -- sample <= x"000b000b";
   -- wait for clock_period * 50;
    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    --TEST Ultimo campione del secondo satellite
 --   sample <= x"000a000a";
    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    --TEST Primo campione del terzo satellite
    --sample <= x"000a000a";
    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    --TEST in mezzo al terzo satellite
--    sample <= x"000a000a";
    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00010001";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00040004";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00020002";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00060006";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00030003";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00070007";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    sample <= x"00080008";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

      --TEST Ultimo in assoluto
--    sample <= x"000a000a";
    sample <= x"00050005";
    valid_in <= '1';
    wait for clock_period * 3;
    valid_in <= '0';
    wait until ready_out = '1';

    valid_in <= '1';
    sample <=x"000c000c";

    wait for clock_period * 20;
    ready_in <= '0';

    wait;
end process;

end Behavioral;
