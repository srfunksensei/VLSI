library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component cntrl_unit1 is
	GENERIC( num : INTEGER := 8 );
	PORT ( 
			--input ports
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd  : IN STD_LOGIC ;
			
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed  : IN STD_LOGIC ;
			
			val00, val0e, val19, val34, val3b, 
			val92, val98, val9a, val9b : IN STD_LOGIC ;
			
			run, brop, bradr, branch, halt : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			cnt_out : OUT STD_LOGIC_VECTOR (num-1 DOWNTO 0)
			
			);
  end component;
  
	signal cnt_out : STD_LOGIC_VECTOR (7 DOWNTO 0);


  signal movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed,
			
			val00, val0e, val19, val34, val3b, 
			val92, val98, val9a, val9b,
			
			run, brop, bradr, branch, halt,
			reset, clk : std_logic := '0';

begin
  
  cntrl : cntrl_unit1 port map (
    movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed,
			
			val00, val0e, val19, val34, val3b, 
			val92, val98, val9a, val9b,
			
			run, brop, bradr, branch, halt,
			reset, clk ,
			cnt_out
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
    
    file inputFile : text open read_mode is "testCntrl1.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      movs <= tempBit;
      read(inline, tempBit);
      movd <= tempBit;
      read(inline, tempBit);
      add <= tempBit;
      read(inline, tempBit);
      andi <= tempBit;
      read(inline, tempBit);
      asr <= tempBit;
      read(inline, tempBit);
      bnz <= tempBit;
      read(inline, tempBit);
      jsr <= tempBit;
      read(inline, tempBit);
      jmp <= tempBit;
      read(inline, tempBit);
      jmpind <= tempBit;
	read(inline, tempBit);
	rti  <= tempBit;
	read(inline, tempBit);
	rts  <= tempBit;
      read(inline, tempBit);
	int  <= tempBit;
	read(inline, tempBit);
	push  <= tempBit;
	read(inline, tempBit);
	pop  <= tempBit;			
	read(inline, tempBit);
	inc  <= tempBit;
read(inline, tempBit);
	dec  <= tempBit;
read(inline, tempBit);
	inte  <= tempBit;
read(inline, tempBit);
	intd  <= tempBit;
read(inline, tempBit);
	trpe  <= tempBit;
read(inline, tempBit);
	trpd  <= tempBit;
read(inline, tempBit);
	regdir  <= tempBit;
read(inline, tempBit);
	regind  <= tempBit;
read(inline, tempBit);
	indregpom  <= tempBit;
read(inline, tempBit);
	 dirmem  <= tempBit;
read(inline, tempBit);
	indmem  <= tempBit;
read(inline, tempBit);
	rel  <= tempBit;
read(inline, tempBit);
	immed  <= tempBit;
read(inline, tempBit);
	val00  <= tempBit;
read(inline, tempBit);
	val0e  <= tempBit;
read(inline, tempBit);
	val19  <= tempBit;
read(inline, tempBit);
	val34  <= tempBit;
read(inline, tempBit);
	val3b  <= tempBit;
read(inline, tempBit);
	val92  <= tempBit;
read(inline, tempBit);
	val98  <= tempBit;
read(inline, tempBit);
	val9a  <= tempBit;
read(inline, tempBit);
	val9b  <= tempBit;
read(inline, tempBit);
	run  <= tempBit;
read(inline, tempBit);
	brop  <= tempBit;
read(inline, tempBit);
	bradr  <= tempBit;
read(inline, tempBit);
	branch  <= tempBit;
read(inline, tempBit);
	halt  <= tempBit;

      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;