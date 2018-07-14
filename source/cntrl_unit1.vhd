--##########################
--
--	author: Milan Brankovic
--
--	file: cntrl_unit1.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY cntrl_unit1 IS
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
END cntrl_unit1 ;

ARCHITECTURE Behavior OF cntrl_unit1 IS
	SIGNAL ld, inc_cnt : STD_LOGIC;
	SIGNAL kmop, kmadr, kmbranch, mx_out : STD_LOGIC_VECTOR( num-1 DOWNTO 0) := X"00";
	
	COMPONENT mx4to1
		GENERIC ( num : INTEGER := 8 ) ;
		PORT ( 
			--input ports
			d0, d1, d2, d3 : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			sel0, sel1 : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
	END COMPONENT ;
	
	COMPONENT inc_dec_reg
		GENERIC ( k : INTEGER) ;
		PORT ( 
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			inc, dec : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			);
	END COMPONENT ;
	
BEGIN	
	mx : entity work.mx4to1(behavior)
		GENERIC MAP ( num => num )
		PORT MAP ( kmbranch, kmadr, kmop, X"00", bradr, brop, mx_out ) ;
	cnt : entity work.inc_dec_reg(behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ld, inc_cnt, '0', mx_out, cnt_out ) ;
	kmop <= X"3E" WHEN movs = '1' ELSE
			X"41" WHEN movd = '1' ELSE
			X"45" WHEN add = '1' ELSE
			X"49" WHEN andi = '1' ELSE
			X"4d" WHEN asr = '1' ELSE
			X"51" WHEN bnz = '1' ELSE
			X"56" WHEN jsr = '1' ELSE
			X"5c" WHEN jmp = '1' ELSE
			X"5e" WHEN jmpind = '1' ELSE
			X"61" WHEN rti = '1' ELSE
			X"65" WHEN rts = '1' ELSE
			X"6d" WHEN int = '1' ELSE
			X"6f" WHEN push = '1' ELSE
			X"76" WHEN pop = '1' ELSE
			X"82" WHEN inc = '1' ELSE
			X"86" WHEN dec = '1' ELSE
			X"8a" WHEN inte = '1' ELSE
			X"8c" WHEN intd = '1' ELSE
			X"8e" WHEN trpe = '1' ELSE
			X"90" WHEN trpd = '1';
			
	kmadr <= X"1b" WHEN regdir = '1' ELSE
			 X"1d" WHEN regind = '1' ELSE
			 X"1f" WHEN indregpom = '1' ELSE
			 X"23" WHEN dirmem = '1' ELSE
			 X"25" WHEN indmem = '1' ELSE
			 X"2e" WHEN rel = '1' ELSE
			 X"32" WHEN immed = '1';
			 
	kmbranch <= X"00" WHEN val00 = '1' ELSE
				X"0e" WHEN val0e = '1' ELSE
				X"19" WHEN val19 = '1' ELSE
				X"34" WHEN val34 = '1' ELSE
				X"3b" WHEN val3b = '1' ELSE
				X"92" WHEN val92 = '1' ELSE
				X"98" WHEN val98 = '1' ELSE
				X"9a" WHEN val9a = '1' ELSE
				X"9b" WHEN val9b = '1';
	
	PROCESS (brop, bradr, branch, run, halt) IS
	VARIABLE or1 : STD_LOGIC := '0';
	BEGIN			
		or1 := brop OR bradr OR branch;
		ld <= run AND (NOT halt) AND or1;
		inc_cnt <= run AND (NOT halt) AND ( NOT or1);
	END PROCESS;
	
END Behavior ;