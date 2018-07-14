--##########################
--
--	author: Milan Brankovic
--
--	file: reg_sel.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_signed.all ;

ENTITY reg_sel IS
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
			
			--output ports
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp : OUT STD_LOGIC;
			axout, bxout, cxout, dxout, siout, diout, spout, bpout : OUT STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
END reg_sel;

ARCHITECTURE Behavior OF reg_sel IS
	SIGNAL out_mx1 : STD_LOGIC_VECTOR(len-1 DOWNTO 0) := B"000";
	SIGNAL out_mx2, out_mx3 : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
	SIGNAL out_dc1, out_dc2 : STD_LOGIC_VECTOR(2*len+1 DOWNTO 0) := x"00";
	SIGNAL e1, e2 : STD_LOGIC := '0';
	
	
	COMPONENT mx2to1
		GENERIC ( num : INTEGER ) ;
		PORT ( 
			--input ports
			d0, d1 : IN STD_LOGIC_VECTOR(num-1 DOWNTO 0) ;
			sel : IN STD_LOGIC ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
	END COMPONENT ;
	
	COMPONENT dc
		GENERIC ( k : INTEGER := 3 ) ;
		PORT ( 
			--input ports
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			e : IN STD_LOGIC;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(2*k+1 DOWNTO 0)
			);
	END COMPONENT ;
	
	COMPONENT gen_ld_out
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
	END COMPONENT;
	
BEGIN
	PROCESS (fdo, fvo, regdir, daREG, regind, regindpom, REGout) IS
	BEGIN
		e1 <= ((fdo OR fvo) AND regdir) OR daREG;
		e2 <= (regind OR regindpom) AND fdo AND REGout;
	END PROCESS;
	
	mx1 : entity work.mx2to1(Behavior)
		GENERIC MAP ( num => len )
		PORT MAP ( ir2_2_0, ir2_5_3, daREG, out_mx1 ) ;
	mx2 : entity work.mx2to1(Behavior)
		GENERIC MAP ( num => num )
		PORT MAP ( bx, bp, ir2_2_0(1), out_mx2 ) ;
	mx3 : entity work.mx2to1(Behavior)
		GENERIC MAP ( num => num )
		PORT MAP ( si, di, ir2_2_0(0), out_mx3 ) ;
	dc1 : entity work.dc(Behavior)
		GENERIC MAP ( k => len )
		PORT MAP ( out_mx1, e1, out_dc1 ) ;
	dc2 : entity work.dc(Behavior)
		GENERIC MAP ( k => len )
		PORT MAP ( ir2_2_0, e2, out_dc2 ) ;
	ld_out : entity work.gen_ld_out(Behavior)
		PORT MAP ( ldREG, REGout,
			out_dc1(0), out_dc1(1), out_dc1(2), out_dc1(3), 
			out_dc1(4), out_dc1(5), out_dc1(6), out_dc1(7),
			out_dc2(0), out_dc2(1), out_dc2(2), out_dc2(3),
			upldSP, upSPout,
			ldax, ldbx, ldcx, lddx, ldsi, lddi, ldsp, ldbp,
			axout, bxout, cxout, dxout, siout, diout, spout, bpout) ;
	
	PROCESS (out_dc2, out_mx2, out_mx3) IS
	VARIABLE ADDout : STD_LOGIC := '0';
	BEGIN
		--	bx_si OR bx_di OR bp_si OR bp_di;
		ADDout := out_dc2(4) OR out_dc2(5) OR out_dc2(6) OR out_dc2(7);
		
		IF (ADDout = '1') THEN
			output <= out_mx2 + out_mx3;
		ELSE
			output <= (others => 'Z');
		END IF;
	END PROCESS;
	
END Behavior ;