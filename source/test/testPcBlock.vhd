library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component pcab is
	GENERIC ( num : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda,
			pcout, bout, aout : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output,a,b,pc_v : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  signal dbus : std_logic_vector(15 downto 0) := X"0000";
  signal a,b,pc_v : std_logic_vector(15 downto 0) := X"0000";

  signal ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda,
			pcout, bout, aout,
	reset, clk  : std_logic := '0';

begin
  
  pcBlock : pcab port map (
    ldpchigh, ldpclow, incpc,
	ldbhigh, ldblow,
	lda,
	pcout, bout, aout,
	sbus,
	reset, clk,
	dbus,
	a,b,pc_v
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
    file inputFile : text open read_mode is "testPcBlock.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      ldpchigh <= tempBit;
      read(inline, tempBit);
      ldpclow <= tempBit;
      read(inline, tempBit);
      incpc <= tempBit;
      read(inline, tempBit);
      ldbhigh <= tempBit;
      read(inline, tempBit);
      ldblow <= tempBit;
      read(inline, tempBit);
      lda <= tempBit;
      read(inline, tempBit);
      pcout <= tempBit;
      read(inline, tempBit);
      bout <= tempBit;
      read(inline, tempBit);
      aout <= tempBit;
      hread(inline, tempVector);
      sbus <= tempVector;
      wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;