library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.all;

entity testOp is
end testOp;

architecture test of testOp is
  
  component gen_ld_out is
	PORT ( 
			--input ports
			ldREG, REGout,
			axsel, bxsel, cxsel, dxsel, 
			spsel, bpsel, sisel, disel,
			bxout2, bpout2, siout2, diout2,
			upldSP, upSPout : IN STD_LOGIC;
			
			
			--output ports
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout, siout, diout, spout, bpout : OUT STD_LOGIC
			);
  end component;
  
  signal ldREG, REGout,
			axsel, bxsel, cxsel, dxsel, 
			spsel, bpsel, sisel, disel,
			bxout2, bpout2, siout2, diout2,
			upldSP, upSPout,
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout, siout, diout, spout, bpout,clk  : std_logic := '0';

begin
  
  ld_out : gen_ld_out port map (
    	ldREG, REGout,
			axsel, bxsel, cxsel, dxsel, 
			spsel, bpsel, sisel, disel,
			bxout2, bpout2, siout2, diout2,
			upldSP, upSPout,
			
			
			--output ports
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout, siout, diout, spout, bpout

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
    file inputFile : text open read_mode is "testLd_out.txt";
  begin
    readline(inputFile, inline); -- read signal names from first line
    while not endfile(inputFile) loop
      readline(inputFile, inline);
      read(inline, tempBit);
      ldREG <= tempBit;
      read(inline, tempBit);
      REGout <= tempBit;
      read(inline, tempBit);
      axsel <= tempBit;
      read(inline, tempBit);
      bxsel <= tempBit;
      read(inline, tempBit);
      cxsel <= tempBit;
      read(inline, tempBit);
      dxsel <= tempBit;
      read(inline, tempBit);
      spsel <= tempBit;
      read(inline, tempBit);
      bpsel <= tempBit;
      read(inline, tempBit);
      sisel <= tempBit;
	read(inline, tempBit);
	disel  <= tempBit;
      read(inline, tempBit);
      bxout2 <= tempBit;
      read(inline, tempBit);
      bpout2 <= tempBit;
      read(inline, tempBit);
      siout2 <= tempBit;
      read(inline, tempBit);
      diout2 <= tempBit;
      read(inline, tempBit);
      upldSP <= tempBit;
      read(inline, tempBit);
      upSPout <= tempBit;

      wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture;