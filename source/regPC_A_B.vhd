--##########################
--
--	author: Milan Brankovic
--
--	file: regPC_A_B.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY regPC_A_B IS
	GENERIC ( num : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			ldpchigh, ldpclow, incpc,
			ldbhigh, ldblow,
			lda,
			pcout, bout, aout : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output  : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
END regPC_A_B;

ARCHITECTURE Behavior OF regPC_A_B IS
	SIGNAL a, b, pc_v : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
	
	COMPONENT reg
		GENERIC ( k : INTEGER := 16 ) ;
		PORT (
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			ldHigh, ldLow : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output: OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			 ) ;
	END COMPONENT ;
	
	COMPONENT pc
		GENERIC ( k : INTEGER := 16 ) ;
		PORT ( 
				--input ports
				clk, reset : IN STD_LOGIC ;
				ldHigh, ldLow : IN STD_LOGIC ;
				inc : IN STD_LOGIC ;
				input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
				
				--output ports
				output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
				);
	END COMPONENT ;
	
BEGIN	
	reg_a : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, lda, '0', '0', input, a ) ;
	reg_b : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, '0', ldbhigh, ldblow, input, b ) ;
	reg_pc : entity work.pc(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ldpchigh, ldpclow, incpc, input, pc_v ) ;
	
	PROCESS (aout, bout, pcout, Clock, 
			a,b,pc_v) IS
	BEGIN
		IF (aout = '1' ) THEN
			output <= a;
		ELSIF ( bout = '1') THEN
			output <= b;
		ELSIF (pcout = '1') THEN
			output <= pc_v;
		ELSE
			output <= (others => 'Z');
		END IF;
	END PROCESS;
			
END Behavior ;