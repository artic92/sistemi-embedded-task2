----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:15:55 12/18/2015 
-- Design Name: 
-- Module Name:    parte_operativa - Structural 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parte_operativa_sqrt is
	 generic ( n : natural := 8 );
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR (n-1 downto 0);
           load_qd : in  STD_LOGIC;
           load_r : in STD_LOGIC;
           shift: in  STD_LOGIC;
           count_en: in  STD_LOGIC;
           mod_n: out  STD_LOGIC;
           root : out  STD_LOGIC_VECTOR ((n/2)-1 downto 0));
end parte_operativa_sqrt;

architecture Structural of parte_operativa_sqrt is

COMPONENT register_n_bit
	generic (n : natural := 8;
					delay : time := 0 ns);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT add_sub
	 generic ( n : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           subtract : in  STD_LOGIC;
           ovfl : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT shift_register_n_bit
	 generic (n : natural := 8;
						delay : time := 0 ns);
    Port (D_IN : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  clock : in STD_LOGIC;
	        reset_n : in  STD_LOGIC;
           load : in  STD_LOGIC;
           shift : in  STD_LOGIC;
           lt_rt : in  STD_LOGIC;
			  sh_in : in STD_LOGIC;
			  sh_out : out STD_LOGIC;
           D_OUT : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT contatore_modulo_n
	 generic (n : natural := 4);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           count_en : in  STD_LOGIC;
			  up_down : in STD_LOGIC;
           mod_n : out  STD_LOGIC);
END COMPONENT;

signal d_sig : std_logic_vector (n-1 downto 0) := (others => '0');
signal q_sig : std_logic_vector ((n/2)-1 downto 0) := (others => '0');
signal r_sig_in, r_sig_out, a_sig, b_sig : std_logic_vector ((n/2)+1 downto 0) := (others => '0');
signal not_segno : std_logic := '0';

begin

root <= q_sig;

a_sig <= r_sig_out((n/2)-1 downto 0) & d_sig(n-1) & d_sig(n-2);
b_sig <= q_sig & r_sig_out((n/2)+1) & '1';
not_segno <= not r_sig_out((n/2)+1);				

registro_d : process(clock, reset_n)
begin
	if (reset_n = '0') then
		d_sig <= (others => '0');
	elsif (rising_edge(clock)) then
		if (load_qd = '1') then
			d_sig <= D;
		elsif (shift = '1') then
			-- shift di due
			d_sig <= d_sig(n-3 downto 0) & "00";
		end if;
	end if;
end process;

registro_q : shift_register_n_bit
	generic map(n/2)
	PORT MAP(D_IN => q_sig, clock => clock, reset_n => reset_n, load => load_qd, 
								shift => shift, lt_rt => '0', sh_in => not_segno, sh_out => open,  D_OUT => q_sig);										

adder_subtractor : add_sub
	generic map((n/2)+2)
	PORT MAP(A => a_sig,	B => b_sig, subtract => not_segno, ovfl => open, S => r_sig_in);
	
registro_r : register_n_bit
	generic map((n/2)+2)
	PORT MAP(I => r_sig_in, clock => clock, load => load_r, reset_n => reset_n, O => r_sig_out);
	
contatore : contatore_modulo_n
	generic map(n/2) 
	PORT MAP(clock => clock, reset_n => reset_n, count_en => count_en, up_down => '0', mod_n => mod_n);
								
end Structural;

architecture Behavioral of parte_operativa_sqrt is

COMPONENT add_sub
	 generic ( n : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           subtract : in  STD_LOGIC;
           ovfl : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

signal d_sig : std_logic_vector (n-1 downto 0) := (others => '0');
signal q_sig : std_logic_vector ((n/2)-1 downto 0) := (others => '0');
signal r_sig_in, r_sig_out, a_sig, b_sig : std_logic_vector ((n/2)+1 downto 0) := (others => '0');
signal not_segno : std_logic := '0';

begin

root <= q_sig;
a_sig <= r_sig_out((n/2)-1 downto 0) & d_sig(n-1) & d_sig(n-2);
b_sig <= q_sig & r_sig_out((n/2)+1) & '1';
not_segno <= not r_sig_out((n/2)+1);

registro_d : process(clock, reset_n)
begin
	if (reset_n = '0') then
		d_sig <= (others => '0');
	elsif rising_edge(clock) then
		if (load_qd = '1') then
			d_sig <= D;
		elsif (shift = '1') then
			-- shift di due
			d_sig <= d_sig(n-3 downto 0) & "00";
		end if;
	end if;
end process;

registro_q : process(clock, reset_n)
begin
	if (reset_n = '0') then
		q_sig <= (others => '0');
	elsif rising_edge(clock) then
		if (load_qd = '1') then
			q_sig <= q_sig;
		elsif (shift = '1') then
			q_sig <= q_sig((n/2)-2 downto 0) & not r_sig_out((n/2)+1);
		end if;
	end if;
end process;

registro_r : process(clock, reset_n)
begin
	if (reset_n = '0') then
		r_sig_out <= (others => '0');
	elsif rising_edge(clock) then
		if (load_r = '1') then
			r_sig_out <= r_sig_in;
		end if;
	end if;
end process;

adder_subtractor : add_sub
	generic map((n/2)+2)
	PORT MAP(A => a_sig,	B => b_sig, subtract => not_segno, ovfl => open, S => r_sig_in);

--add_sub : process(a_sig, b_sig, r_sig_out)
--begin
--	if(r_sig_out((n/2)+1) = '0') then
--		r_sig_in <= std_logic_vector(unsigned(a_sig) - unsigned(b_sig));
--	else
--		r_sig_in <= std_logic_vector(unsigned(a_sig) + unsigned(b_sig));
--	end if;
--end process;

counter : process(clock, reset_n)
variable conteggio : natural range 0 to (n/2)-1;
begin
	if (reset_n = '0') then
		conteggio := 0;
	elsif rising_edge(clock) then
		if (count_en = '1') then
			if (conteggio = (n/2)-1) then
				mod_n <= '1';
				conteggio := conteggio + 1;
			else
				conteggio := conteggio + 1;	
				mod_n <= '0';
			end if;
		end if;
	end if;
end process;

end Behavioral;

architecture asFunction of parte_operativa_sqrt is

function  sqrt  ( d : UNSIGNED ) return UNSIGNED is
variable a : unsigned(31 downto 0):= d;  --original input.
variable q : unsigned(15 downto 0):= (others => '0');  --result.
variable left, right, r : unsigned(17 downto 0):= (others => '0');  --input to adder/sub.r-remainder.
variable i : integer := 0;

begin
for i in 0 to 15 loop
	right(0):= '1';
	right(1):= r(17);
	right(17 downto 2) := q;
	left(1 downto 0) := a(31 downto 30);
	left(17 downto 2) := r(15 downto 0);
	a(31 downto 2) := a(29 downto 0);  --shifting by 2 bit.
	if ( r(17) = '1') then
		r := left + right;
	else
		r := left - right;
	end if;
	q(15 downto 1) := q(14 downto 0);
	q(0) := not r(17);
end loop; 
return q;

end sqrt;

--An example of how to use the function.
--signal x : unsigned(31 downto 0) :="00000000000000000000000000110010";   --50 (root = 7)
signal x : unsigned(31 downto 0) := "00000000000000000000000000000000";   --127
signal b : unsigned(15 downto 0) := (others => '0');

begin

b <= sqrt ( x );  --function is "called" here.

end asFunction;

