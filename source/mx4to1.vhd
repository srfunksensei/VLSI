--##########################
--
--	author: Milan Brankovic
--
--	file: mx4to1.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mx4to1 IS
	GENERIC ( num : INTEGER := 8 ) ;
	PORT ( 
			--input ports
			d0, d1, d2, d3 : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			sel0, sel1 : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
END mx4to1;

ARCHITECTURE Behavior OF mx4to1 IS
	
BEGIN
	output <= d0 when sel1 = '0' and sel0 = '0' else
			d1 when sel1 = '0' and sel0 = '1' else
			d2 when sel1 = '1' and sel0 = '0' else
			d3 when sel1 = '1' and sel0 = '1';
END Behavior ;