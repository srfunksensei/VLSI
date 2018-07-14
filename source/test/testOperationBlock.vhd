library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is

  component alu is
    GENERIC ( num : INTEGER := 16 ) ;
	PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			trans, add, inc, dec, andi, asr, sl : IN STD_LOGIC ;
			
			ldx, ldy, aluout : IN STD_LOGIC ; 
			
			Reset, Clock : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			n,z,c,v : OUT STD_LOGIC
			);
  end component;
  
  signal sbus : std_logic_vector(15 downto 0) := X"0000";
  signal dbus : std_logic_vector(15 downto 0) := X"0000";
  
  signal trans, add, andi, inc, dec, asr, sl, clk,reset, ldX, ldY, ALUout, N, Z, C, V : std_logic := '0';

begin
  
  opBlock : alu port map (
    sbus,
    trans,
    add,
    
    inc,
    dec,
	andi,
    asr,
    sl,

    ldX,
    ldY,
    ALUout,
	reset,
	clk,
    
    dbus,
	N,
    Z,
    C,
    V
  );
  
  clock : process is
  begin
    clk <= '1';
    wait for 0.5 ns;
    clk <= '0';
    wait for 0.5 ns;
  end process;
    
  --format in input file is: trans, add, land, inc, dec, asr, shl, ldX, ldy, ALUout, sbus
  stimulus : process is
    variable inline : line;
    variable tempBit : std_logic;
    variable tempVector : std_logic_vector (15 downto 0);
    file inputFile : text open read_mode is "testOperationBlock.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      trans <= tempBit;
      read(inline, tempBit);
      add <= tempBit;
      read(inline, tempBit);
      andi <= tempBit;
      read(inline, tempBit);
      inc <= tempBit;
      read(inline, tempBit);
      dec <= tempBit;
      read(inline, tempBit);
      asr <= tempBit;
      read(inline, tempBit);
      sl <= tempBit;
      read(inline, tempBit);
      ldX <= tempBit;
      read(inline, tempBit);
      ldY <= tempBit;
      read(inline, tempBit);
      ALUout <= tempBit;
      hread(inline, tempVector);
      sbus <= tempVector;
      wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;