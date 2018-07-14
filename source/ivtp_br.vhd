--##########################
--
--	author: Milan Brankovic
--
--	file: ivtp_br.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY ivtp_br IS
	GENERIC( num : INTEGER := 16;
			 len : INTEGER := 8
			);
	PORT ( 
			--input ports
			setint, setcod, setadr, setnmi, resetf, 
			intack,
			ldivtp, ldbr, 
			prper, pswt,
			prl0, prl1,
			ivtpout, brout : IN STD_LOGIC ;
			
			dBus : IN STD_LOGIC_VECTOR (num-1 DOWNTO 0) ;
			ir2 : IN STD_LOGIC_VECTOR (len-1 DOWNTO 0) ;
			
			reset, Clock : IN STD_LOGIC ;
			
			--output ports
			prekid, inta : OUT STD_LOGIC;
			sBus : OUT STD_LOGIC_VECTOR (num-1 DOWNTO 0)
			
			);
END ivtp_br ;

ARCHITECTURE Behavior OF ivtp_br IS
	SIGNAL int, cod, adr, nmi, resetnmi : STD_LOGIC := '0';
	SIGNAL ivtp : STD_LOGIC_VECTOR (num-1 DOWNTO 0) := X"1000";
	SIGNAL br, cd_in, mp1_out : STD_LOGIC_VECTOR (len-1 DOWNTO 0) := X"00";
	SIGNAL cd_out : STD_LOGIC_VECTOR (len/2-1 DOWNTO 0) := X"0";
	
	COMPONENT cd
		GENERIC ( k : INTEGER := 8 ) ;
		PORT ( 
				--input ports
				input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
				
				--output ports
				w : OUT STD_LOGIC;
				output : OUT STD_LOGIC_VECTOR(k/2-1 DOWNTO 0)
				);
	END COMPONENT;
	
	COMPONENT reg
		GENERIC ( k : INTEGER := 16 ) ;
		PORT ( 
				--input ports
				clk, reset : IN STD_LOGIC ;
				ld : IN STD_LOGIC ;
				ldHigh, ldLow : IN STD_LOGIC ;
				input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
				
				--output ports
				output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
				);
	END COMPONENT ;
	
	COMPONENT mx4to1
		GENERIC ( num : INTEGER := 8 ) ;
		PORT ( 
			--input ports
			d0, d1, d2, d3 : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			sel0, sel1 : IN STD_LOGIC ;
	
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
	END COMPONENT;
	
BEGIN
	sr1 : entity work.SR_FF(behavior)
	port map (
			s => setint,
			r => resetf,
			clk => Clock, 
			clr => resetf,
			q => int
			);
	
	sr2 : entity work.SR_FF(behavior)
	port map (
			s => setcod,
			r => resetf,
			clk => Clock, 
			clr => resetf,
			q => cod
			);
	
	sr3 : entity work.SR_FF(behavior)
	port map (
			s => setadr,
			r => resetf,
			clk => Clock, 
			clr => resetf,
			q => adr
			);
	
	sr4 : entity work.SR_FF(behavior)
	port map (
			s => setnmi,
			r => resetnmi,
			clk => Clock, 
			clr => resetnmi,
			q => nmi
			);
	cd1 : entity work.cd(behavior)
	GENERIC MAP (k => len)
	PORT MAP (
			input => cd_in,
			w => prekid,
			output => cd_out
			);
	reg_ivtp : entity work.reg(behavior)
	GENERIC MAP (k => num)
	PORT MAP (
			Clock,
			reset,
			ldivtp,
			'0',
			'0',
			dBus,
			ivtp
			);
	mx : entity work.mx4to1(behavior)
	GENERIC MAP (num => len)
	PORT MAP (
			X"00", X"05", X"06", X"07", prl0, prl1, mp1_out
			);
	
	PROCESS (int,cod,adr,nmi,prper,pswt) IS
	BEGIN
		cd_in <= '0' & '0' & int & cod & adr & nmi & prper & pswt;
	END PROCESS;
		
	 
	br <=	 mp1_out when cd_out(0) = '1' and cd_out(1) = '0' and cd_out(2) = '0' and ldbr = '1' else
			 X"01" when cd_out(0) = '0' and cd_out(1) = '1' and cd_out(2) = '0' and ldbr = '1' else
			 X"02" when cd_out(0) = '1' and cd_out(1) = '1' and cd_out(2) = '0' and ldbr = '1' else
			 X"03" when cd_out(0) = '0' and cd_out(1) = '0' and cd_out(2) = '1' and ldbr = '1' else
			 ir2 when cd_out(0) = '1' and cd_out(1) = '0' and cd_out(2) = '1' and ldbr = '1' else
			 X"00" when ldbr = '1';
	
	PROCESS	(cd_out, intack) IS
	VARIABLE tmp : STD_LOGIC_VECTOR (num/2-1 DOWNTO 0) := X"00";
	VARIABLE intn_tmp, inta_tmp : STD_LOGIC := '0';
	BEGIN
	
		intn_tmp := (NOT cd_out(0)) AND cd_out(1) AND (NOT cd_out(2));
		inta_tmp := (NOT cd_out(0)) AND cd_out(2) AND (NOT cd_out(1));
		inta <= inta_tmp;
		
		resetnmi <= intn_tmp AND intack;
		
	END PROCESS;
	
	PROCESS (ivtpout, brout, ivtp, br) IS
	BEGIN	
		IF (ivtpout = '1') THEN
			sBus <= ivtp;
		ELSIF ( brout = '1') THEN
			sBus <= X"00" & br;
		ELSE 
			sBus <= (OTHERS => 'Z');
		END IF;
	END PROCESS;
			
	
END Behavior ;