library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component mx2to1 is
	GENERIC ( num : INTEGER := 3 ) ;
	PORT ( 
			--input ports
			d0, d1 : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			sel : IN STD_LOGIC ;
			
			--reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
  end component;
  
  signal d0,d1 : std_logic_vector(15 downto 0) := X"0000";
  signal dbus : std_logic_vector(15 downto 0) := X"0000";

  signal sel,clk : std_logic := '0';

begin
  
  mx : mx2to1 
	GENERIC MAP(16)
	port map (
		d0,d1,sel,dbus
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
    file inputFile : text open read_mode is "testMx.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
	read(inline, tempBit);
	sel  <= tempBit;
      hread(inline, tempVector);
      d0 <= tempVector;
	hread(inline, tempVector);
      d1 <= tempVector;
	wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;