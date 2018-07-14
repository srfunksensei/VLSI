--##########################
--
--	author: Milan Brankovic
--
--	file: reg.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY reg IS
	GENERIC ( k : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			ldHigh, ldLow : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			);
END reg ;
	
ARCHITECTURE Behavior OF reg IS
	SIGNAL state : STD_LOGIC_VECTOR(k-1 DOWNTO 0) := x"0000";
BEGIN
	PROCESS ( clk, ld, ldHigh, ldLow , reset)
		BEGIN
			IF rising_edge(clk) THEN
				IF ld = '1' THEN 
					state <= input ;
				ELSIF ldHigh = '1' AND ldLow = '1' THEN
					state(k-1 DOWNTO 8) <= input(k-1 DOWNTO 8);
					state(7 DOWNTO 0) <= input(7 DOWNTO 0);
				ELSIF ldHigh = '1' THEN
					state(k-1 DOWNTO 8) <= input(k-1 DOWNTO 8);
				ELSIF ldLow = '1' THEN
					state(7 DOWNTO 0) <= input(7 DOWNTO 0);
				ELSIF (reset = '1') THEN
					state <= X"0000";
				END IF ;
			END IF ;
	END PROCESS ;
	output <= state;
END Behavior ;