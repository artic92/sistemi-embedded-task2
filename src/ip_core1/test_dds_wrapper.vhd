--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
--Date        : Mon Jul 10 15:30:57 2017
--Host        : sistemiEmbedded running 64-bit Ubuntu 16.10
--Command     : generate_target test_dds_wrapper.bd
--Design      : test_dds_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity test_dds_wrapper is
  generic (
    campioni : natural := 20460 );
  port (
    clock : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    poff_pinc : in STD_LOGIC_VECTOR(47 downto 0);
    ready_in : in STD_LOGIC;
    valid_in : in STD_LOGIC;
    ready_out : out STD_LOGIC;
    valid_out : out STD_LOGIC;
    sine_cosine : out STD_LOGIC_VECTOR(31 downto 0);
    done : out STD_LOGIC
  );
end test_dds_wrapper;

architecture STRUCTURE of test_dds_wrapper is

  component test_dds is
  port (
    ready_out : out STD_LOGIC;
    valid_in : in STD_LOGIC;
    clock : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    sine_cosine : out STD_LOGIC_VECTOR(31 downto 0);
    ready_in : in STD_LOGIC;
    valid_out : out STD_LOGIC;
    poff_pinc : in STD_LOGIC_VECTOR(47 downto 0)
  );
  end component test_dds;

  component register_n_bit is
  generic (
    n : natural := 8
  );
  port (
    I : in  STD_LOGIC_VECTOR(n-1 downto 0);
    clock : in  STD_LOGIC;
    load : in  STD_LOGIC;
    reset_n : in  STD_LOGIC;
    O : out  STD_LOGIC_VECTOR(n-1 downto 0)
  );
  end component register_n_bit;

  component counter_modulo_n
  generic (
    n : natural := 16
  );
  port (
    clock          : in  STD_LOGIC;
    count_en       : in  STD_LOGIC;
    reset_n        : in  STD_LOGIC;
    up_down        : in  STD_LOGIC;
    load_conteggio : in  STD_LOGIC;
    conteggio_in   : in  STD_LOGIC_VECTOR(natural(ceil(log2(real(n))))-1 downto 0);
    conteggio_out  : out STD_LOGIC_VECTOR((natural(ceil(log2(real(n)))))-1 downto 0);
    count_hit      : out STD_LOGIC
  );
  end component counter_modulo_n;

  component d_edge_triggered
  port (
    data_in  : in  STD_LOGIC;
    reset_n  : in  STD_LOGIC;
    clock    : in  STD_LOGIC;
    data_out : out STD_LOGIC
  );
  end component d_edge_triggered;

  component fsm_dds_wrapper
  port (
    clock       : in  STD_LOGIC;
    reset_n     : in  STD_LOGIC;
    valid_in    : in  STD_LOGIC;
    count_hit   : in  STD_LOGIC;
    reset_n_all : out STD_LOGIC
  );
  end component fsm_dds_wrapper;

  signal sine_cosine_sig : std_logic_vector(31 downto 0);
  signal valid_out_sig : std_logic;
  signal counter_enable_sig : std_logic;
  signal count_hit_sig, reset_n_all : std_logic;

begin

valid_out <= valid_out_sig;
counter_enable_sig <= valid_out_sig and ready_in;

test_dds_i : component test_dds
port map (
  clock => clock,
  poff_pinc(47 downto 0) => poff_pinc(47 downto 0),
  ready_in => ready_in,
  ready_out => ready_out,
  reset_n => reset_n_all,
  sine_cosine(31 downto 0) => sine_cosine_sig(31 downto 0),
  valid_in => valid_in,
  valid_out => valid_out_sig
);

reg_complex_value_out : register_n_bit
generic map (
  n => 32
)
port map (
  I => sine_cosine_sig,
  clock => clock,
  load => valid_out_sig,
  reset_n => reset_n_all,
  O => sine_cosine
);

counter_campioni : counter_modulo_n
generic map (
  n => campioni
)
port map (
  clock          => clock,
  count_en       => counter_enable_sig,
  reset_n        => reset_n_all,
  up_down        => '0',
  load_conteggio => '0',
  conteggio_in   => (others => '0'),
  conteggio_out  => open,
  count_hit      => count_hit_sig
);

ff_count_hit_delayed : d_edge_triggered
port map (
  data_in  => count_hit_sig,
  reset_n  => reset_n,
  clock    => clock,
  data_out => done
);

fsm_dds_wrapper_i : fsm_dds_wrapper
port map (
  clock       => clock,
  reset_n     => reset_n,
  valid_in    => valid_in,
  count_hit   => count_hit_sig,
  reset_n_all => reset_n_all
);

end STRUCTURE;
