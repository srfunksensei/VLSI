--##########################
--
--	author: Milan Brankovic
--
--	file: inc_dec_reg.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_signed.all ;

ENTITY inc_dec_reg IS
	GENERIC ( k : INTEGER := 8 ) ;
	PORT ( 
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			inc, dec : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			);
END inc_dec_reg ;
	
ARCHITECTURE Behavior OF inc_dec_reg IS
	SIGNAL state : STD_LOGIC_VECTOR(k-1 DOWNTO 0) := X"00";
BEGIN
	PROCESS ( clk, ld, inc, dec, reset )
		BEGIN
			IF rising_edge(clk) THEN
				IF ld = '1' THEN 
					state <= input ;
				ELSIF inc = '1' THEN
					state <= state + 1;
				ELSIF dec = '1' THEN
					state <= state - 1;
				ELSIF reset = '1' THEN 
					state <= X"00";
				END IF ;
			END IF ;
	END PROCESS ;
	output <= state;
END Behavior ;