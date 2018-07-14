--##########################
--
--	author: Milan Brankovic
--
--	file: reg_file.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY reg_file IS
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
			output : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0);
			bx_reg, bp_reg, si_reg, di_reg : OUT STD_LOGIC_VECTOR(num-1 DOWNTO 0)
			);
END reg_file;

ARCHITECTURE Behavior OF reg_file IS
	SIGNAL out_value : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
	SIGNAL ax, bx, cx, dx, si, di, sp_v, bp : STD_LOGIC_VECTOR(num-1 DOWNTO 0) := X"0000";
	
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
			 ) ;
	END COMPONENT ;
	
	COMPONENT sp
		GENERIC ( k : INTEGER := 16 ) ;
		PORT (
			--input ports
			clk, reset : IN STD_LOGIC ;
			ld : IN STD_LOGIC ;
			inc, dec : IN STD_LOGIC ;
			input : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0) ;
			
			--output ports
			output : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0)
			 ) ;
	END COMPONENT ;
	
BEGIN	
	reg_ax : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ldax, '0', '0', input, ax ) ;
	reg_bx : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ldbx, '0', '0', input, bx ) ;
	reg_cx : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ldcx, '0', '0', input, cx ) ;
	reg_dx : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, lddx, '0', '0', input, dx ) ;
	reg_si : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ldsi, '0', '0', input, si ) ;
	reg_di : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, lddi, '0', '0', input, di ) ;
	reg_bp : entity work.reg(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ldbp, '0', '0', input, bp ) ;
	reg_sp : entity work.sp(Behavior)
		GENERIC MAP ( k => num )
		PORT MAP ( Clock, reset, ldsp, inc_sp, dec_sp, input, sp_v ) ;
	
	PROCESS (axout, bxout, cxout, dxout,
			siout, diout, spout, bpout, 
			ax,bx,cx,dx,si,di,sp_v,bp) IS
	BEGIN
		IF (axout = '1' ) THEN 
			output <= ax;
		ELSIF(bxout = '1') THEN
			output <= bx;
		ELSIF(cxout = '1') THEN
			output <= cx;
		ELSIF(dxout = '1') THEN
			output <= dx ;
		ELSIF(siout = '1' ) THEN
			output <= si;
		ELSIF(diout = '1' ) THEN
			output <= di;
		ELSIF(bpout = '1' ) THEN
			output <= bp;
		ELSIF(spout = '1') THEN
			output <= sp_v;
		ELSE
			output <= (others => 'Z');
		END IF;
	END PROCESS;
	
	PROCESS (bx, bp, si, di, Clock) IS
	BEGIN
		bx_reg <= bx;
		bp_reg <= bp;
		si_reg <= si;
		di_reg <= di;
	END PROCESS;
			
END Behavior ;