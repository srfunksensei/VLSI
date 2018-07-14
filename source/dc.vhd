--##########################
--
--	author: Milan Brankovic
--
--	file: dc.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY dc IS
	GENERIC ( k : INTEGER := 3 ) ;
	PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			e : IN STD_LOGIC;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(2*k+1 DOWNTO 0)
			);
END dc;

ARCHITECTURE Behavior OF dc IS
BEGIN
      PROCESS (e, input)
		VARIABLE segment : STD_LOGIC_VECTOR(2*k+1 DOWNTO 0) := X"00";
		begin
			IF (e = '1') THEN
				IF input = b"000" THEN segment := X"01";
				ELSIF input = b"001" THEN segment := X"02";
				ELSIF input = b"010" THEN segment := X"04";
				ELSIF input = b"011" THEN segment := X"08";
				ELSIF input = b"100" THEN segment := X"10";
				ELSIF input = b"101" THEN segment := X"20";
				ELSIF input = b"110" THEN segment := X"40";
				ELSIF input = b"111" THEN segment := X"80";
				END IF;
			ELSE segment := X"00";
			END IF;
			output <= segment;
		END PROCESS;
END Behavior ;