--##########################
--
--	author: Milan Brankovic
--
--	file: sinch.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY sinch IS
	PORT ( 
			--input ports
			readi, wr, busHold : IN STD_LOGIC ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			rdbus, wrbus, brqStop, brqStart, marout1, run : OUT STD_LOGIC
			);
END sinch ;

ARCHITECTURE Behavior OF sinch IS
	SIGNAL cnt_out : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"02";
	SIGNAL timerZero : STD_LOGIC := '0';
	SIGNAL rd,dec : STD_LOGIC := '0';
	SIGNAL ld : STD_LOGIC := '1';
	

	COMPONENT inc_dec_reg
		GENERIC ( k : INTEGER := 16 ) ;
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
	
	COMPONENT D_FF
		port(
        d, clk, clr :  in  std_logic;
        q                 :  out std_logic);
	END COMPONENT;
	
BEGIN
	-- Instantiating DFF
	dff1 : entity work.D_FF(BEHAVIOR)
		port map(
		readi,
		Clock,
		reset,
		rd
		);
	dff2 : entity work.D_FF(BEHAVIOR)
		port map(
		timerZero,
		Clock,
		reset,
		brqStop
		);
	cnt : entity work.inc_dec_reg(Behavior)
		port map(Clock, reset, ld, '0', dec, X"02", cnt_out);
	

	PROCESS (readi, wr, rd, cnt_out, busHold, Clock) IS
		VARIABLE run_var, timerZero_var : STD_LOGIC := '0';
		BEGIN
				brqStart <= readi OR wr;
				marout1 <= rd OR wr;
				
				timerZero_var := NOT ( cnt_out(7) OR cnt_out(6) OR cnt_out(5) OR cnt_out(4) OR
					cnt_out(3) OR cnt_out(2) OR cnt_out(1) OR cnt_out(0));
				timerZero <= timerZero_var;
				
				
				run_var := (NOT(  readi OR wr)) OR timerZero_var;
				run <= run_var;
				dec <= busHold AND (readi OR wr) AND (NOT run_var);
				ld <= NOT (busHold AND (readi OR wr) AND (NOT run_var));
		
	END PROCESS;
	
	rdbus <= '0' when (rd = '1' and busHold = '1') else
			 'Z'; 
	wrbus <= '0' when (wr= '1' and busHold= '1') else
			 'Z'; 

END Behavior ;