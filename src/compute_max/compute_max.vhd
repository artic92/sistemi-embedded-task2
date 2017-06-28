----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    11:23:18 06/28/2017
-- Design Name:
-- Module Name:    compute_max - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compute_max is
    Generic ( sample_width : natural := 32;
              m : natural := 2;
              n : natural := 2;
              p : natural := 3);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sample_abs : in  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           max : out  STD_LOGIC_VECTOR (sample_width-1 downto 0);
           done : out STD_LOGIC);
end compute_max;

architecture Behavioral of compute_max is

signal cont_campioni : std_logic_vector(p-1 downto 0) := (others => '0');
signal cont_doppler : std_logic_vector(n-1 downto 0) := (others => '0');
signal cont_satelliti : std_logic_vector(m-1 downto 0) := (others => '0');
signal max_doppler : std_logic_vector(sample_width-1 downto 0);
signal max_satellite : std_logic_vector(sample_width-1 downto 0);

begin

calcolo_max : process(clock, reset_n, sample_abs)

begin

  if(reset_n = '0') then

    max_doppler <= (others => '0');
    max_satellite <= (others => '0');
    cont_campioni <= (others => '0');
    cont_doppler <= (others => '0');
    cont_satelliti <= (others => '0');
    done <= '0';

  elsif (rising_edge(clock)) then

    if(cont_campioni < p) then
      cont_campioni <= cont_campioni + 1;
    else
      cont_campioni <= (0 => '1', others => '0');
      cont_doppler <= cont_doppler + 1;

      if(cont_doppler >= n-1) then
        if(max_doppler > max_satellite) then
          max_satellite <= max_doppler;
        end if;

		    max_doppler <= sample_abs;
        cont_doppler <= (others => '0');
        cont_satelliti <= cont_satelliti + 1;

        if(cont_satelliti >= m-1) then
          done <= '1';
        else
          done <= '0';
        end if;
		   end if;
    end if;

    if(sample_abs > max_doppler) then
      max_doppler <= sample_abs;
    end if;

  end if;

end process;

max <= max_satellite;

end Behavioral;
