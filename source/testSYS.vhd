library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.txt_util.all;

entity testSYS is
end testSYS;

architecture test of testSYS is
  
  component memory is
	generic ( num : integer := 16;
			len : integer := 8
			);
	port (
		clk :   in  std_logic;
		clear : in std_logic;
		abus :  in  std_logic_vector(num-1 downto 0);
		dbus :  inout std_logic_vector(len-1 downto 0);
		rdbus :  in std_logic;
		wrbus:  in std_logic
	);
  end component;
  
  component CPU
  GENERIC (num : INTEGER := 16;
			 len : INTEGER := 8
			) ;
	PORT ( 
			--input ports
			reset, Clock,
			intr1, intr2, intr3, intn : IN STD_LOGIC;
			
			--in/out ports
			ABUS : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			DBUS : INOUT STD_LOGIC_VECTOR(len-1 DOWNTO 0);
			
			inta1, inta2, inta3 : INOUT STD_LOGIC;
			
			--out ports
			RDBUS, WRBUS : OUT STD_LOGIC
						
			);
	end component;
  
	signal ABUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL DBUS : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal reset, clk,inta1, inta2, inta3  : std_logic := '0';
  signal RDBUS, WRBUS : std_logic := 'Z';

begin
  
  mm : memory port map (
   
			clk,reset,
			
			ABUS,
			DBUS,
			
			
			RDBUS, WRBUS
  );
  
  ccpu : CPU port map(
		reset, clk, '0', '0', '0', '0', ABUS, DBUS, inta1, inta2, inta3, RDBUS, WRBUS
	);
  
 
clock11 : process is
  begin
    clk <= '1';
    wait for 0.5 ns;
    clk <= '0';
    wait for 0.5 ns;
  end process;

end architecture;