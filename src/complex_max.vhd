----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:21:55 07/01/2017
-- Design Name:
-- Module Name:    complex_max - Structural
-- Project Name:
-- Target Devices:
-- Tool versions:
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity complex_max is
    Generic ( sample_width : natural := 32;
              s : natural := 5;
              d : natural := 4;
              c : natural := 5 );
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sample : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           sample_max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           pos_campione  : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
           pos_doppler   : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
           pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
           done : out STD_LOGIC);
end complex_max;

architecture Structural of complex_max is

component complex_abs
generic (
  complex_width : natural := 32
);
port (
  clock         : in  STD_LOGIC;
  reset_n       : in  STD_LOGIC;
  complex_value : in  STD_LOGIC_VECTOR (complex_width-1 downto 0);
  abs_value     : out STD_LOGIC_VECTOR (complex_width-1 downto 0);
  done          : out STD_LOGIC
);
end component complex_abs;

component compute_max
generic (
  sample_width : natural := 32;
  s : natural := 2;
  d : natural := 2;
  c : natural := 3
);
port (
  clock         : in  STD_LOGIC;
  reset_n       : in  STD_LOGIC;
  sample_abs    : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);
  sample        : in  STD_LOGIC_VECTOR(sample_width-1 downto 0);
  pos_campione  : out STD_LOGIC_VECTOR(natural(ceil(log2(real(c))))-1 downto 0);
  pos_doppler   : out STD_LOGIC_VECTOR(natural(ceil(log2(real(d))))-1 downto 0);
  pos_satellite : out STD_LOGIC_VECTOR(natural(ceil(log2(real(s))))-1 downto 0);
  max           : out STD_LOGIC_VECTOR (sample_width-1 downto 0);
  sample_max    : out STD_LOGIC_VECTOR(sample_width-1 downto 0);
  done          : out STD_LOGIC
);
end component compute_max;

for all : compute_max use entity work.compute_max(Structural);
-- for all : compute_max use entity work.compute_max(Behavioral);

signal abs_value_sig : std_logic_vector(sample_width-1 downto 0);

begin

complex_abs_i : complex_abs
generic map (
  complex_width => sample_width
)
port map (
  clock         => clock,
  reset_n       => reset_n,
  complex_value => sample,
  abs_value     => abs_value_sig,
  done          => open
);

compute_max_i : compute_max
generic map (
  sample_width => sample_width,
  s => s,
  d => d,
  c => c
)
port map (
  clock         => clock,
  reset_n       => reset_n,
  sample_abs    => abs_value_sig,
  sample        => sample,
  pos_campione  => pos_campione,
  pos_doppler   => pos_doppler,
  pos_satellite => pos_satellite,
  max           => open,
  sample_max    => sample_max,
  done          => done
);

end Structural;
