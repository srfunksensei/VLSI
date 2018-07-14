library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component reg_sel is
	GENERIC ( num : INTEGER := 16;
			  len : INTEGER := 3
			) ;
	PORT ( 
			--input ports
			regdir, fdo, fvo, daREG, REGout, 
			regind, regindpom, ldREG: IN STD_LOGIC ;
			bx, bp, si, di : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			upldSP, upSPout : IN STD_LOGIC;
			ir2_2_0, ir2_5_3 : IN STD_LOGIC_VECTOR(len-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp : OUT STD_LOGIC;
			axout, bxout, cxout, dxout, siout, diout, spout, bpout : OUT STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
  end component;
  
  signal bx, bp, si, di, output  : std_logic_vector(15 downto 0) := X"0000";
  signal ir2_2_0, ir2_5_3 : std_logic_vector(2 downto 0);
  


  signal regdir, fdo, fvo, daREG, REGout, 
			regind, regindpom, ldREG, reset, clk , upldSP, upSPout,
		ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout, siout, diout, spout, bpout   : std_logic := '0';

begin
  
  regs : reg_sel port map (
   --input ports
			regdir, fdo, fvo, daREG, REGout, 
			regind, regindpom, ldREG,
			bx, bp, si, di,
			upldSP, upSPout,
			ir2_2_0, ir2_5_3,
			
			reset, clk,
			
			--output ports
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout, siout, diout, spout, bpout,
			output

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
    file inputFile : text open read_mode is "testReg_sel.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      regdir<= tempBit;
      read(inline, tempBit);
      fdo <= tempBit;
      read(inline, tempBit);
      fvo <= tempBit;
      read(inline, tempBit);
      daREG <= tempBit;
      read(inline, tempBit);
      REGout <= tempBit;
      read(inline, tempBit);
      regind <= tempBit;
      read(inline, tempBit);
      regindpom <= tempBit;
      read(inline, tempBit);
      ldREG <= tempBit;
      read(inline, tempBit);
      upldSP  <= tempBit;
	read(inline, tempBit);
	upSPout  <= tempBit;
	
      hread(inline, tempVector);
      bx <= tempVector;
	hread(inline, tempVector);
      bp <= tempVector;
	hread(inline, tempVector);
      si <= tempVector;
	hread(inline, tempVector);
      di <= tempVector;

	hread(inline, tempVector);
      ir2_2_0 <= tempVector(2 DOWNTO 0);
	hread(inline, tempVector);
      ir2_5_3 <= tempVector(2 DOWNTO 0);
	

      wait for 2 ns;
    end loop;
    wait;
  end process;

end architecture;