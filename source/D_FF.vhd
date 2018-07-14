--##########################
--
--	author: Milan Brankovic
--
--	file: D_FF.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity D_FF is
    port(
        d, clk, clr :  in  std_logic;
        q                 :  out std_logic);
end D_FF;

architecture BEHAVIOR of D_FF is

signal iq : std_logic := '0';

begin
    process (clk, clr)
    begin
        if (clr =  '1') then
            iq <= '0';
        elsif (clk'event and (clk = '1') and (clk'last_value = '0')) then
            iq <= d;
        end if;
    end process;

    q <= iq;

end BEHAVIOR;