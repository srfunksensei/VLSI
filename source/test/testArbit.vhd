library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component arbit is
	PORT ( 
			--input ports
			brqStart, brqStop : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			busHold, busy : OUT STD_LOGIC
			
			);
  end component;
  
   signal brqStart, brqStop , reset, clk, busHold, busy   : std_logic := '0';

begin
  
  a : arbit port map (
    --input ports
			brqStart, brqStop,
			
			reset, clk,
			
			--output ports
			busHold, busy
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
    file inputFile : text open read_mode is "testArbit.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      brqStart  <= tempBit;
      read(inline, tempBit);
      brqStop <= tempBit;
      
      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;