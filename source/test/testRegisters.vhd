library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component registers is
	GENERIC ( num : INTEGER := 16 ) ;
	PORT ( 
			--inOUT ports
			sBus : INOUT STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			dBus : inOUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			
			--input ports
			fdo, fvo, daREG, REGout, ldREG: IN STD_LOGIC ;
			upldSP, upSPout,
			inc_sp, dec_sp,
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda, pcout, bout, aout,
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout,
			ldir1, ldir2, ldir3, ldir4,
			ir2out, ir3out, irjaout, irdaout   : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			
			--output ports
			
				--operations
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd  : OUT STD_LOGIC ;
			
				--address ways
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed  : INOUT STD_LOGIC;
				
				--logical conditions
			l1, l2, l3, l4, l5  : OUT STD_LOGIC;
			
			ir2 : OUT STD_LOGIC_VECTOR(num/2-1 DOWNTO 0)
			);
  end component;
  
SIGNAL sBus, dBus : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ir2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
 
  signal 
			fdo, fvo, daREG, REGout, ldREG,
			upldSP, upSPout,
			inc_sp, dec_sp,
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda, pcout, bout, aout,
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout,
			ldir1, ldir2, ldir3, ldir4,
			ir2out, ir3out, irjaout, irdaout,
			
			reset, clk,
			
			
			--output ports
			
				--operations
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
				--address ways
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed,
				
				--logical conditions
			l1, l2, l3, l4, l5 : std_logic := '0';

begin
  
  REGS : registers port map (
   			--inOUT ports
			sBus,
			dBus,
			
			--input ports
			fdo, fvo, daREG, REGout, ldREG,
			upldSP, upSPout,
			inc_sp, dec_sp,
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda, pcout, bout, aout,
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout,
			ldir1, ldir2, ldir3, ldir4,
			ir2out, ir3out, irjaout, irdaout,
			
			reset, clk,
			
			
			--output ports
			
				--operations
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
				--address ways
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed,
				
				--logical conditions
			l1, l2, l3, l4, l5,
			
			ir2
  );
  
 
clock11 : process is
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
    variable cnt :integer := 0; 

    file inputFile : text open read_mode is "testRegisters.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      fdo<= tempBit;
      read(inline, tempBit);
      fvo <= tempBit;
      read(inline, tempBit);
      daREG <= tempBit;
      read(inline, tempBit);
      REGout <= tempBit;
      read(inline, tempBit);
      ldREG <= tempBit;
      read(inline, tempBit);
      upldSP <= tempBit;
      read(inline, tempBit);
      upSPout <= tempBit;
      read(inline, tempBit);
      inc_sp <= tempBit;
      read(inline, tempBit);
      dec_sp <= tempBit;
	read(inline, tempBit);
	ldpchigh  <= tempBit;
	read(inline, tempBit);
	ldpclow  <= tempBit;
	read(inline, tempBit);
	incpc  <= tempBit;
read(inline, tempBit);
	ldbhigh<= tempBit;
read(inline, tempBit);
	ldblow  <= tempBit;
read(inline, tempBit);
	lda  <= tempBit;
read(inline, tempBit);
	pcout <= tempBit;
read(inline, tempBit);
	bout  <= tempBit;
read(inline, tempBit);
	aout  <= tempBit;
read(inline, tempBit);
	ldL  <= tempBit;
read(inline, tempBit);
	ldPSW  <= tempBit;
read(inline, tempBit);
	prl0  <= tempBit;
read(inline, tempBit);
	prl1  <= tempBit;
read(inline, tempBit);
	setI  <= tempBit;
read(inline, tempBit);
	resetI  <= tempBit;
read(inline, tempBit);
	setT  <= tempBit;
read(inline, tempBit);
	resetT  <= tempBit;
read(inline, tempBit);
	ldPSWalu<= tempBit;
read(inline, tempBit);
	n<= tempBit;
read(inline, tempBit);
	z  <= tempBit;
read(inline, tempBit);
	c  <= tempBit;
read(inline, tempBit);
	v  <= tempBit;
read(inline, tempBit);
	PSWout  <= tempBit;
read(inline, tempBit);
	ldir1  <= tempBit;
read(inline, tempBit);
	ldir2 <= tempBit;
read(inline, tempBit);
	ldir3 <= tempBit;
read(inline, tempBit);
	ldir4  <= tempBit;
read(inline, tempBit);
	ir2out  <= tempBit;
read(inline, tempBit);
	ir3out  <= tempBit;
read(inline, tempBit);
	irjaout  <= tempBit;
read(inline, tempBit);
	irdaout  <= tempBit;

	if (cnt = 0 or cnt = 1 or cnt = 3) then
		hread(inline, tempVector);
      	sBus <= tempVector;
      	cnt := cnt + 1;
	end if;

	if (cnt = 5) then
		hread(inline, tempVector);
	      dBus <= tempVector;
	end if;
	
     
      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;