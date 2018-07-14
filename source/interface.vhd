--##########################
--
--	author: Milan Brankovic
--
--	file: interface.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY interface IS
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
END interface ;

ARCHITECTURE Behavior OF interface IS
	SIGNAL brqStop, brqStart, marout1, busHold  : STD_LOGIC := '0';
	
	
	COMPONENT sinch
		PORT ( 
			--input ports
			readi, wr, busHold : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			rdbus, wrbus, brqStop, brqStart, marout1, run : OUT STD_LOGIC
			);
	END COMPONENT;

	COMPONENT arbit
		PORT ( 
			--input ports
			brqStart, brqStop : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			busHold, busy : OUT STD_LOGIC
			
			);
	END COMPONENT;
	
	COMPONENT mar_mbr
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
	END COMPONENT;
	
BEGIN
	s : ENTITY WORK.sinch(behavior)
	PORT MAP(
			--input ports
			readi, wr, busHold,
			
			reset, Clock,
			
			--output ports
			rdbus, wrbus, brqStop, brqStart, marout1, run
	);
	
	a : ENTITY WORK.arbit(behavior)
	PORT MAP(
		--input ports
			brqStart, brqStop,
			
			reset, Clock,
			
			--output ports
			busHold, busy
	);
	
	reg : ENTITY WORK.mar_mbr(behavior)
	PORT MAP(
			--input ports
			incmar, decmar, ldmar,
			marout, marout1, busHold,
			mbrhigh, mxmbr, 
			ldmbr, 
			mbrout, wr,
			
			sBus,
			
			reset, Clock,
			
			--output ports
			ABUS, dBus_intern,
			
			--inout ports
			DBUS
	);

	
END Behavior ;