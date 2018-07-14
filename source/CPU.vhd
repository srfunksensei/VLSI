--##########################
--
--	author: Milan Brankovic
--
--	file: CPU.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY CPU IS
	GENERIC (num : INTEGER := 16;
			 len : INTEGER := 8
			) ;
	PORT ( 
			--input ports
			reset, Clock,
			intr1, intr2, intr3, intn : IN STD_LOGIC;
			
			--bus
			ABUS : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			DBUS : INOUT STD_LOGIC_VECTOR(len-1 DOWNTO 0);
			
			inta1, inta2, inta3 : INOUT STD_LOGIC;
			
			--out ports
			RDBUS, WRBUS : OUT STD_LOGIC
						
			);
END CPU ;

ARCHITECTURE Behavior OF CPU IS
	SIGNAL ir2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
	SIGNAL 
		sBus, dBus_i : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
			
	SIGNAL l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			erradr, errop, 
			
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd, 
			
			regind, indregpom, dirmem,
			indmem, rel,
			
			run, busy, halt, 
			
			setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			pswl0, pswl1, pswi, pswt, prekid, prl0, prl1,
			
			n,z,c,v, 
			
			ldivtp,upldsp,ldL, 
			
			--output ports
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, addo, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andio, asro, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inco, deco, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout : STD_LOGIC := '0';
	
	COMPONENT interupts
		GENERIC( num : INTEGER := 16;
			 len : INTEGER := 8
			);
		PORT ( 
			--input ports
			setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			intr1, intr2, intr3,
			intack, 
			pswl0, pswl1, pswi,
			setint, setcod, setadr, setnmi, resetf, 
			ldivtp, ldbr, pswt,
			ivtpout, brout : IN STD_LOGIC ;
			
			dBus : IN STD_LOGIC_VECTOR (num-1 DOWNTO 0) ;
			ir2 : IN STD_LOGIC_VECTOR (len-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			prekid  : OUT STD_LOGIC;
			sBus : OUT STD_LOGIC_VECTOR (num-1 DOWNTO 0);
			
			inta1, inta2, inta3,prl0, prl1, ldL : INOUT STD_LOGIC
						
			);
	END COMPONENT;
	
	COMPONENT interface
		GENERIC (num : INTEGER := 16;
			 len : INTEGER := 8
			) ;
		PORT ( 
			--input ports
			sBus : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			
			readi, wr,  
			incmar, decmar, ldmar,
			marout, 
			mbrhigh, mxmbr, 
			ldmbr, 
			mbrout : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			
			--output ports
			run, busy : OUT STD_LOGIC;
			rdbus, wrbus: OUT STD_LOGIC;
			
			ABUS, dBus_intern : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			
			--inout ports
			DBUS : INOUT  STD_LOGIC_VECTOR(len-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT registers
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
			
				--halt
			halt  : OUT STD_LOGIC;
			
			ir2 : OUT STD_LOGIC_VECTOR(num/2-1 DOWNTO 0);
			
			--INOUT
			pswl0, pswl1, i, t, no, zo, co, vo : INOUT STD_LOGIC

			);
	END COMPONENT;
	
	COMPONENT alu
		GENERIC ( num : INTEGER := 16 ) ;
		PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			trans, add, inc, dec, andi, asr, sl : IN STD_LOGIC ;
			
			ldx, ldy, aluout : IN STD_LOGIC ; 
			
			Reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			n,z,c,v : OUT STD_LOGIC
			);
	END COMPONENT;
	
	COMPONENT cntrl_unit
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
	END COMPONENT;
	
	
BEGIN

	inter : ENTITY WORK.interupts(behavior)
	PORT MAP( 
			--input ports
			setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			intr1, intr2, intr3,
			intack, 
			pswl0, pswl1, pswi,
			setint, setcod, setadr, intn, resetf, 
			ldivtp, ldbr, pswt,
			ivtpout, brout, 
			
			dBus_i, 
			ir2, 
			
			reset, Clock, 
			
			--output ports
			prekid,
			sBus,
			
			inta1, inta2, inta3,prl0, prl1, ldL
						
			);
			
	inf : ENTITY WORK.interface(behavior)
	PORT MAP( 
			--input ports
			sBus,
			
			
			rd, wr,  
			incmar, decmar, ldmar,
			marout, 
			mbrhigh, mxmbr, 
			ldmbr, 
			mbrout,
			
			reset, Clock,
			
			
			--output ports
			run, busy,
			RDBUS, WRBUS,
			
			ABUS, dBus_i,
			
			--inout ports
			DBUS
			);
			
	regis : ENTITY WORK.registers(behavior)
	PORT MAP( 
			--inOUT ports
			sBus,
			dBus_i,
			
			--input ports
			fdo, fvo, dareg, regout, ldreg,
			upldsp, upspout,
			incsp, decsp,
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda, pcout, bout, aout,
			ldL, ldpsw, prl0, prl1, 
			seti, reseti, sett, resett,
			ldpswalu, n,z,c,v, 
			pswout,
			ldir1, ldir2, ldir3, ldir4,
			ir2out, ir3out, irjaout, irdaout,
			
			reset, Clock,
			
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
			
			halt,
			
			ir2, 
			
			pswl0, pswl1, pswi, pswt

			);
	
	op : ENTITY WORK.alu(behavior)
	PORT MAP ( 
			--input ports
			sBus,
			trans, addo, inco, deco, andio, asro, shl,
			
			ldx, ldy, aluout,
			
			reset, Clock,
			
			--output ports
			dBus_i,
			n,z,c,v
			);
	
	cntrlu : ENTITY WORK.cntrl_unit(behavior)
	PORT MAP ( 
			--input ports
			l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z,
			prekid, erradr, errop,
			
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
			regind, indregpom, dirmem,
			indmem, rel,
			--immed and regdir are in first section of input ports
			
			run, halt,
			
			
			reset, Clock,
			
			--output ports
			resetf, pcout, ldmar, rd, ldmbr, incpc, mbrout, ldir1, incmar,
			ldir2, ldir3, ldir4, regout, ldblow, ldbhigh, fdo, dsout, ldx,
			ir3out, ldy, addo, aluout, irdaout, bout, sdout, setcod, dareg,
			ldreg, trans, ldpswalu, andio, asro, ir2out, ldpchigh, ldpclow,
			decsp, mxmbr, upspout, wr, mbrhigh, irjaout, incsp, ldpsw, 
			setint, lda, aout, inco, deco, seti, reseti, sett, resett, decmar, 
			fvo, setadr, ldbr, intack, pswout, brout, shl, ivtpout, marout
			
			);
			
--	PROCESS (dsout, sdout, dBus_i, sBus ) IS
--	BEGIN
--		IF ( dsout = '1') THEN
--			sBus <= dBus_i;
--		ELSE
--			sBus <= sBus; --(OTHERS => 'Z');
--		END IF;
--		
--		IF (sdout = '1') THEN
--			dBus_i <= sBus;
--		ELSE
--			dBus_i <= dBus_i; --(OTHERS => 'Z');
--		END IF;
--	END PROCESS;

	sBus <= dBus_i WHEN dsout = '1'
			ELSE "ZZZZZZZZZZZZZZZZ";
	dBus_i <= sBus WHEN sdout = '1'
			ELSE "ZZZZZZZZZZZZZZZZ";
	
	movd_pop <= movd OR pop;
	imm_regdir <= immed OR regdir;


END Behavior ;