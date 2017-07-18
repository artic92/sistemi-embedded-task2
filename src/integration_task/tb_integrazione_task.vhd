----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Scognamiglio, Riccio, Sorrentino
-- 
-- Create Date: 17.07.2017 16:56:47
-- Design Name: 
-- Module Name: tb_integrazione_task - Behavioral
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
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_integrazione_task is
end tb_integrazione_task;

architecture Behavioral of tb_integrazione_task is

component integrazione_task is
    Generic ( campione : natural := 20460;
              doppler : natural := 11;
              satellite : natural := 10);    
    Port ( clock : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           poff_pinc : in STD_LOGIC_VECTOR (47 downto 0);
           dds_out : out STD_LOGIC_VECTOR (31 downto 0); --DA TOGLIERE
           dds_done : out STD_LOGIC;
           valid_in : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           ready_out : out STD_LOGIC;
           fft1_in : in STD_LOGIC_VECTOR(31 downto 0);
           fft1_ready_out : out STD_LOGIC;
           fft1_valid_in : in STD_LOGIC;
           ifft_out : out STD_LOGIC_VECTOR (31 downto 0); --DA TOGLIERE
           fft1_out : out STD_LOGIC_VECTOR (31 downto 0); --DA TOGLIERE
           fft2_out : out STD_LOGIC_VECTOR (31 downto 0); --DA TOGLIERE
           pos_campione : out STD_LOGIC_VECTOR (natural(ceil(log2(real(campione))))-1 downto 0);
           pos_doppler : out STD_LOGIC_VECTOR (natural(ceil(log2(real(doppler))))-1 downto 0);
           pos_satellite : out STD_LOGIC_VECTOR (natural(ceil(log2(real(satellite))))-1 downto 0);
           sample_max : out STD_LOGIC_VECTOR (31 downto 0);
           max : out STD_LOGIC_VECTOR (31 downto 0)); 
end component integrazione_task;

--!Constants
constant campione : natural:= 8;
constant doppler : natural:= 11;
constant satellite : natural:= 10;
constant clock_period : time := 100 ns;

--!Signal
signal clock : std_logic := '0';
signal reset_n : std_logic := '0';
signal valid_in : std_logic := '0';
signal valid_out : std_logic := '0';
signal ready_in : std_logic := '0';
signal ready_out : std_logic := '0';
signal dds_done : std_logic := '0';
signal fft1_ready_out : std_logic := '0';
signal fft1_valid_in : std_logic := '0';
signal fft1_in : std_logic_vector(31 downto 0) := (others => '0');
signal ifft_out : std_logic_vector(31 downto 0) := (others => '0');
signal poff_pinc : std_logic_vector(47 downto 0) := (others => '0');
signal dds_out : std_logic_vector(31 downto 0) := (others => '0');
signal fft1_out : std_logic_vector(31 downto 0) := (others => '0');
signal fft2_out : std_logic_vector(31 downto 0) := (others => '0');
signal sample_max : std_logic_vector(31 downto 0) := (others => '0');
signal max : std_logic_vector(31 downto 0) := (others => '0');
signal pos_campione : std_logic_vector(natural(ceil(log2(real(campione))))-1 downto 0) := (others => '0');
signal pos_doppler : std_logic_vector(natural(ceil(log2(real(doppler))))-1 downto 0) := (others => '0');
signal pos_satellite : std_logic_vector(natural(ceil(log2(real(satellite))))-1 downto 0) := (others => '0');
 

--SEGNALI PER LA SCRITTURA SUL FILE
signal file_sig1_out : bit_vector(31 downto 0);  
signal file_sig2_out : bit_vector(31 downto 0);  
signal file_ifft_out : bit_vector(31 downto 0);
signal linenumber : integer:= 1; 
signal endoffile : bit := '0'; 

signal fft1_out_sig : std_logic_vector(31 downto 0) := (others => '0');
signal fft2_out_sig : std_logic_vector(31 downto 0) := (others => '0');
signal ifft_out_sig : std_logic_vector(31 downto 0) := (others => '0');

begin

ifft_out <= ifft_out_sig;
fft1_out <= fft1_out_sig;
fft2_out <= fft2_out_sig;

uut: integrazione_task
    Generic map ( campione => campione,
                  doppler => doppler,
                  satellite => satellite )   
    Port map ( clock => clock,
           reset_n => reset_n,
           poff_pinc => poff_pinc,
           valid_in => valid_in,
           ready_in => ready_in,
           valid_out => valid_out,
           ready_out => ready_out,
           fft1_in => fft1_in,
           fft1_ready_out => fft1_ready_out,
           fft1_valid_in => fft1_valid_in,
           dds_out => dds_out,
           dds_done => dds_done,
           fft1_out => fft1_out_sig,
           fft2_out => fft2_out_sig,
           ifft_out => ifft_out_sig,
           pos_campione => pos_campione,
           pos_doppler => pos_doppler,
           pos_satellite => pos_satellite,
           sample_max => sample_max,
           max => max);

clock_process: process
  begin
      clock <= '0';
    	wait for clock_period/2;
    	clock <= '1';
    	wait for clock_period/2;
  end process;
  
fft1_input_process: process(clock,fft1_ready_out)
begin
    if(rising_edge(clock))then
        if(fft1_ready_out = '1')then
            fft1_in <= fft1_in + 1;
            fft1_valid_in <= '1';
        else
            fft1_valid_in <= '0';
        end if;
    end if;
end process;

stimoli: process
  begin
    wait for clock_period*10;
    reset_n <= '1';
    ready_in <= '0';
    
    for i in 0 to satellite-1 loop
        --!PRIMA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"A00000FFF597";
        
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!SECONDA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"500000FFF797";
        
        
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!TERZA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"000000FFF998";
        
        
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!QUARTA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"B00000FFFB98";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!QUINTA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"600000FFFD99";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!SESTA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"100000FFFF99";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!SETTIMA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"C0000000019A";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!OTTAVA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"70000000039B";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!NONA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"20000000059B";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!DECIMA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"D0000000079C";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
        
        --!UNDICESIMA DOPPLER
        valid_in <= '1';
        poff_pinc <= x"80000000099C";
              
        wait for clock_period;
        valid_in <= '0';
        wait until dds_done = '1';
        wait for clock_period*10;
    end loop;
    
    wait;
    end process;
    
    
    --SCRITTURA SUL FILE
    file_sig1_out <= to_bitvector(fft1_out_sig);
    file_sig2_out <= to_bitvector(fft2_out_sig); 
    file_ifft_out <= to_bitvector(ifft_out_sig);
    
    --write process
    writing : process
       file      outfilesig1  : text is out "fft1_out.txt";
       file      outfilesig2  : text is out "fft2_out.txt";
       file      outfileifft  : text is out "ifft_out.txt";
       variable  outlinesig1  : line;     
       variable  outlinesig2  : line;     
       variable  outlineifft  : line;     

   begin
   wait until falling_edge(clock);
       
   if(endoffile='0') then   --if the file end is not reached.
                  
          --write(linenumber,value(real type),justified(side),field(width),digits(natural));
          write(outlinesig1,file_sig1_out,right,32);
          writeline(outfilesig1, outlinesig1);
          
          write(outlinesig2,file_sig2_out,right,32);
          writeline(outfilesig2, outlinesig2);
          
          write(outlineifft,file_ifft_out,right,32);
          writeline(outfileifft, outlineifft);
                                                                                      
          linenumber <= linenumber + 1;
  
   end if;
end process writing;

end Behavioral;
