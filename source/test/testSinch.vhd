library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component sinch is
	PORT ( 
			--input ports
			readi, wr, busHold : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			outp : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			rdbus, wrbus, brqStop, brqStart, marout1: OUT STD_LOGIC
			);
  end component;
  
  signal readi, wr, busHold , reset, clk, rdbus, wrbus, brqStop, brqStart, marout1   : std_logic := '0';
  SIGNAL outp : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0000";


begin
  
  s : sinch port map (
    --input ports
			readi, wr, busHold,
			
			reset, clk,
			
			--output ports
			outp,
			rdbus, wrbus, brqStop, brqStart, marout1
  );
  
  clock : process is
  begin
    clk <= '1';
    wait for 1 ns;
    clk <= '0';
    wait for 0.5 ns;
  end process;
    
  stimulus : process is
    variable inline : line;
    variable tempBit : std_logic;
    variable tempVector : std_logic_vector (15 downto 0);
    file inputFile : text open read_mode is "testSinch.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      readi<= tempBit;
      read(inline, tempBit);
      wr <= tempBit;
      read(inline, tempBit);
      busHold <= tempBit;
      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;