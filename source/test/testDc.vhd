library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component dc is
	GENERIC ( k : INTEGER := 3 ) ;
	PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			e : IN STD_LOGIC;
			
			--reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(2*k+1 DOWNTO 0)
			);
  end component;
  
  signal sbus : std_logic_vector(2 downto 0);
  signal dbus : std_logic_vector(7 downto 0);

  signal sel,clk : std_logic := '0';

begin
  
  mx : dc 
	port map (
		sbus,clk,dbus
      );
  
  clock : process is
  begin
    clk <= '1';
    wait for 0.5 ns;
    clk <= '0';
    wait for 0.5 ns;
  end process;
    
  stimulus : process is
    variable inline : line;
    variable tempBit : std_logic;
    variable tempVector : std_logic_vector (15 downto 0);
    file inputFile : text open read_mode is "testDc.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      hread(inline, tempVector);
      sbus <= tempVector(2 downto 0); 
	wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;