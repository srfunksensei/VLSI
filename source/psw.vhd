--##########################
--
--	author: Milan Brankovic
--
--	file: psw.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
ENTITY psw IS
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
			pswl0, pswl1, i, t  : INOUT STD_LOGIC;
			sBus : INOUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			
			);
END psw ;

ARCHITECTURE Behavior OF psw IS
	SIGNAL  sl0, sl1, si, st, sn, sz, sc, sv : STD_LOGIC := '0';	
	SIGNAL  rl0, rl1, ri, rt, rn, rz, rc, rv : STD_LOGIC := '0';
	SIGNAL  no, zo, co, vo : STD_LOGIC := '0';
	
	COMPONENT SR_FF
    port(
        s, r, clk, clr :  in  std_logic;
        q                        :  out std_logic);
	end COMPONENT;

BEGIN
-- Instantiating SRFF

	srl0 : ENTITY WORK.SR_FF(behavior)
	port map (
			s => sl0,
			r => rl0,
			clk => clk, 
			clr => reset,
			q => pswl0
			);
	srl1 : ENTITY WORK.SR_FF(behavior)
	port map (
			s => sl1,
			r => rl1,
			clk => clk, 
			clr => reset,
			q => pswl1
			);
		sri : ENTITY WORK.SR_FF(behavior)
	port map (
			s => si,
			r => ri,
			clk => clk, 
			clr => reset,
			q => i
			);
		srt : ENTITY WORK.SR_FF(behavior)
	port map (
			s => st,
			r => rt,
			clk => clk, 
			clr => reset,
			q => t
			);
		srn : ENTITY WORK.SR_FF(behavior)
	port map (
			s => sn,
			r => rn,
			clk => clk, 
			clr => reset,
			q => no
			);
		srz : ENTITY WORK.SR_FF(behavior)
	port map (
			s => sz,
			r => rz,
			clk => clk, 
			clr => reset,
			q => zo
			);
		src : ENTITY WORK.SR_FF(behavior)
	port map (
			s => sc,
			r => rc,
			clk => clk, 
			clr => reset,
			q => co
			);
		srv : ENTITY WORK.SR_FF(behavior)
	port map (
			s => sv,
			r => rv,
			clk => clk, 
			clr => reset,
			q => vo
			);

	PROCESS (clk,
			ldL, ldPSW, prl0, prl1, 
			setI, resetI, setT, resetT,
			ldPSWalu, n,z,c,v, 
			PSWout ) IS
	BEGIN
		IF (rising_edge(clk)) THEN
			sl0 <= (ldL AND prl0) OR (ldPSW AND sBus(0));
			rl0 <= (ldL AND ( NOT prl0)) OR (ldPSW AND (NOT sBus(0)));
			
			sl1 <= (ldL AND prl1) OR (ldPSW AND sBus(1));
			rl1 <= (ldL AND ( NOT prl1)) OR (ldPSW AND (NOT sBus(1)));
			
			si <= (ldPSW AND sBus(2)) OR setI;
			ri <= (ldPSW AND (NOT sBus(2))) OR resetI;
			
			st <= (ldPSW AND sBus(3)) OR setT;
			rt <= (ldPSW AND (NOT sBus(3))) OR resetT;
			
			sn <= (ldPSWalu AND n) OR (ldPSW AND sBus(4));
			rn <= (ldPSWalu AND ( NOT n)) OR (ldPSW AND (NOT sBus(4)));
			
			sz <= (ldPSWalu AND z) OR (ldPSW AND sBus(5));
			rz <= (ldPSWalu AND ( NOT z)) OR (ldPSW AND (NOT sBus(5)));
			
			sc <= (ldPSWalu AND c) OR (ldPSW AND sBus(7));
			rc <= (ldPSWalu AND ( NOT c)) OR (ldPSW AND (NOT sBus(7)));
			
			sv <= (ldPSWalu AND v) OR (ldPSW AND sBus(6));
			rv <= (ldPSWalu AND ( NOT v)) OR (ldPSW AND (NOT sBus(6)));
		END IF;
	END PROCESS;
	
	
	PROCESS (PSWout, sBus, pswl0, pswl1,
			co, vo, zo, no, t, i) IS
	BEGIN
		IF (PSWout = '1') THEN 
			sBus <= X"00" & co & vo & zo & no & t & i & pswl1 & pswl0;		
		ELSE 
			sBus <= (others => 'Z');
		END IF;
	END PROCESS;
	
END Behavior ;