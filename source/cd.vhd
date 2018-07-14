--##########################
--
--	author: Milan Brankovic
--
--	file: cd.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY cd IS
	GENERIC ( k : INTEGER := 8 ) ;
	PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			w : OUT STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(k/2-1 DOWNTO 0)
			);
END cd;

ARCHITECTURE Behavior OF cd IS
BEGIN
    output(3) <= '0';
    output(2) <= input(4) OR input(5) OR input(6) OR input(7);
	output(1) <= input(2) OR input(3) OR input(6) OR input(7);
	output(0) <= input(1) OR input(3) OR input(5) OR input(7);
	
	w <= input(0) OR input(1) OR input(2) OR input(3) OR input(4)
			OR input(5) OR input(6) OR input(7);	
END Behavior ;