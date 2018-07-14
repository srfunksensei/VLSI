--retister16 entity

library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.txt_util.all;

entity memory is 
  port (
    clk :   in  std_logic;
    abus :  in  std_logic_vector(15 downto 0);
    dbus :  inout std_logic_vector(7 downto 0);
    read :  in std_logic;
    write:  in std_logic;
    clear : in std_logic
  );
end memory;

architecture behavior of memory is

constant delay : time := 0.1 ns;

  component counter is
    port (
      clk :   in  std_logic;
      load:   in  std_logic;
      clear:  in  std_logic;
      inc:    in  std_logic;
      dec:    in  std_logic;
      input:  in  std_logic_vector(15 downto 0);
      output: out std_logic_vector(15 downto 0)
    );
  end component;
  
  component ddff is
    port (
      d : in std_logic;
      clk   : in  std_logic;
      q     : out std_logic;
      nq    : out std_logic;
      clear : in  std_logic
    );
  end component;
  
  component reg8 is
    port (
      clk :   in  std_logic;
      load:   in  std_logic;
      clear:  in  std_logic;
      input:  in  std_logic_vector(7 downto 0);
      output: out std_logic_vector(7 downto 0)
    );
  end component;

  type memCells is array (1023 downto 0) of std_logic_vector (7 downto 0);
  
  shared variable mem : memCells;
  
  signal notRead, notWrite, endRDD, endRDQ, wrQ, rdQ, run, timerZero, cntDec, cntLoad, dataLoad : std_logic;
  signal cntInput : std_logic_vector (15 downto 0) := X"0002";
  signal cntOutput : std_logic_vector (15 downto 0);
  signal dataInput, dataOutput, memoryOutput : std_logic_vector (7 downto 0);

begin
  
  RD : DDFF port map (
    d => notRead,
    clear => clear,
    clk => clk,
    q => rdQ,
    nq => open
  );
  
  WR : DDFF port map (
    d => notWrite,
    clear => clear,
    clk => clk,
    q => wrQ,
    nq => open
  );
  
  endRead : DDFF port map (
    d => endRDD,
    clear => clear,
    clk => clk,
    q => endRDQ,
    nq => open
  );
  
  cnt : counter port map (
    input => cntInput,
    output => cntOutput,
    inc => '0',
    dec => cntDec,
    load => cntLoad,
    clear => clear,
    clk => clk
  );
  
  data : reg8 port map (
    input => dataInput,
    output => dataOutput,
    load => dataLoad,
    clear => clear,
    clk => clk
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
    for i in position to 1023 loop
      mem(i) := X"00";
    end loop;
    mem(64) := X"02";
    wait ;
  end process;
  
  process (read, write, notRead, notWrite, rdQ, wrQ, dbus, memoryOutput, endRDD, abus, endRDQ, run, cntoutput, timerZero)
    
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

      if (read = '0') then notRead <= '1'; else notRead <= '0'; end if;
      if (write = '0') then notWrite <= '1'; else notWrite <= '0'; end if;
      
      run <= rdQ or wrQ;
      endRDD <= rdQ and timerZero;
      cntLoad <= not run;
      cntDec <= run;
      
      if cntOutput = X"0000" then 
        timerZero <= '1';
      else
        timerZero <= '0';
      end if;
      
      if wrQ = '1' then
        dataInput <= dbus;
      else
        dataInput <= memoryOutput;
      end if;
      
      dataLoad <= endRDD or wrQ;
      
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
