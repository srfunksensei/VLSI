--##########################
--
--	author: Milan Brankovic
--
--	file: mx2to1.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mx2to1 IS
	GENERIC ( num : INTEGER := 3 ) ;
	PORT ( 
			--input ports
			d0, d1 : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			sel : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
END mx2to1;

ARCHITECTURE Behavior OF mx2to1 IS
	
BEGIN
	output <= d0 WHEN sel = '0' ELSE
			  d1 WHEN sel = '1';
END Behavior ;