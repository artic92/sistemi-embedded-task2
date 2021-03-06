----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03.07.2017 14:41:37
-- Design Name:
-- Module Name: tb_ipcore_uniti - Behavioral
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

entity tb_ipcore_uniti is
end tb_ipcore_uniti;

architecture Behavioral of tb_ipcore_uniti is

  component test_dds_wrapper
  generic (
    campioni : natural := 20460
  );
  port (
    clock       : in  STD_LOGIC;
    reset_n     : in  STD_LOGIC;
    valid_in    : in  STD_LOGIC;
    ready_in    : in  STD_LOGIC;
    poff_pinc   : in  STD_LOGIC_VECTOR(47 downto 0);
    sine_cosine : out STD_LOGIC_VECTOR(31 downto 0);
    valid_out   : out STD_LOGIC;
    ready_out   : out STD_LOGIC;
    done        : out STD_LOGIC
  );
  end component test_dds_wrapper;

  component complex_max
  generic (
    sample_width : natural := 32;
    s            : natural := 5;
    d            : natural := 4;
    c            : natural := 5
  );
  port (
    clock         : in  STD_LOGIC;
    reset_n       : in  STD_LOGIC;
    valid_in      : in  STD_LOGIC;
    ready_in      : in  STD_LOGIC;
    sample        : in  STD_LOGIC_VECTOR(sample_width-1 downto 0);
    sample_max    : out STD_LOGIC_VECTOR(sample_width-1 downto 0);
    pos_campione  : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
    pos_doppler   : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
    pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
    max           : out STD_LOGIC_VECTOR(sample_width-1 downto 0);
    valid_out     : out STD_LOGIC;
    ready_out     : out STD_LOGIC
  );
  end component complex_max;

  constant clock_period : time := 200 ns; -- 5 MHz

  constant sample_width : natural:= 32;
  constant s : natural:= 2;
  constant d : natural:= 11;
  constant c : natural:= 6;

  --Inputs
  signal clock : STD_LOGIC := '0';
  signal reset_n : STD_LOGIC := '0';
  signal valid_in : STD_LOGIC := '0';
  signal poff_pinc : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal poff : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
  signal pinc : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');

  --Outputs
  signal sample_max : std_logic_vector(sample_width-1 downto 0);
  signal ready_out : STD_LOGIC := '0';
  signal done : std_logic;
  signal pos_campione : std_logic_vector(natural(ceil(log2(real(c))))-1 downto 0);
  signal pos_doppler : std_logic_vector(natural(ceil(log2(real(d))))-1 downto 0);
  signal pos_satellite : std_logic_vector(natural(ceil(log2(real(s))))-1 downto 0);
  signal max : std_logic_vector(sample_width-1 downto 0);
  signal valid_out : STD_lOGIC := '0';


  signal complex_max_ready_sig : std_logic;
  signal dds_valid_out : std_logic;
  signal sample_sig : std_logic_vector(sample_width-1 downto 0);

begin

  poff_pinc(47 downto 24) <= poff;
  poff_pinc(23 downto 0) <= pinc;

  test_dds_wrapper_i : test_dds_wrapper
  generic map (
    campioni => c
  )
  port map (
    clock       => clock,
    reset_n     => reset_n,
    valid_in    => valid_in,
    ready_in    => complex_max_ready_sig,
    poff_pinc   => poff_pinc,
    sine_cosine => sample_sig,
    valid_out   => dds_valid_out,
    ready_out   => ready_out,
    done        => done
  );

  complex_max_i : complex_max
  generic map (
    sample_width => sample_width,
    s            => s,
    d            => d,
    c            => c
  )
  port map (
    clock         => clock,
    reset_n       => reset_n,
    valid_in      => dds_valid_out,
    ready_in      => '0',
    sample        => sample_sig,
    sample_max    => sample_max,
    pos_campione  => pos_campione,
    pos_doppler   => pos_doppler,
    pos_satellite => pos_satellite,
    max           => max,
    valid_out     => valid_out,
    ready_out     => complex_max_ready_sig
  );

  clock_process: process
  begin
      clock <= '0';
    	wait for clock_period/2;
    	clock <= '1';
    	wait for clock_period/2;
  end process;

  stimuli: process
  begin

--LISTA DOPPLERS
--FFF597
--FFF797
--FFF998
--FFFB98
--FFFD99
--FFFF99
--19A
--39B
--59B
--79C
--99C


  wait for clock_period*10;
  reset_n <= '1';

ciclo_satelliti : for i in 0 to s-1 loop
  --PRIMA DOPPLER
  poff <= x"000000";
  pinc <= x"FFF597";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --SECONDA DOPPLER
  poff <= x"000000";
  pinc <= x"FFF797";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --TERZA DOPPLER
  poff <= x"000FFF";
  pinc <= x"FFF998";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --QUARTA DOPPLER
  poff <= x"FFF000";
  pinc <= x"FFFB98";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --QUINTA DOPPLER
  poff <= x"0F0F0F";
  pinc <= x"FFFD99";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --SESTA DOPPLER (che presenta il massimo)
  poff <= x"F0F0F0";
  --poff <= x"00000F";
  pinc <= x"FFFF99";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --SETTIMA DOPPLER
  poff <= x"FF0000";
  pinc <= x"00019A";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --OTTAVA DOPPLER
  poff <= x"00FF00";
  pinc <= x"00039B";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --NONA DOPPLER
  poff <= x"0000DC";
  pinc <= x"00059B";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --DECIMA DOPPLER
  poff <= x"003400";
  pinc <= x"00079C";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

  --UNDICESIMA DOPPLER
  poff <= x"220000";
  pinc <= x"00099C";

  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait until done = '1';

end loop;
  wait until valid_out = '1';
  -- METTERE QUI L'ASSERT PER LA VERIFICA DEL MAX ASSOLUTO

  wait;

  end process;

end Behavioral;
