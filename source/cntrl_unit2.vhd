--##########################
--
--	author: Milan Brankovic
--
--	file: cntrl_unit2.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY cntrl_unit2 IS
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
END cntrl_unit2 ;

ARCHITECTURE Behavior OF cntrl_unit2 IS
SIGNAL xl1, xl2, xl3, xl4, xl5, 
			xmovd_pop, ximmed, xregdir, ximm_regdir, 
			xz, xbrnotprekid : STD_LOGIC := '0';
BEGIN
	PROCESS (cnt_out, l1, l2, l3, l4, l5, 
			movd_pop, immed, regdir, imm_regdir, 
			z, brnotprekid) IS
	VARIABLE bruncnd, brl1, brl2, brl3, brl4, brl5, 
		brmovd_pop, brimmed, brregdir, brregdir_immed, brz, brnotp : STD_LOGIC := '0';
	BEGIN	
		--conditions
		IF (cnt_out = X"0d" OR cnt_out = X"1A" OR cnt_out = X"1C" OR
					cnt_out = X"1E" OR cnt_out = X"22" OR cnt_out = X"24" OR cnt_out = X"2D" OR
					cnt_out = X"31" OR cnt_out = X"33" OR cnt_out = X"3d" OR cnt_out = X"40" OR
					cnt_out = X"44" OR cnt_out = X"48" OR cnt_out = X"4C" OR cnt_out = X"50" OR
					cnt_out = X"55" OR cnt_out = X"5d" OR cnt_out = X"60" OR cnt_out = X"6C" OR
					cnt_out = X"6E" OR cnt_out = X"75" OR cnt_out = X"81" OR cnt_out = X"85" OR
					cnt_out = X"89" OR cnt_out = X"8B" OR cnt_out = X"8d" OR cnt_out = X"8F" OR
					cnt_out = X"91" OR cnt_out = X"97" OR cnt_out = X"99" OR cnt_out = X"AF" )THEN 
			bruncnd := '1';
		ELSE bruncnd := '0';
		END IF;
		
		IF (cnt_out = X"04") THEN
			brl1 := '1';
		ELSE brl1 := '0';
		END IF;
		
		IF ( cnt_out = X"05" ) THEN
			brl2 := '1';
		ELSE brl2 := '0';
		END IF;
			
		IF (cnt_out = X"09" ) THEN
			brl3 := '1';
		ELSE brl3 := '0';
		END IF;
		
		IF (cnt_out = X"11") THEN
			brl4 := '1'; 
		ELSE brl4 := '0';
		END IF;
		
		IF ( cnt_out = X"15") THEN
			brl5 := '1';
		ELSE brl5 := '0';
		END IF;
		
		IF (cnt_out = X"34") THEN
			brmovd_pop := '1';
		ELSE brmovd_pop := '0';
		END IF;
		
		IF ( cnt_out = X"41" OR cnt_out = X"4D" 
				OR cnt_out = X"76" OR cnt_out = X"82" OR cnt_out = X"86") THEN
			brimmed := '1';
		ELSE brimmed := '0';
		END IF;
		
		IF (cnt_out = X"92") THEN
			brregdir := '1';
		ELSE brregdir := '0';
		END IF;
		
		IF ( cnt_out = X"5E") THEN
			brregdir_immed := '1';
		ELSE brregdir_immed := '0';
		END IF;
		
		IF ( cnt_out = X"51" ) THEN
			brz := '1';
		ELSE brz := '0';
		END IF;
		
		IF (cnt_out = X"9B") THEN
			brnotp := '1';
		ELSE brnotp := '0';
		END IF;
		
		IF (bruncnd = '1' OR (brl1 = '1' AND l1 = '1') OR (brl2 = '1' AND l2 = '1')
			OR (brl3 = '1' AND l3 = '1') OR (brl4 = '1' AND ((NOT l4) = '1')) OR (brl5 = '1' AND l5 = '1')
			OR (movd_pop = '1' AND brmovd_pop = '1') OR (immed = '1' AND brimmed = '1')
			OR (regdir = '1' AND brregdir = '1') OR (brregdir_immed = '1' AND imm_regdir = '1')
			OR (brz = '1' AND z = '1') OR (brnotprekid = '0' AND brnotp = '1')) THEN 
			branch <= '1';
		ELSE branch <= '0';
		END IF;
	END PROCESS;
	
	--out signals
	brop <= '1' WHEN cnt_out = X"3B" ELSE '0';
	bradr <= '1' WHEN cnt_out = X"19" ELSE '0';
	
	val00 <= '1' WHEN cnt_out = X"91" OR cnt_out = X"9B" OR cnt_out = X"AF" ELSE '0';
	val0e <= '1' WHEN cnt_out = X"04" ELSE '0';
	val19 <= '1' WHEN cnt_out = X"11" OR cnt_out = X"15" ELSE '0';
	val34 <= '1' WHEN cnt_out = X"1E" OR cnt_out = X"22" OR cnt_out = X"24"
			OR cnt_out = X"2D" OR cnt_out = X"31" ELSE '0';
	val3b <= '1' WHEN cnt_out = X"05" OR cnt_out = X"09" OR cnt_out = X"0D"
			OR cnt_out = X"1C" OR cnt_out = X"33" OR cnt_out = X"34" ELSE '0';
	val92 <= '1' WHEN cnt_out = X"44" OR cnt_out = X"50" OR cnt_out = X"81"
			OR cnt_out = X"85" OR cnt_out = X"89" ELSE '0';
	val98 <= '1' WHEN cnt_out = X"92" ELSE '0';
	val9c <= '1' WHEN cnt_out = X"1A" OR cnt_out = X"41" OR cnt_out = X"4D"
			OR cnt_out = X"5E" OR cnt_out = X"76" OR cnt_out = X"82" OR 
			cnt_out = X"86" ELSE '0';
	val9d <= '1' WHEN cnt_out = X"3d" OR cnt_out = X"40" OR cnt_out = X"48" OR
				cnt_out = X"4c" OR cnt_out = X"51" OR cnt_out = X"55" OR cnt_out = X"5d" OR
				cnt_out = X"60" OR cnt_out = X"6c" OR cnt_out = X"6e" OR cnt_out = X"75" OR
				cnt_out = X"8b" OR cnt_out = X"8d" OR cnt_out = X"8f" OR cnt_out = X"91" OR
				cnt_out = X"97" OR cnt_out = X"99" ELSE '0';
				
	--control signals
	resetf <= '1' WHEN cnt_out = X"00" ELSE '0';
	pcout <= '1' WHEN cnt_out = X"00" OR cnt_out = X"03" OR cnt_out = X"08" OR
				cnt_out = X"10" OR cnt_out = X"14" OR cnt_out = X"2e" OR cnt_out = X"52" OR
				cnt_out = X"56" OR cnt_out = X"5a" OR cnt_out = X"9c" OR cnt_out = X"a0" 
				ELSE '0';
	ldmar <= '1' WHEN cnt_out = X"00" OR cnt_out = X"03" OR cnt_out = X"08" OR
				cnt_out = X"10" OR cnt_out = X"14" OR cnt_out = X"1d" OR cnt_out = X"21" OR
				cnt_out = X"23" OR cnt_out = X"25" OR cnt_out = X"2c" OR cnt_out = X"30" OR
				cnt_out = X"57" OR cnt_out = X"59" OR cnt_out = X"61" OR cnt_out = X"65" OR
				cnt_out = X"67" OR cnt_out = X"70"  OR cnt_out = X"72" OR cnt_out = X"78" OR
				cnt_out = X"7a" OR cnt_out = X"7d"  OR cnt_out = X"9d" OR cnt_out = X"9f" OR
				cnt_out = X"a2" OR cnt_out = X"a8"
				ELSE '0';
	rd<= '1' WHEN cnt_out = X"01" OR cnt_out = X"06" OR cnt_out = X"0a" OR
				cnt_out = X"0e" OR cnt_out = X"12" OR cnt_out = X"16" OR cnt_out = X"26" OR
				cnt_out = X"29" OR cnt_out = X"35" OR cnt_out = X"38" OR cnt_out = X"62" OR
				cnt_out = X"66" OR cnt_out = X"69" OR cnt_out = X"79" OR cnt_out = X"7C" OR
				cnt_out = X"A9" OR cnt_out = X"AC" 
				ELSE '0';
	ldmbr <= '1' WHEN cnt_out = X"02" OR cnt_out = X"07" OR cnt_out = X"0B" OR
				cnt_out = X"0F" OR cnt_out = X"13" OR cnt_out = X"17" OR cnt_out = X"27" OR
				cnt_out = X"2A" OR cnt_out = X"36" OR cnt_out = X"39" OR cnt_out = X"56" OR
				cnt_out = X"5A" OR cnt_out = X"63" OR cnt_out = X"67" OR cnt_out = X"6A" OR
				cnt_out = X"6F" OR cnt_out = X"73" OR cnt_out = X"7A" OR cnt_out = X"7D" OR
				cnt_out = X"93" OR cnt_out = X"95" OR cnt_out = X"9C" OR cnt_out = X"A0" OR
				cnt_out = X"a3" OR cnt_out = X"aA" OR cnt_out = X"aD"
				ELSE '0';
	incpc <= '1' WHEN cnt_out = X"02" OR cnt_out = X"07" OR cnt_out = X"0B" OR
				cnt_out = X"0F" OR cnt_out = X"13" OR cnt_out = X"17"
				ELSE '0';
	mbrout <= '1' WHEN cnt_out = X"03" OR cnt_out = X"08" OR cnt_out = X"0C" OR
				cnt_out = X"10" OR cnt_out = X"14" OR cnt_out = X"18" OR cnt_out = X"28" OR
				cnt_out = X"2B" OR cnt_out = X"37" OR cnt_out = X"3A" OR cnt_out = X"64" OR
				cnt_out = X"68" OR cnt_out = X"6B" OR cnt_out = X"7B" OR cnt_out = X"7E" OR
				cnt_out = X"AB" OR cnt_out = X"AE"
				ELSE '0';
	ldir1 <= '1' WHEN cnt_out = X"03" ELSE '0';
	incmar <= '1' WHEN cnt_out = X"27" OR cnt_out = X"36" OR cnt_out = X"AB" 
				ELSE '0';
	ldir2 <= '1' WHEN cnt_out = X"08" OR cnt_out = X"10"
				ELSE '0';
	ldir3 <= '1' WHEN cnt_out = X"0C" OR cnt_out = X"14"
				ELSE '0';
	ldir4 <= '1' WHEN cnt_out = X"18" ELSE '0';
	regout <= '1' WHEN cnt_out = X"1B" OR cnt_out = X"1D" OR cnt_out = X"1F" OR
				cnt_out = X"42" OR cnt_out = X"45" OR cnt_out = X"49" 
				ELSE '0';
	ldblow <= '1' WHEN cnt_out = X"1B" OR cnt_out = X"2B" OR cnt_out = X"32" OR
				cnt_out = X"3A" OR cnt_out = X"42" OR cnt_out = X"4F" OR
				cnt_out = X"7E" OR cnt_out = X"84" OR cnt_out = X"88" 
				ELSE '0';
	ldbhigh <= '1' WHEN cnt_out = X"1B" OR cnt_out = X"28" OR cnt_out = X"32" OR
				cnt_out = X"37" OR cnt_out = X"42" OR cnt_out = X"4F" OR
				cnt_out = X"7B" OR cnt_out = X"84" OR cnt_out = X"88" 
				ELSE '0';
	fdo <= '1' WHEN cnt_out = X"1B" OR cnt_out = X"1D" OR cnt_out = X"1F" 
				ELSE '0';
	dsout <= '1' WHEN cnt_out = X"1D" OR cnt_out = X"1F" OR cnt_out = X"21" OR
				cnt_out = X"30" OR cnt_out = X"42" OR cnt_out = X"45" OR cnt_out = X"47" OR
				cnt_out = X"49" OR cnt_out = X"4B" OR cnt_out = X"57" OR cnt_out = X"59" OR
				cnt_out = X"61" OR cnt_out = X"65" OR cnt_out = X"67" OR cnt_out = X"70" OR
				cnt_out = X"72" OR cnt_out = X"78" OR cnt_out = X"7A" OR cnt_out = X"9D" OR
				cnt_out = X"9F" OR cnt_out = X"A2" OR cnt_out = X"A6" OR cnt_out = X"A8"
				ELSE '0';
	ldx <= '1' WHEN cnt_out = X"1F" OR cnt_out = X"2E" OR cnt_out = X"3E" OR
				cnt_out = X"42" OR cnt_out = X"45" OR cnt_out = X"49" OR
				cnt_out = X"4E" OR cnt_out = X"52" OR cnt_out = X"7F" OR
				cnt_out = X"83" OR cnt_out = X"87" OR cnt_out = X"A5" OR
				cnt_out = X"A6" 
				ELSE '0';
	ir3out <= '1' WHEN cnt_out = X"20" OR cnt_out = X"2F" 
				ELSE '0';
	ldy <= '1' WHEN cnt_out = X"20" OR cnt_out = X"2F" OR cnt_out = X"46" OR
				cnt_out = X"4A" OR cnt_out = X"53" OR cnt_out = X"A7" 
				ELSE '0';
	add <= '1' WHEN cnt_out = X"21" OR cnt_out = X"30" OR cnt_out = X"47" OR
				cnt_out = X"54" OR cnt_out = X"AF"
				ELSE '0';
	aluout <= '1' WHEN cnt_out = X"21" OR cnt_out = X"30" OR cnt_out = X"47" OR
				cnt_out = X"4B" OR cnt_out = X"4F" OR cnt_out = X"54" OR
				cnt_out = X"84" OR cnt_out = X"88" OR cnt_out = X"A6" OR
				cnt_out = X"A8"
				ELSE '0';
	irdaout <= '1' WHEN cnt_out = X"23" OR cnt_out = X"25" OR cnt_out = X"32" 
				ELSE '0';
	bout <= '1' WHEN cnt_out = X"2C" OR cnt_out = X"3E" OR cnt_out = X"46" OR
				cnt_out = X"4A" OR cnt_out = X"4E" OR cnt_out = X"5F" OR
				cnt_out = X"6F" OR cnt_out = X"73" OR cnt_out = X"7F" OR
				cnt_out = X"83" OR cnt_out = X"87" OR cnt_out = X"93" OR
				cnt_out = X"95" OR cnt_out = X"98" 
				ELSE '0';
	sdout <= '1' WHEN cnt_out = X"32" OR cnt_out = X"5C" OR cnt_out = X"5F" 
				ELSE '0';
	setcod <= '1' WHEN cnt_out = X"3C"
				ELSE '0';
	dareg <= '1' WHEN cnt_out = X"3E" OR cnt_out = X"42" OR cnt_out = X"45" OR
				cnt_out = X"47" OR cnt_out = X"49" OR cnt_out = X"4B"
				ELSE '0';
	ldreg <= '1' WHEN cnt_out = X"3E" OR cnt_out = X"47" OR cnt_out = X"4B" OR
				cnt_out = X"98"
				ELSE '0';
	trans <= '1' WHEN cnt_out = X"3F" OR cnt_out = X"43" OR cnt_out = X"80" 
				ELSE '0';
	ldpswalu <= '1' WHEN cnt_out = X"3F" OR cnt_out = X"43" OR cnt_out = X"47" OR
				cnt_out = X"4B" OR cnt_out = X"4F" OR cnt_out = X"80" OR
				cnt_out = X"84" OR cnt_out = X"88"
				ELSE '0';
	andi <= '1' WHEN cnt_out = X"4B"
				ELSE '0';
	asr <= '1' WHEN cnt_out = X"4F"
				ELSE '0';
	ir2out <= '1' WHEN cnt_out = X"53"
				ELSE '0';
	ldpchigh <= '1' WHEN cnt_out = X"54" OR cnt_out = X"5C" OR cnt_out = X"5F" OR
				cnt_out = X"68" OR cnt_out = X"AB"
				ELSE '0';
	ldpclow <= '1' WHEN cnt_out = X"54" OR cnt_out = X"5C" OR cnt_out = X"5F" OR
				cnt_out = X"6B" OR cnt_out = X"AE"
				ELSE '0';
	decsp <= '1' WHEN cnt_out = X"56" OR cnt_out = X"57" OR cnt_out = X"6F" OR
				cnt_out = X"70" OR cnt_out = X"9C" OR cnt_out = X"9D" OR
				cnt_out = X"9F"
				ELSE '0';
	mxmbr <= '1' WHEN cnt_out = X"56" OR cnt_out = X"5A" OR cnt_out = X"6F" OR
				cnt_out = X"73" OR cnt_out = X"93" OR cnt_out = X"95" OR
				cnt_out = X"9C" OR cnt_out = X"A0" OR cnt_out = X"A3"
				ELSE '0';
	upspout <= '1' WHEN cnt_out = X"57" OR cnt_out = X"59" OR cnt_out = X"61" OR
				cnt_out = X"65" OR cnt_out = X"67" OR cnt_out = X"70" OR
				cnt_out = X"72" OR cnt_out = X"78" OR cnt_out = X"7A" OR
				cnt_out = X"9D" OR cnt_out = X"9F" OR cnt_out = X"A2"
				ELSE '0';
	wr <= '1' WHEN cnt_out = X"58" OR cnt_out = X"5B" OR cnt_out = X"71" OR
				cnt_out = X"74" OR cnt_out = X"94" OR cnt_out = X"96" OR
				cnt_out = X"9E" OR cnt_out = X"A1" OR cnt_out = X"A4"
				ELSE '0';
	mbrhigh <= '1' WHEN cnt_out = X"5A" OR cnt_out = X"73" OR cnt_out = X"95" OR
				cnt_out = X"A0"
				ELSE '0';
	irjaout <= '1' WHEN cnt_out = X"5C"
				ELSE '0';
	incsp <= '1' WHEN cnt_out = X"61" OR cnt_out = X"65" OR cnt_out = X"67" OR
				cnt_out = X"78" OR cnt_out = X"7A"
				ELSE '0';
	ldpsw <= '1' WHEN cnt_out = X"64"
			ELSE '0';
	setint <= '1' WHEN cnt_out = X"6D"
			ELSE '0';
	lda <= '1' WHEN cnt_out = X"77"
			ELSE '0';
	aout <= '1' WHEN cnt_out = X"7D"
			ELSE '0';
	inc <= '1' WHEN cnt_out = X"84"
			ELSE '0';
	dec <= '1' WHEN cnt_out = X"88"
			ELSE '0';
	seti <= '1' WHEN cnt_out = X"8A"
			ELSE '0';
	reseti <= '1' WHEN cnt_out = X"8C"
			ELSE '0';
	sett <= '1' WHEN cnt_out = X"8E"
			ELSE '0';
	resett <= '1' WHEN cnt_out = X"90"
			ELSE '0';
	decmar <= '1' WHEN cnt_out = X"95"
			ELSE '0';
	fvo <= '1' WHEN cnt_out = X"98"
			ELSE '0';
	setadr <= '1' WHEN cnt_out = X"9A"
			ELSE '0';
	ldbr <= '1' WHEN cnt_out = X"9C"
			ELSE '0';
	intack <= '1' WHEN cnt_out = X"9C"
			ELSE '0';
	pswout <= '1' WHEN cnt_out = X"A3"
			ELSE '0';
	brout <= '1' WHEN cnt_out = X"A5"
			ELSE '0';
	shl <= '1' WHEN cnt_out = X"A6"
			ELSE '0';
	ivtpout <= '1' WHEN cnt_out = X"A7"
			ELSE '0';
	marout <= '1' WHEN cnt_out = X"77"
			ELSE '0';
END Behavior ;