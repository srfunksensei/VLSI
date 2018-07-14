library ieee;
library std;
use ieee.std_logic_1164.all;
use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  signal s,r,clk,q   : std_logic := '0';
	component srff
	port(
		s,r,clk,clr : in std_logic;
		q: out std_logic
	);
	end component;
begin
  sr : entity work.SRFF(behavior)
	port map (
			s => s,
			r => r,
			clk => clk, 
			clr => '0',
			q => q
			);
  
  clock : process is
  begin
    clk <= '1';
    wait for 1 ns;
    clk <= '0';
    wait for 0.5 ns;
  end process;
    
  stimulus : process is
    
  begin
    s <= '1';
	wait for 5 ns;
	s <= '0';
	wait for 1 ns;
	r <= '1';
	wait for 1 ns;
	r <= '0';
	wait for 1 ns;

  end process;

end architecture;