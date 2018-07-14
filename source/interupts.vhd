--##########################
--
--	author: Milan Brankovic
--
--	file: interupts.vhd
--
--###########################


LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY interupts IS
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
			
			inta1, inta2, inta3, prl0, prl1, ldL : INOUT STD_LOGIC
						
			);
END interupts ;

ARCHITECTURE Behavior OF interupts IS
	SIGNAL inta,prper : STD_LOGIC := '0';
	
	
	COMPONENT prio
		GENERIC( num : INTEGER := 3 );
		PORT ( 
			--input ports
			setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			intr1, intr2, intr3,
			intack, inta, 
			pswl0, pswl1, pswi : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			prper,prl0, prl1 : OUT STD_LOGIC;

			
			--input/output ports
			 inta1, inta2, inta3, ldL : INOUT STD_LOGIC
						
			);
	END COMPONENT;
	
	COMPONENT ivtp_br
		GENERIC( num : INTEGER := 16;
			 len : INTEGER := 8
			);
		PORT ( 
			--input ports
			setint, setcod, setadr, setnmi, resetf, 
			intack,
			ldivtp, ldbr, 
			prper, pswt,
			prl0, prl1,
			ivtpout, brout : IN STD_LOGIC ;
			
			dBus : IN STD_LOGIC_VECTOR (num-1 DOWNTO 0) ;
			ir2 : IN STD_LOGIC_VECTOR (len-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			prekid, inta : OUT STD_LOGIC;
			sBus : OUT STD_LOGIC_VECTOR (num-1 DOWNTO 0)
			
			);
	END COMPONENT;
	
	
BEGIN

	p : ENTITY WORK.prio(behavior)
	PORT MAP(
			--input ports
			setimr1, setimr2, setimr3, resetimr1, resetimr2, resetimr3,
			intr1, intr2, intr3,
			intack, inta, 
			pswl0, pswl1, pswi,
			
			reset, Clock,
			
			--output ports
			prper,prl0, prl1,

			
			--input/output ports
			 inta1, inta2, inta3, ldL
	);
	
	iregs : ENTITY WORK.ivtp_br(behavior)
	PORT MAP(
		--input ports
			setint, setcod, setadr, setnmi, resetf, 
			intack,
			ldivtp, ldbr, 
			prper, pswt,
			prl0, prl1,
			ivtpout, brout,
			
			dBus,
			ir2,
			
			reset, Clock ,
			
			--output ports
			prekid, inta,
			sBus
	);
	
END Behavior ;