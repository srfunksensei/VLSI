library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component cntrl_unit2 is
	GENERIC( num : INTEGER := 8 );
	PORT ( 
			--input ports
			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop  : IN STD_LOGIC ;
						
			cnt_out : IN STD_LOGIC_VECTOR (num-1 DOWNTO 0);
			
			--reset, Clock : IN STD_LOGIC ;
			
			--output ports
			brop, bradr, branch,
			val00, val0e, val19, val34, val3b, val92, val98, val9c, val9d,
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, add, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andi, asr, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inc, dec, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout : OUT STD_LOGIC
						
			);
  end component;
  
  signal cnt_out : STD_LOGIC_VECTOR (7 DOWNTO 0);

  signal l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop ,
			brop, bradr, branch,
			val00, val0e, val19, val34, val3b, val92, val98, val9c, val9d,
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, add, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andi, asr, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inc, dec, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout  : std_logic := '0';

begin
  
  cnntrl2 : cntrl_unit2 port map (
   --input ports
			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop,
						
			cnt_out,
			
			--reset, Clock : IN STD_LOGIC ;
			
			--output ports
			brop, bradr, branch,
			val00, val0e, val19, val34, val3b, val92, val98, val9c, val9d,
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, add, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andi, asr, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inc, dec, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout
  );
  
 
  stimulus : process is
    variable inline : line;
    variable tempBit : std_logic;
    variable tempVector : std_logic_vector (7 downto 0);

    file inputFile : text open read_mode is "testCntrl2.txt";
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
	hread(inline, tempVector);
      cnt_out <= tempVector;

      
      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;