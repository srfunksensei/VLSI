--##########################
--
--	author: Milan Brankovic
--
--	file: registers.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY registers IS
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
			halt : OUT STD_LOGIC; 
			
			ir2 : OUT STD_LOGIC_VECTOR(num/2-1 DOWNTO 0);
			
			--INOUT
			pswl0, pswl1, i, t : INOUT STD_LOGIC

			);
END registers;

ARCHITECTURE Behavior OF registers IS
	SIGNAL ldax, ldbx, ldcx, lddx,
			ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout,
			siout, diout, spout, bpout, 
			axsel, bxsel, cxsel, dxsel, 
			spsel, bpsel, sisel, disel,
			bxout2, bpout2, siout2, diout2 : STD_LOGIC := '0';
	SIGNAL bx, bp, si, di : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
	SIGNAL ir2_2_0, ir2_5_3 : STD_LOGIC_VECTOR(2 DOWNTO 0) := b"000";
	
	COMPONENT reg_sel
		GENERIC ( num : INTEGER := 16;
			  len : INTEGER := 3
			) ;
		PORT ( 
			--input ports
			regdir, fdo, fvo, daREG, REGout, 
			regind, regindpom, ldREG: IN STD_LOGIC ;
			bx, bp, si, di : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			upldSP, upSPout : IN STD_LOGIC;
			ir2_2_0, ir2_5_3 : IN STD_LOGIC_VECTOR(len-1 DOWNTO 0) ;
			
			--output ports
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp : OUT STD_LOGIC;
			axout, bxout, cxout, dxout, siout, diout, spout, bpout : OUT STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT reg_file
		GENERIC ( num : INTEGER := 16 ) ;
		PORT ( 
			--input ports
			ldax, ldbx, ldcx, lddx,
			ldsi, lddi, ldsp, ldbp : IN STD_LOGIC ;
			axout, bxout, cxout, dxout,
			siout, diout, spout, bpout : IN STD_LOGIC ;
			inc_sp, dec_sp : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			bx_reg, bp_reg, si_reg, di_reg : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT regPC_A_B
		GENERIC ( num : INTEGER := 16 ) ;
		PORT ( 
			--input ports
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda,
			pcout, bout, aout : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output  : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT psw
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
			pswl0, pswl1, i, t : INOUT STD_LOGIC;
			sBus : INOUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			
			);
	END COMPONENT;
	
	COMPONENT ir
		GENERIC ( num : INTEGER := 16 ) ;
		PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			ldir1, ldir2, ldir3, ldir4 : IN STD_LOGIC ; 
			ir2out, ir3out, irjaout, irdaout : IN STD_LOGIC ; 
			
			Reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			ir2_reg :  OUT STD_LOGIC_VECTOR(num/2-1 DOWNTO 0);
			ir2_2_0, ir2_5_3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			
				--operations
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd  : OUT STD_LOGIC ;
			
				--address ways
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed  : OUT STD_LOGIC;
			
				--logical conditions
			l1, l2, l3, l4, l5  : OUT STD_LOGIC;
			
				--halt
			halt : OUT STD_LOGIC
			);
	END COMPONENT;
	
BEGIN
	regFile : ENTITY WORK.reg_file(behavior)
	PORT MAP(
			ldax, ldbx, ldcx, lddx,
			ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout,
			siout, diout, spout, bpout,
			inc_sp, dec_sp,
			sBus,
			
			reset, Clock,
			
			--output ports
			dBus, 
			bx, bp, si,di
	);
	
	
	pcab : ENTITY WORK.regPC_A_B(behavior) 
	PORT MAP(
			--input ports
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda,
			pcout, bout, aout,
			dBus,
			
			reset, Clock,
			
			--output ports
			sBus
	);
	
	regSel : ENTITY WORK.reg_sel(behavior) 
	PORT MAP(
		--input ports
			regdir, fdo, fvo, daREG, REGout, 
			regind, indregpom, ldREG,
			bx, bp, si, di,
			upldSP, upSPout,
			ir2_2_0, ir2_5_3,
			
			--output ports
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout, siout, diout, spout, bpout,
			dBus
	);
	
	regIr : ENTITY WORK.ir(behavior) 
	PORT MAP(
			--input ports
			dBus,
			ldir1, ldir2, ldir3, ldir4,
			ir2out, ir3out, irjaout, irdaout,
			
			reset, Clock,
			
			--output ports
			sBus,
			ir2,
			ir2_2_0, ir2_5_3,
			
				--operations
			movs, movd, add, andi, asr, bnz, jsr,
			jmp, jmpind, rti, rts, int, push, pop, 
			inc, dec, inte, intd, trpe, trpd,
			
				--address ways
			regdir, regind, indregpom, dirmem,
			indmem, rel, immed,
			
				--logical conditions
			l1, l2, l3, l4, l5,
			
				--halt
			halt
	);
	
	regPSW : ENTITY WORK.psw(behavior) 
	PORT MAP(
			--input ports
			Clock,
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout,
			
			reset,
			
			--INOUT ports
			pswl0, pswl1, i, t,
			sBus
	);
	
	
END Behavior ;