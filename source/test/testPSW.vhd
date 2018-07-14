library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component psw is
	GENERIC ( k : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			clk : IN STD_LOGIC ;
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout : IN STD_LOGIC ;
			
			
			reset : IN STD_LOGIC ;
			
			--INOUT ports
			pswl0, pswl1, i, t  : INOUT STD_LOGIC;
			sBus : INOUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  
  signal clk,
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout, pswl0, pswl1, i,t : std_logic := '0';

begin
  
  regpsw : psw port map (
    			clk,
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout,
			'0',
			pswl0, pswl1, i,t,
			sbus
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
    file inputFile : text open read_mode is "testPSW.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      ldL <= tempBit;
      read(inline, tempBit);
      ldPSW <= tempBit;
      read(inline, tempBit);
      prl0 <= tempBit;
      read(inline, tempBit);
      prl1 <= tempBit;
      read(inline, tempBit);
      setI <= tempBit;
      read(inline, tempBit);
      resetI <= tempBit;
      read(inline, tempBit);
      setT <= tempBit;
      read(inline, tempBit);
      resetT <= tempBit;
	read(inline, tempBit);
	ldPSWalu  <= tempBit;
	read(inline, tempBit);
	n  <= tempBit;
	read(inline, tempBit);
	z  <= tempBit;
	read(inline, tempBit);
	c  <= tempBit;
	read(inline, tempBit);
	v  <= tempBit;
	read(inline, tempBit);
	PSWout  <= tempBit;
	if(tempBit = '0') then 
		hread(inline, tempVector);
		sbus <= tempVector;
	end if;

      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;