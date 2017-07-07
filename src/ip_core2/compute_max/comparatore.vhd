----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:10:11 07/01/2017
-- Design Name:
-- Module Name:    comparatore - DataFlow
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

entity comparatore is
	 Generic ( width : natural := 31 );
    Port ( enable : in STD_LOGIC;
					 A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           AbiggerB : out  STD_LOGIC);
end comparatore;

architecture DataFlow of comparatore is

signal AbiggerB_sig : std_logic;

begin

AbiggerB_sig <= '1' when A > B else '0';
AbiggerB <= AbiggerB_sig and enable;

end DataFlow;
