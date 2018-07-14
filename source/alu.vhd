--##########################
--
--	author: Milan Brankovic
--
--	file: alu.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_signed.all ;

ENTITY alu IS
	GENERIC ( num : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			trans, add, inc, dec, andi, asr, sl : IN STD_LOGIC ;
			
			ldx, ldy, aluout : IN STD_LOGIC ; 
			
			Reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			n,z,c,v : OUT STD_LOGIC
			);
END alu ;

ARCHITECTURE Behavior OF alu IS
	SIGNAL out_value : STD_LOGIC_VECTOR(num DOWNTO 0) := b"00000000000000000";
	SIGNAL aluX, aluY : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
	
	COMPONENT reg
		GENERIC ( k : INTEGER := 16 ) ;
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
	reg_x : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, Reset, ldx, '0', '0', input, aluX ) ;
	reg_y : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, Reset, ldy, '0', '0', input, aluY ) ;
	
	out_value <= ('0' & aluX) + ('0' & aluY) WHEN add = '1' ELSE
			('0' & aluX) + 1 WHEN inc = '1' ELSE
			('0' & aluX) - 1 WHEN dec = '1' ELSE
			('0' & aluX) WHEN trans = '1'ELSE
			('0' & aluX) AND ('0' & aluY) WHEN andi = '1' ELSE
			'0' & '0' & aluX(num-1 DOWNTO 1) WHEN asr = '1' ELSE
			aluX & '0' WHEN sl = '1';
	
	PROCESS (aluout, out_value) IS
	BEGIN
		IF (aluout = '1') THEN
			output <= out_value(num-1 DOWNTO 0);
		ELSE
			output <= (OTHERS => 'Z');
		END IF;
	END PROCESS;
			
	z <= '1' WHEN out_value(num-1 DOWNTO 0) = X"0000" ELSE '0';
	
	n <= '1' WHEN out_value(num-1) = '1' ELSE '0';
	
	c <= ((dec and out_value(num)) or
		 ((inc or add) and out_value(num)) or
		 (aluX(0) and asr));
		 
	v <= ((((aluX(num-1) and aluY(15) and (not out_value(num-1))) or
		 ((not aluX(num-1)) and (not aluY(num-1)) and out_value(num-1)))
		 and add) 
		 or
		 (inc and out_value(num-1) and (not aluX(num-1)))
		 or
		 (dec and (not out_value(num-1)) and aluX(num-1)));
		 
END Behavior ;