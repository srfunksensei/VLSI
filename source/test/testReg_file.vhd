library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component reg_file is
	GENERIC ( num : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			ldax, ldbx, ldcx, lddx,
			ldsi, lddi, ldsp, ldbp : IN STD_LOGIC ;
			axout, bxout, cxout, dxout,
			siout, diout, spout, bpout : IN STD_LOGIC ;
			inc_sp, dec_sp : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  signal dbus : std_logic_vector(15 downto 0) := X"0000";
  


  signal ldax, ldbx, ldcx, lddx,
			ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout,
			siout, diout, spout, bpout,
			inc_sp, dec_sp,
			reset,clk : std_logic := '0';

begin
  
  regFile : reg_file port map (
    ldax, ldbx, ldcx, lddx,
			ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout,
			siout, diout, spout, bpout,
			inc_sp, dec_sp,
			sbus,
			
			reset, clk,
			
			--output ports
			dbus

  );
  
  clock : process is
  begin
    clk <= '1';
    wait for 0.5 ns;
    clk <= '0';
    wait for 0.5 ns;
  end process;
    
  stimulus : process is
    variable inline : line;
    variable tempBit : std_logic;
    variable tempVector : std_logic_vector (15 downto 0);
    file inputFile : text open read_mode is "testReg_file.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      ldax <= tempBit;
      read(inline, tempBit);
      ldbx <= tempBit;
      read(inline, tempBit);
      ldcx <= tempBit;
      read(inline, tempBit);
      lddx <= tempBit;
      read(inline, tempBit);
      ldsi <= tempBit;
      read(inline, tempBit);
      lddi <= tempBit;
      read(inline, tempBit);
      ldsp <= tempBit;
      read(inline, tempBit);
      ldbp <= tempBit;
      read(inline, tempBit);
      axout <= tempBit;
	read(inline, tempBit);
	bxout  <= tempBit;
	read(inline, tempBit);
	cxout  <= tempBit;
	read(inline, tempBit);
	dxout  <= tempBit;
	read(inline, tempBit);
	siout  <= tempBit;
	read(inline, tempBit);
	diout  <= tempBit;
	read(inline, tempBit);
	spout  <= tempBit;
	read(inline, tempBit);
	bpout  <= tempBit;
	read(inline, tempBit);
	inc_sp  <= tempBit;
	read(inline, tempBit);
	dec_sp  <= tempBit;
	hread(inline, tempVector);
      sbus <= tempVector;
      wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;