----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03.07.2017 14:41:37
-- Design Name:
-- Module Name: tb_wrapper_dds - Behavioral
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

entity tb_wrapper_dds is
end tb_wrapper_dds;

architecture Behavioral of tb_wrapper_dds is

  component test_dds_wrapper
  generic (
    campioni : natural := 20460
  );
  port (
    clock       : in  STD_LOGIC;
    reset_n     : in  STD_LOGIC;
    poff_pinc   : in  STD_LOGIC_VECTOR(47 downto 0);
    ready_in    : in  STD_LOGIC;
    valid_in    : in  STD_LOGIC;
    ready_out   : out STD_LOGIC;
    valid_out   : out STD_LOGIC;
    sine_cosine : out STD_LOGIC_VECTOR(31 downto 0);
    done        : out STD_LOGIC
  );
  end component test_dds_wrapper;

  constant clock_period : time := 10 ns;

  constant c : natural:= 5;
  constant sample_width : natural := 32;

  --Inputs
  signal clock : STD_LOGIC := '0';
  signal reset_n : STD_LOGIC := '0';
  signal valid_in : STD_LOGIC := '0';
  signal poff_pinc : STD_LOGIC_VECTOR(47 downto 0);

  -- Utili per il test
  signal poff : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
  signal pinc : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');

  --Outputs
  signal valid_out : STD_lOGIC := '0';
  signal ready_out : STD_LOGIC := '0';
  signal sine_cosine : std_logic_vector(sample_width-1 downto 0);
  signal done : std_logic;

begin

  poff_pinc(47 downto 24) <= poff;
  poff_pinc(23 downto 0) <= pinc;

  test_dds_wrapper_i : test_dds_wrapper
  generic map (
    campioni => c
  )
  port map (
    clock       => clock,
    poff_pinc   => poff_pinc,
    ready_in    => '1',
    ready_out   => ready_out,
    reset_n     => reset_n,
    sine_cosine => sine_cosine,
    valid_in    => valid_in,
    valid_out   => valid_out,
    done        => done
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

  wait for clock_period*10;
  reset_n <= '1';

  poff <= x"000000";
  pinc <= x"00099c";

  -- Genero c campioni
  valid_in <= '1';
  -- Valid_in deve essere alto 2 periodi di clock
  wait for clock_period*2;
  valid_in <= '0';
  
  wait until done = '1';
  
  poff <= x"000000";
  pinc <= x"00088f";
  
  -- Genero ALTRI c campioni
  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';
  
  wait until done = '1';
  
  poff <= x"000000";
  pinc <= x"000fec";
  
  -- Genero ALTRI c campioni
  valid_in <= '1';
  wait for clock_period*2;
  valid_in <= '0';

  wait;
  end process;

end Behavioral;
