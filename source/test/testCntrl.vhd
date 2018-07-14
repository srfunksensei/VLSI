library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component cntrl_unit is
	GENERIC( num : INTEGER := 8 );
	PORT ( 
			--input ports
			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop  : IN STD_LOGIC ;
			
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd  : IN STD_LOGIC ;
			
			regind, indregpom, dirmem,
			indmem, rel : IN STD_LOGIC ;
			--immed and regdir are in first section of input ports
			
			run, halt : IN STD_LOGIC ;
			
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, addo, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andio, asro, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inco, deco, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout : OUT STD_LOGIC

			);
  end component;
  
SIGNAL cnt_o  : STD_LOGIC_VECTOR(7 DOWNTO 0);

 
  signal 
			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop,
			
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
			regind, indregpom, dirmem,
			indmem, rel,
			--immed and regdir are in first section of input ports
			
			run, halt,
			
			
			reset, clk,
			
			--output ports
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, addo, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andio, asro, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inco, deco, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout  : std_logic := '0';

begin
  
  cnntrl : cntrl_unit port map (
   			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop,
			
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
			regind, indregpom, dirmem,
			indmem, rel,
			--immed and regdir are in first section of input ports
			
			run, halt,
			
			
			reset, clk,
			
			--output ports
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, addo, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andio, asro, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inco, deco, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout
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
    
    file inputFile : text open read_mode is "testCntrl.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      l1<= tempBit;
      read(inline, tempBit);
      l2 <= tempBit;
      read(inline, tempBit);
      l3 <= tempBit;
      read(inline, tempBit);
      l4 <= tempBit;
      read(inline, tempBit);
      l5 <= tempBit;
      read(inline, tempBit);
      movd_pop <= tempBit;
      read(inline, tempBit);
      immed <= tempBit;
      read(inline, tempBit);
      regdir <= tempBit;
      read(inline, tempBit);
      imm_regdir <= tempBit;
	read(inline, tempBit);
	z  <= tempBit;
	read(inline, tempBit);
	brnotprekid  <= tempBit;
	read(inline, tempBit);
	movs  <= tempBit;
read(inline, tempBit);
	movd  <= tempBit;
read(inline, tempBit);
	add  <= tempBit;
read(inline, tempBit);
	andi  <= tempBit;
read(inline, tempBit);
	asr <= tempBit;
read(inline, tempBit);
	bnz  <= tempBit;
read(inline, tempBit);
	jsr  <= tempBit;
read(inline, tempBit);
	jmp  <= tempBit;
read(inline, tempBit);
	jmpind  <= tempBit;
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
	dec <= tempBit;
read(inline, tempBit);
	inte<= tempBit;
read(inline, tempBit);
	intd  <= tempBit;
read(inline, tempBit);
	trpe  <= tempBit;
read(inline, tempBit);
	trpd  <= tempBit;
read(inline, tempBit);
	regind  <= tempBit;
read(inline, tempBit);
	indregpom  <= tempBit;
read(inline, tempBit);
	dirmem <= tempBit;
read(inline, tempBit);
	indmem <= tempBit;
read(inline, tempBit);
	rel  <= tempBit;
read(inline, tempBit);
	run  <= tempBit;
read(inline, tempBit);
	halt  <= tempBit;
		
     
      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;