----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.07.2017 11:22:27
-- Design Name:
-- Module Name: wrapper_complex_abs - Structural
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

entity wrapper_complex_abs is
    Generic ( complex_width : natural := 32 );
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           complex_value : in STD_LOGIC_VECTOR (complex_width-1 downto 0);
           complex_value_out : out STD_LOGIC_VECTOR(complex_width-1 downto 0);
           abs_value : out STD_LOGIC_VECTOR (complex_width-1 downto 0);
           valid_out : out STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_out : out STD_LOGIC;
           ready_in : in STD_LOGIC);
end wrapper_complex_abs;

architecture Structural of wrapper_complex_abs is

component register_n_bit is
	generic (n : natural := 8);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
end component register_n_bit;

component complex_abs is
    Generic ( complex_width : natural := 32 );	--! Parallelismo in bit del numero complesso (inteso come somma di parte reale e immaginaria)
    Port ( clock : in STD_LOGIC;							--! Segnale di temporizzazione
            reset_n : in STD_LOGIC;						--! Segnale di reset 0-attivo
            enable : in STD_LOGIC;
            complex_value : in  STD_LOGIC_VECTOR (complex_width-1 downto 0); --! Numero complesso di cui calcolare il modulo
            abs_value : out  STD_LOGIC_VECTOR (complex_width-1 downto 0);	  --! Modulo del numero complesso
            done : out STD_LOGIC);																						--! Segnale di terminazione delle operazioni
end component complex_abs;

component fsm_complex_abs is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           abs_done : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           ready_out : out STD_LOGIC);
end component;

signal done_sig : std_logic := '0';
signal reset_abs_n : std_logic := '0';
signal abs_value_sig : std_logic_vector(complex_width-1 downto 0) := (others => '0');

begin

complex_abs_inst : complex_abs
    generic map ( complex_width => complex_width )
    port map ( clock => clock,
                reset_n => reset_n,
                enable => valid_in,
                complex_value => complex_value,
                abs_value => abs_value_sig,
                done => done_sig);

fsm_complex_abs_inst : fsm_complex_abs
   Port map ( clk => clock,
           reset_n => reset_n,
           valid_in => valid_in,
           ready_in => ready_in,
           abs_done => done_sig,
           valid_out => valid_out,
           ready_out => ready_out);

--Registro inserito per mantenere l'uscita del valore assoluto stabile siccome la FSM resetta l'uscita
--una volta che il valore assoluto è stato calcolato
reg_abs_value: register_n_bit
	Generic map (n => complex_width)
    Port map ( I => abs_value_sig,
                clock => clock,
                load => done_sig,
                reset_n => reset_n,
                O => abs_value);

reg_complex_value_out : register_n_bit
    Generic map (n => complex_width)
    Port map ( I => complex_value,
                clock => clock,
                load => valid_in,
                reset_n => reset_n,
                O => complex_value_out);

end Structural;
