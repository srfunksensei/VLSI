library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component ivtp_br is
	GENERIC( num : INTEGER := 16;
			 len : INTEGER := 8
			);
	PORT ( 
			--input ports
			setint, setcod, setadr, setnmi, resetf, 
			intack,
			ldivtp, ldbr, 
			prper, pswt,
			prl0, prl1,
			ivtpout, brout : IN STD_LOGIC ;
			
			dBus : IN STD_LOGIC_VECTOR (num-1 DOWNTO 0) ;
			ir2 : IN STD_LOGIC_VECTOR (len-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			prekid, inta : OUT STD_LOGIC;
			sBus : OUT STD_LOGIC_VECTOR (num-1 DOWNTO 0)
		
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  signal dbus : std_logic_vector(15 downto 0) := X"0000";
  signal ir2 : std_logic_vector(7 downto 0) := X"00";

  signal setint, setcod, setadr, setnmi, resetf, 
			intack,
			ldivtp, ldbr, 
			prper, pswt,
			prl0, prl1,
			ivtpout, brout ,prekid, inta ,
			reset,clk : std_logic := '0';

begin
  
  int : ivtp_br port map (
    --input ports
			setint, setcod, setadr, setnmi, resetf, 
			intack,
			ldivtp, ldbr, 
			prper, pswt,
			prl0, prl1,
			ivtpout, brout,
			
			dBus,
			ir2,
			
			reset, clk,
			
			--output ports
			prekid, inta,
			sBus

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
    file inputFile : text open read_mode is "testInt.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      setint <= tempBit;
      read(inline, tempBit);
      setcod <= tempBit;
      read(inline, tempBit);
      setadr <= tempBit;
      read(inline, tempBit);
      setnmi <= tempBit;
      read(inline, tempBit);
      resetf <= tempBit;
      read(inline, tempBit);
      intack <= tempBit;
      read(inline, tempBit);
      ldivtp <= tempBit;
      read(inline, tempBit);
      ldbr <= tempBit;
      read(inline, tempBit);
      prper <= tempBit;
	read(inline, tempBit);
	pswt  <= tempBit;
	read(inline, tempBit);
	prl0  <= tempBit;
	read(inline, tempBit);
	prl1  <= tempBit;
	read(inline, tempBit);
	ivtpout  <= tempBit;
	read(inline, tempBit);
	brout  <= tempBit;
	hread(inline, tempVector);
      dbus <= tempVector;
	hread(inline, tempVector);
      ir2 <= tempVector(7 DOWNTO 0);

      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;