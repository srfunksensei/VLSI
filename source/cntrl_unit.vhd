--##########################
--
--	author: Milan Brankovic
--
--	file: cntrl_unit.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY cntrl_unit IS
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
END cntrl_unit ;

ARCHITECTURE Behavior OF cntrl_unit IS
	SIGNAL cnt_out : STD_LOGIC_VECTOR (num-1 DOWNTO 0) := X"00";
	SIGNAL val00, val0e, val19, val34, val3b, 
			val92, val98, val9a, val9b,
			brop, bradr, branch : STD_LOGIC := '0';
	
	
	COMPONENT cntrl_unit1 
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
	END COMPONENT ;
	
	COMPONENT cntrl_unit2 
		GENERIC( num : INTEGER := 8 );
		PORT ( 
			--input ports
			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop  : IN STD_LOGIC ;
						
			cnt_out : IN STD_LOGIC_VECTOR (num-1 DOWNTO 0);
			
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
	END COMPONENT ;

BEGIN
	cntrl1 : ENTITY WORK.cntrl_unit1(behavior)
	PORT MAP(
			--input ports
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed,
			
			val00, val0e, val19, val34, val3b, 
			val92, val98, val9a, val9b,
			
			run, brop, bradr, branch, halt,
			
			reset, Clock,
			
			--output ports
			cnt_out
	);
	
	cntrl2 : ENTITY WORK.cntrl_unit2(behavior)
	PORT MAP(
			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			brnotprekid, erradr, errop,
						
			cnt_out,
			
			brop, bradr, branch,
			val00, val0e, val19, val34, val3b, val92, val98, val9a, val9b,
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, addo, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andio, asro, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inco, deco, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout
	);
	
END Behavior ;