library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component reg is
	GENERIC ( k : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			clk : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			ldHigh, ldLow : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--reset : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  signal dbus : std_logic_vector(15 downto 0) := X"0000";
  
  signal clk,ld,ldHigh, ldLow   : std_logic := '0';

begin
  
  regA : reg port map (
    clk,
	ld,
	ldHigh,
	ldLow,
	sbus,
	dbus 
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
    file inputFile : text open read_mode is "testReg.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      ld <= tempBit;
      read(inline, tempBit);
      ldHigh <= tempBit;
      read(inline, tempBit);
      ldLow <= tempBit;
      hread(inline, tempVector);
      sbus <= tempVector;
      wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;