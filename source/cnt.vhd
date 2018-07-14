-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity cnt is

	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 16
	);

	port
	(
		clk		  : in std_logic;
		ld		  : in std_logic;
		dec		  : in std_logic;
		q		  : out std_logic_vector(MAX_COUNT-1 downto MIN_COUNT)
	);

end entity;

architecture rtl of cnt is
	signal cnt : std_logic_vector(MAX_COUNT-1 downto MIN_COUNT) := X"0000";
begin
	process (clk, ld, dec)	
	begin
		if (rising_edge(clk)) then

			if ld = '1' then
				-- Reset the counter to 1
				cnt <= X"0001";

			elsif dec = '1' then
				-- Decrement the counter if counting is enabled			   
				cnt <= cnt - 1 ;

			end if;
		end if;

		-- Output the current count
		q <= cnt;
	end process;
end rtl;
