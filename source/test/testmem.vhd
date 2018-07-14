library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.txt_util.all;
--use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component memory is
	generic ( num : integer := 16;
			len : integer := 8
			);
	port (
		clk :   in  std_logic;
		clear : in std_logic;
		abus :  in  std_logic_vector(num-1 downto 0);
		dbus :  inout std_logic_vector(len-1 downto 0);
		rdbus :  in std_logic;
		wrbus:  in std_logic
	);
  end component;
  
SIGNAL ABUS : STD_LOGIC_VECTOR(15 DOWNTO 0) := "ZZZZZZZZZZZZZZZZ";
SIGNAL DBUS : STD_LOGIC_VECTOR(7 DOWNTO 0) := "ZZZZZZZZ";
 
  signal reset, clk : std_logic := '0';
  signal RDBUS, WRBUS : std_logic;

begin
  
  mm : memory port map (
   
			clk,reset,
			
			ABUS,
			DBUS,
			
			
			RDBUS, WRBUS
  );
  
 
clock11 : process is
  begin
    clk <= '1';
    wait for 0.5 ns;
    clk <= '0';
    wait for 0.5 ns;
  end process;

  stimulus : process is
    begin
    RDBUS <= '0';
    wait for 1.5 ns;
    RDBUS <= '1';
    wait for 5 ns;
  end process;

end architecture;