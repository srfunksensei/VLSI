library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component prio is
	GENERIC( num : INTEGER := 3 );
	PORT ( 
			--input ports
			setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			intr1, intr2, intr3,
			intack, inta, 
			pswl0, pswl1, pswi : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			prper,prl0, prl1 : OUT STD_LOGIC;

			--input/output ports
			 inta1, inta2, inta3 : INOUT STD_LOGIC
						
			);
  end component;
  

  signal setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			intr1, intr2, intr3,
			intack, inta, 
			pswl0, pswl1, pswi, reset, clk,
			prper,prl0, prl1 ,inta1, inta2, inta3 : std_logic := '0';

begin
  
  P : prio port map (
    setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			intr1, intr2, intr3,
			intack, inta, 
			pswl0, pswl1, pswi, reset, clk,
			prper,prl0, prl1 , inta1, inta2, inta3   
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
    
    file inputFile : text open read_mode is "testPrio.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      setimr1 <= tempBit;
      read(inline, tempBit);
      setimr2 <= tempBit;
      read(inline, tempBit);
      setimr3 <= tempBit;
      read(inline, tempBit);
      resetimr1 <= tempBit;
      read(inline, tempBit);
      resetimr2 <= tempBit;
      read(inline, tempBit);
      resetimr3 <= tempBit;
      read(inline, tempBit);
      intr1 <= tempBit;
      read(inline, tempBit);
      intr2 <= tempBit;
      read(inline, tempBit);
      intr3 <= tempBit;
	read(inline, tempBit);
	intack  <= tempBit;
	read(inline, tempBit);
	inta  <= tempBit;
      read(inline, tempBit);
	pswl0  <= tempBit;
	read(inline, tempBit);
	pswl1  <= tempBit;
	read(inline, tempBit);
	pswi  <= tempBit;

      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;