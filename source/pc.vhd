--##########################
--
--	author: Milan Brankovic
--
--	file: pc.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_signed.all ;

ENTITY pc IS
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
END pc ;
	
ARCHITECTURE Behavior OF pc IS
	SIGNAL state : STD_LOGIC_VECTOR(k-1 DOWNTO 0) := X"0000";
BEGIN
	PROCESS ( clk, ldHigh, ldLow , inc, reset)
		BEGIN
			IF rising_edge(clk) THEN
				IF ldHigh = '1' AND ldLow = '1' THEN
					state(k-1 DOWNTO 8) <= input(k-1 DOWNTO 8);
					state(7 DOWNTO 0) <= input(7 DOWNTO 0);
				ELSIF ldHigh = '1' THEN
					state(k-1 DOWNTO 8) <= input(k-1 DOWNTO 8);
				ELSIF ldLow = '1' THEN
					state(7 DOWNTO 0) <= input(7 DOWNTO 0);
				ELSIF inc = '1' THEN
					state <= state + 1;
				ELSIF reset = '1' THEN 
					state <= X"0000";
				END IF ;
			END IF ;
	END PROCESS ;
	output <= state;
END Behavior ;