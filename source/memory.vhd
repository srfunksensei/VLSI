--##########################
--
--	author: Milan Brankovic
--
--	file: memory.vhd
--
--###########################

library ieee;
library std;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.txt_util.all;

entity memory is 
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
end memory;

architecture behavior of memory is
  
  component D_FF is
    port(
        d, clk, clr :  in  std_logic;
        q                 :  out std_logic
    );
  end component;
  
  component inc_dec_reg
	GENERIC ( k : INTEGER := 8 ) ;
	PORT ( 
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			inc, dec : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			);
  end component;

  --MEMORY
  type memCells is array (65536 downto 0) of std_logic_vector (7 downto 0);
  
  shared variable mem : memCells;
  
  signal notRead, notWrite, endRDD, endRDQ, wrQ, rdQ, run, timerZero, cntDec, cntLoad, dataLoad : std_logic := '0';
  signal cntInput, cntOutput : std_logic_vector (len-1 downto 0) := X"01";
  signal dataInput, dataOutput, memoryOutput : std_logic_vector (len-1 downto 0) := X"00";

begin
  
  RD : D_FF port map (
    d => notRead,
    clr => clear,
    clk => clk,
    q => rdQ
  );
  
  WR : D_FF port map (
    d => notWrite,
    clr => clear,
    clk => clk,
    q => wrQ
  );
  
  endRead : D_FF port map (
    d => endRDD,
    clr => clear,
    clk => clk,
    q => endRDQ
  );
  
  counter : inc_dec_reg port map(
	clk, clear, cntLoad, '0', cntDec, X"01", cntOutput
  );
  
  dataReg : inc_dec_reg port map(
	clk, clear, dataLoad, '0', '0', dataInput, dataOutput
  );
  
  initialization : process is
      
    variable inline : line;
    variable tempBit : std_logic;
    variable tempVector : std_logic_vector (7 downto 0);
    file inputFile : text open read_mode is "memory.txt";
    variable position, i : natural;
  begin

	position := 0;
    while not endfile(inputFile) loop
	  readline(inputFile, inline);
      for i in 1 to 8 loop
        hread(inline, tempVector);
        mem(position) := tempVector;
        position := position + 1;
      end loop;
    end loop;
    for i in position to 65536 loop
      mem(i) := X"00";
    end loop;
    
    wait ;
  end process;
  
  process (rdbus, wrbus, rdQ, wrQ, dbus, memoryOutput, endRDD, abus, endRDQ, run, cntoutput, timerZero)
    
    variable data : std_logic_vector (7 downto 0);
    variable address : natural;
    variable s : line;
    
    --convert std_logic to natural
    function std_logic_to_natural (i : in std_logic) return natural is
      variable result : natural := 0;
      begin
        if i = '1' then result := 1;
        end if;
        return result;
    end function std_logic_to_natural;
    
    --convert std_logic_vector to natural
    function std_logic_vector_to_natural ( vector : in std_logic_vector ) return natural is
      variable result : natural := 0;
      begin
      for index in vector'range loop
        result := result * 2 + std_logic_to_natural(vector(index));
      end loop;
      return result;
    end function std_logic_vector_to_natural;
    
    begin

      if (rdbus = '0') then notRead <= '1'; else notRead <= '0'; end if;
      if (wrbus = '0') then notWrite <= '1'; else notWrite <= '0'; end if;
      
      run <= rdQ or wrQ;
      endRDD <= rdQ and timerZero;
      cntLoad <= not run;
      cntDec <= run;
      
      if cntOutput = X"00" then 
        timerZero <= '1';
      else
        timerZero <= '0';
      end if;
      
      if wrQ = '1' then
        dataInput <= dbus;
      else
        dataInput <= memoryOutput;
      end if;
      
      dataLoad <= (rdQ and timerZero) or wrQ;
      
      if endRDQ = '1' then
        dbus <= dataOutput;
      else 
        dbus <= "ZZZZZZZZ";
      end if;
      
      if wrQ = '1' and timerZero = '1' then
        address := std_logic_vector_to_natural (abus);
        mem(address) := dataOutput;
        swrite(s, string'("Mem["));
        swrite(s, str(address));
        swrite(s, string'("] = "));
        swrite(s, str(dataOutput));
        writeline(output, s);
      end if;
      
      if rdQ = '1' then
        address := std_logic_vector_to_natural (abus);
        memoryOutput <= mem(address);
      end if;
      
    end process;
    
  end behavior;
