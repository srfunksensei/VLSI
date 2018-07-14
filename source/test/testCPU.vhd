library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity testOp is
end testOp;

architecture test of testOp is
  
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
  SIGNAL RDBUS, WRBUS : STD_LOGIC := 'Z';

begin
  
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

  stimulus : process (RDBUS) is
  variable tempVector : std_logic_vector (7 downto 0);
  variable inline : line;
  file inputFile : text open read_mode is "testCPU.txt";
    begin
 
		if(RDBUS = '0')then
			readline(inputFile, inline);
			hread(inline, tempVector);
			DBUS <= tempVector;
		ELSE 
			DBUS <= (OTHERS => 'Z');
		end if;
  end process;

end architecture;