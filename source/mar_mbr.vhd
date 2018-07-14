--##########################
--
--	author: Milan Brankovic
--
--	file: mar_mbr.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_signed.all ;

ENTITY mar_mbr IS
	GENERIC ( num : INTEGER := 16;
			  len : INTEGER := 8
			) ;
	PORT ( 
			--input ports
			incmar, decmar, ldmar,
			marout, marout1, busHold,
			mbrhigh, mxmbr, 
			ldmbr, 
			mbrout, wr : IN STD_LOGIC ;
			
			sBus : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			ABUS, dBus_intern : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			
			--inout ports
			DBUS : INOUT  STD_LOGIC_VECTOR(len-1 DOWNTO 0)
			
			);
END mar_mbr ;

ARCHITECTURE Behavior OF mar_mbr IS
	SIGNAL mar : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000"; --reg mar
	SIGNAL mbr, mx1_out, mx2_out : STD_LOGIC_VECTOR(len-1 DOWNTO 0) := X"00"; --reg_mbr
	
	COMPONENT mx2to1
	GENERIC ( num : INTEGER := 3 ) ;
	PORT ( 
			--input ports
			d0, d1 : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			sel : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT inc_dec_reg
	GENERIC ( k : INTEGER := 8 ) ;
	PORT ( 
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			inc, dec : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			);
	END COMPONENT;
BEGIN
	mx1 : ENTITY WORK.mx2to1(behavior)
		GENERIC MAP(num => len)
		PORT MAP( sBus(len-1 DOWNTO 0), sBus(num-1 DOWNTO len), mbrhigh, mx1_out);
	mx2 : ENTITY WORK.mx2to1(behavior)
		GENERIC MAP(num => len)
		PORT MAP( DBUS, mx1_out, mxmbr, mx2_out);
	mbr_reg : ENTITY WORK.inc_dec_reg(behavior)
		PORT MAP(Clock, reset, ldmbr, '0', '0', mx2_out, mbr);
	
	
	
--	PROCESS (ldmbr, mxmbr, mbrhigh, sBus, marout, mbrout, reset, Clock) IS
--	VARIABLE mbr_tmp : STD_LOGIC_VECTOR (len-1 DOWNTO 0) := X"00";
--	BEGIN
--		IF (rising_edge(Clock)) THEN
--			IF (ldmbr = '1' AND mxmbr = '1' AND mbrhigh = '1' ) THEN
--				mbr_tmp := sBus(num-1 DOWNTO len);
--			ELSIF (ldmbr = '1' AND mxmbr = '1' AND mbrhigh = '0') THEN 
--				mbr_tmp := sBus(len-1 DOWNTO 0);
--			ELSIF (ldmbr = '1' AND mxmbr = '0') THEN
--				mbr_tmp := DBUS;
--			ELSIF (reset = '1') THEN
--				mbr_tmp := X"00";
--			END IF;
--		END IF;	
--			mbr <= mbr_tmp;
--	END PROCESS;
	
	PROCESS ( Clock, ldmar, incmar, decmar, reset )
		BEGIN
			IF rising_edge(Clock) THEN
				IF ldmar = '1' THEN 
					mar <= sBus ;
				ELSIF incmar = '1' THEN
					mar <= mar + 1;
				ELSIF decmar = '1' THEN
					mar <= mar - 1;
				ELSIF reset = '1' THEN
					mar <= X"0000";
				END IF ;
			END IF ;
	END PROCESS ;	
	
	PROCESS (marout, mbrout, Clock, wr, busHold, DBUS, mbr, marout1, mar) IS
	BEGIN
--		IF (rising_edge(Clock)) THEN
--			IF (marout = '1') THEN	
--				dBus_intern <= mar;
--			ELSIF ( mbrout = '1') THEN 
--				dBus_intern <= mbr & mbr;
--			ELSE 
--				dBus_intern <= (OTHERS => 'Z');
--			END IF;
--		END IF;
	
		IF (wr = '1' AND busHold = '1') THEN
			DBUS <= mbr;
		ELSE 
			DBUS <= (OTHERS => 'Z');
		END IF;
		
		IF (marout1 = '1' AND busHold = '1') THEN 
			ABUS <= mar;
		ELSE
			ABUS <= (others => 'Z');
		END IF;
	END PROCESS;
	
		dBus_intern <= mar WHEN marout = '1' ELSE
				mbr & mbr WHEN mbrout = '1' ELSE
				(others => 'Z');
	
END Behavior ;