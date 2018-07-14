--##########################
--
--	author: Milan Brankovic
--
--	file: SR_FF.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity SR_FF is
    port(
        s, r, clk, clr :  in  std_logic;
        q                        :  out std_logic);
end SR_FF;

architecture BEHAVIOR of SR_FF is

signal iq : std_logic := '0';

begin
    process (clk, clr)
    begin
        if (clr =  '1') then
            iq <= '0';
        elsif (clk'event and (clk = '1') and (clk'last_value = '0')) then
            
                if ((s = '1') and (r = '0')) then
                    iq <= '1';
                elsif ((s = '0') and (r = '1')) then
                    iq <= '0';
                elsif ((s = '1') and (r = '1')) then
                    iq <= not iq;
                end if;
            
        end if;
    end process;

    q <= iq;

end BEHAVIOR;