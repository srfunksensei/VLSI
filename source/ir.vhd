--##########################
--
--	author: Milan Brankovic
--
--	file: ir.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY ir IS
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
			ir2_2_0, ir2_5_3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			
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
END ir ;

ARCHITECTURE Behavior OF ir IS
	SIGNAL ir2, ir3, ir4  : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
	SIGNAL ir1  : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"FFFF";
	
	COMPONENT reg
		GENERIC ( k : INTEGER := 8 ) ;
		PORT (
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			ldHigh, ldLow : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			 ) ;
	END COMPONENT ;
	
BEGIN	
	reg_ir1 : reg
		GENERIC MAP(k => num)
		PORT MAP ( Clock, Reset, ldir1, '0', '0', input, ir1) ;
	reg_ir2 : reg
		GENERIC MAP(k => num)
		PORT MAP ( Clock, Reset, ldir2, '0', '0', input, ir2 ) ;
	reg_ir3 : reg
		GENERIC MAP(k => num)
		PORT MAP ( Clock, Reset, ldir3, '0', '0', input, ir3 ) ;
	reg_ir4 : reg
		GENERIC MAP(k => num)
		PORT MAP ( Clock, Reset, ldir4, '0', '0', input, ir4 ) ;
	
	
	movs <= '1' WHEN ir1 = X"8181"
			ELSE '0';
	movd <= '1' WHEN ir1 = X"8282"
			ELSE '0';
	add <= '1' WHEN ir1 = X"8484"
			ELSE '0';
	andi <= '1' WHEN ir1 = X"8888"
			ELSE '0';
	bnz <= '1' WHEN ir1 = X"6060"
			ELSE '0';
	jsr <= '1' WHEN ir1 = X"5F5F"
			ELSE '0';
	jmp <= '1' WHEN ir1 = X"4040"
			ELSE '0';
	rti <= '1' WHEN ir1 = X"0202"
			ELSE '0';
	rts <= '1' WHEN ir1 = X"0101"
			ELSE '0';
	int <= '1' WHEN ir1 = X"7F7F"
			ELSE '0';
	inte <= '1' WHEN ir1 = X"0404"
			ELSE '0';
	intd <= '1' WHEN ir1 = X"0808"
			ELSE '0';
	trpe <= '1' WHEN ir1 = X"1010"
			ELSE '0';
	trpd <= '1' WHEN ir1 = X"2020"
			ELSE '0';
	asr <= '1' WHEN ir1 = X"8080" AND ir2(5) ='0' AND ir2(4) ='0' AND ir2(3) ='0'
			ELSE '0';
	push <= '1' WHEN ir1 = X"FFFF" AND ir2(5) ='0' AND ir2(4) ='0' AND ir2(3) ='0'
			ELSE '0';
	pop <= '1' WHEN ir1 = X"FFFF" AND ir2(5) ='0' AND ir2(4) ='0' AND ir2(3) ='1'
			ELSE '0';
	inc <= '1' WHEN ir1 = X"FFFF" AND ir2(5) ='0' AND ir2(4) ='1' AND ir2(3) ='0'
			ELSE '0';
	dec <= '1' WHEN ir1 = X"FFFF" AND ir2(5) ='0' AND ir2(4) ='1' AND ir2(3) ='1'
			ELSE '0';
	jmpind <= '1' WHEN ir1 = X"FFFF" AND ir2(5) ='1' AND ir2(4) ='0' AND ir2(3) ='0'
			ELSE '0';
	
			
	regdir <= '1' WHEN ir2(7) = '0' AND ir2(6) = '0'
			ELSE '0';
	regind <= '1' WHEN ir2(7) = '0' AND ir2(6) = '1'
			ELSE '0';
	indregpom <= '1' WHEN ir2(7) = '1' AND ir2(6) = '0'
			ELSE '0';
	dirmem <= '1' WHEN ir2(7) = '1' AND ir2(6) = '1' AND ir2(1) = '0' AND ir2(0) = '0'
			ELSE '0';
	indmem <= '1' WHEN ir2(7) = '1' AND ir2(6) = '1' AND ir2(1) = '0' AND ir2(0) = '1'
			ELSE '0';
	rel <= '1' WHEN ir2(7) = '1' AND ir2(6) = '1' AND ir2(1) = '1' AND ir2(0) = '0'
			ELSE '0';
	immed <= '1' WHEN ir2(7) = '1' AND ir2(6) = '1' AND ir2(1) ='1' AND ir2(0) = '1'
			ELSE '0';
			
	PROCESS (ldir1, ir1) IS
	BEGIN
		IF(ldir1'last_value = '1' AND ldir1 = '0' AND ir1 = X"0000" ) THEN
			halt <= '1';
		ELSE 
			halt <= '0';
		END IF;
	END PROCESS;
--	halt <= '0';
	
	l1 <= ir1(7);
	l2 <= NOT ir1(6);
	l3 <= ir1(5);
	l4 <= ir2(7);
	l5 <= (NOT ir2(6)) OR (ir2(6) AND (ir2(1) AND (NOT ir2(0))));
	
	ir2_2_0 <= ir2(2 DOWNTO 0);
	ir2_5_3 <= ir2(5 DOWNTO 3);
	
	ir2_reg <= ir2(7 DOWNTO 0);

	
	PROCESS (ir2out, ir3out, irjaout, irdaout, Clock, 
			ir2, ir3, ir4) IS
	BEGIN
		IF (ir2out = '1' ) THEN
			output <= ir2(num/2-1) & ir2(num/2-1) & ir2(num/2-1) & ir2(num/2-1) & ir2(num/2-1) &
					ir2(num/2-1) & ir2(num/2-1) & ir2(num/2-1) & ir2(num/2 -1 DOWNTO 0);
		ELSIF (ir3out = '1' ) THEN
			output <= ir3(num/2-1) & ir3(num/2-1) & ir3(num/2-1) & ir3(num/2-1) & ir3(num/2-1) &
					ir3(num/2-1) & ir3(num/2-1) & ir3(num/2-1) & ir3(num/2 -1 DOWNTO 0);
		ELSIF(irjaout = '1') THEN
			output <= ir2(num/2 -1 DOWNTO 0) & ir3(num/2 -1 DOWNTO 0);
		ELSIF (irdaout = '1') THEN
			output <= ir3(num/2 -1 DOWNTO 0) & ir4(num/2 -1 DOWNTO 0);
		ELSE 
			output <= (others => 'Z');
		END IF;
	END PROCESS;
	
			
END Behavior ;