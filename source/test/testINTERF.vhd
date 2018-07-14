library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component mar_mbr is
	GENERIC ( num : INTEGER := 16;
			  len : INTEGER := 8
			) ;
	PORT ( 
			--input ports
			incmar, decmar, ldmar,
			marout, marout1, busHold,
			mbrhigh, mxmbr, 
			ldmbr, 
			mbrout, wr : IN STD_LOGIC ;
			
			sBus : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			ABUS, dBus_intern : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			
			--inout ports
			DBUS : INOUT  STD_LOGIC_VECTOR(len-1 DOWNTO 0)
			
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  signal dbus_i, ABUS : std_logic_vector(15 downto 0) := X"0000";
  signal DBUS: std_logic_vector(7 downto 0) := X"00";  


  signal incmar, decmar, ldmar,
			marout, marout1, busHold,
			mbrhigh, mxmbr, 
			ldmbr, 
			mbrout, wr, reset, clk  : std_logic := '0';

begin
  
  interf : mar_mbr port map (
    --input ports
			incmar, decmar, ldmar,
			marout, marout1, busHold,
			mbrhigh, mxmbr, 
			ldmbr, 
			mbrout, wr,
			
			sBus,
			
			reset, clk,
			
			--output ports
			ABUS, dbus_i,
			
			--inout ports
			DBUS
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
    variable tempVector1 : std_logic_vector (7 downto 0);
    file inputFile : text open read_mode is "testINTERF.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      incmar <= tempBit;
      read(inline, tempBit);
      decmar <= tempBit;
      read(inline, tempBit);
      ldmar <= tempBit;
      read(inline, tempBit);
      marout <= tempBit;
      read(inline, tempBit);
      marout1 <= tempBit;
      read(inline, tempBit);
      busHold <= tempBit;
      read(inline, tempBit);
      mbrhigh <= tempBit;
      read(inline, tempBit);
      mxmbr <= tempBit;
      read(inline, tempBit);
      ldmbr <= tempBit;
	read(inline, tempBit);
	mbrout  <= tempBit;
	read(inline, tempBit);
	wr  <= tempBit;
      hread(inline, tempVector);
      sbus <= tempVector;
	hread(inline, tempVector1);
      DBUS <= tempVector1;
      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;