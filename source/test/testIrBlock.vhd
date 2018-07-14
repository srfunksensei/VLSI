library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component ir is
	GENERIC ( num : INTEGER := 16 ) ;
    PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			ldir1, ldir2, ldir3, ldir4 : IN STD_LOGIC ; 
			ir2out, ir3out, irjaout, irdaout : IN STD_LOGIC ; 
			
			Reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
				--operations
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd  : OUT STD_LOGIC ;
			
				--address ways
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed  : OUT STD_LOGIC
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  signal dbus : std_logic_vector(15 downto 0) := X"0000";
  
  signal ldir1, ldir2, ldir3, ldir4,
	ir2out, ir3out, irjaout, irdaout, 
	Reset, clk, 
	movs, movd, add, andi, asr, bnz, jsr,
	jmp, jmpind, rti, rts, int, push, pop, 
	inc, dec, inte, intd, trpe, trpd,
	regdir, regind, indregpom, dirmem,
	indmem, rel, immed  : std_logic := '0';

begin
  
  irBlock : ir port map (
    sbus, 
	ldir1, ldir2, ldir3, ldir4,
	ir2out, ir3out, irjaout, irdaout, 
	Reset, clk, 
	dbus,
	movs, movd, add, andi, asr, bnz, jsr,
	jmp, jmpind, rti, rts, int, push, pop, 
	inc, dec, inte, intd, trpe, trpd,
	regdir, regind, indregpom, dirmem,
	indmem, rel, immed  
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
    file inputFile : text open read_mode is "testIrBlock.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      ldir1 <= tempBit;
      read(inline, tempBit);
      ldir2 <= tempBit;
      read(inline, tempBit);
      ldir3 <= tempBit;
      read(inline, tempBit);
      ldir4 <= tempBit;
      read(inline, tempBit);
      ir2out <= tempBit;
      read(inline, tempBit);
      ir3out <= tempBit;
      read(inline, tempBit);
      irjaout <= tempBit;
      read(inline, tempBit);
      irdaout <= tempBit;
      hread(inline, tempVector);
      sbus <= tempVector;
      wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;