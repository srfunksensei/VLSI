--##########################
--
--	author: Milan Brankovic
--
--	file: arbit.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY arbit IS
	PORT ( 
			--input ports
			brqStart, brqStop : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			busHold, busy : OUT STD_LOGIC
			
			);
END arbit ;

ARCHITECTURE Behavior OF arbit IS
	SIGNAL br, bg_out, bgr, setbusy, busbusy,
	brq2, brq1, brq0, bg0, bg1, bg2, bg3, 
	busHold_tmp, busy_tmp : STD_LOGIC := '0';
	
	COMPONENT SR_FF
		port(
        s, r, clk, clr :  in  std_logic;
        q                        :  out std_logic);
	END COMPONENT;
BEGIN
	-- Instantiating SRFF
	sr1 : entity work.SR_FF(BEHAVIOR)
	port map (
			s => brqStart,
			r => brqStop,
			clk => Clock, 
			clr => reset,
			q => br
			);
			
	sr2 : entity work.SR_FF(BEHAVIOR)
	port map (
			s => setbusy,
			r => brqStop,
			clk => Clock, 
			clr => reset,
			q => busHold_tmp
			);


	busHold <= busHold_tmp;
	
	bg3 <= br;
	bgr <= br;
	setbusy <= (NOT busbusy) AND bgr;
	bg_out <= (NOT br) AND bg3;
	
	busy <= '1' WHEN busHold_tmp = '1' 
			ELSE 'Z';
	busbusy <= '1' WHEN busHold_tmp = '1'
			ELSE '0';
END Behavior ;