--##########################
--
--	author: Milan Brankovic
--
--	file: prio.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY prio IS
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
END prio ;

ARCHITECTURE Behavior OF prio IS
	SIGNAL imr1, imr2, imr3, 
			in1, in2, in3 : STD_LOGIC := '0';
	SIGNAL dc_in : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := b"000";
	SIGNAL dc_out : STD_LOGIC_VECTOR(2*num+1 DOWNTO 0) := X"00";
	
	COMPONENT dc
		GENERIC ( k : INTEGER := 3 ) ;
		PORT ( 
				--input ports
				input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
				e : IN STD_LOGIC;
				
				--output ports
				output : OUT STD_LOGIC_VECTOR(2*k+1 DOWNTO 0)
				);
	END COMPONENT;
	
	
BEGIN
	srimr1 : entity work.SR_FF(behavior)
	port map (
			s => setimr1,
			r => resetimr1,
			clk => Clock, 
			clr => reset,
			q => imr1
			);
	srimr2 : entity work.SR_FF(behavior)
	port map (
			s => setimr2,
			r => resetimr2,
			clk => Clock, 
			clr => reset,
			q => imr2
			);
	srimr3 : entity work.SR_FF(behavior)
	port map (
			s => setimr3,
			r => resetimr3,
			clk => Clock, 
			clr => reset,
			q => imr3
			);
	srin1 : entity work.SR_FF(behavior)
	port map (
			s => intr1,
			r => inta1,
			clk => Clock, 
			clr => reset,
			q => in1
			);
	srin2 : entity work.SR_FF(behavior)
	port map (
			s => intr2,
			r => inta2,
			clk => Clock, 
			clr => reset,
			q => in2
			);
	srin3 : entity work.SR_FF(behavior)
	port map (
			s => intr3,
			r => inta3,
			clk => Clock, 
			clr => reset,
			q => in3
			);
	dc1 : ENTITY WORK.dc(behavior)
	GENERIC MAP (k => num)
	PORT MAP (
			input => dc_in,
			e => ldL,
			output => dc_out
			);
	
	PROCESS (imr1, imr2, imr3, in1, in2, in3, inta, intack,
			pswl1, pswl0,pswi ) IS
	VARIABLE and_imr1, and_imr2, and_imr3, 
			imrprirr, accprirr, ldL_v, prl0_v, prl1_v : STD_LOGIC := '0';
	BEGIN	
		and_imr1 := imr1 AND in1;
		and_imr2 := imr2 AND in2;
		and_imr3 := imr3 AND in3;
		
		imrprirr := and_imr1 OR and_imr2 OR and_imr3;
		
		IF and_imr3 = '1' THEN
			prl0_v := '1'; prl1_v := '1';
		ELSIF and_imr2 = '1' THEN
			prl0_v := '0'; prl1_v := '1';
		ELSIF and_imr1 = '1' THEN
			prl0_v := '1'; prl1_v := '0';
		ELSE prl0_v := '0'; prl1_v := '0';
		END IF;
		prl0 <= prl0_v; prl1 <= prl1_v;
				
		IF (prl1_v > pswl1) THEN accprirr := '1';
		ELSIF (prl1_v = pswl1) THEN 
			IF (prl0_v > pswl0) THEN accprirr := '1';
			ELSE accprirr := '0';
			END IF;
		ELSE accprirr := '0';
		END IF;
	
		dc_in <= '0' & prl1_v & prl0_v;	
		ldL_v := inta AND intack;
		ldL <= ldL_v;
		
		prper <= pswi AND accprirr AND imrprirr;
	END PROCESS;
		
	inta1 <= dc_out(1);
	inta2 <= dc_out(2);
	inta3 <= dc_out(3);

END Behavior ;