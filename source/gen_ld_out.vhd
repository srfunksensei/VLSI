--##########################
--
--	author: Milan Brankovic
--
--	file: gen_ld_out.vhd
--
--###########################

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_signed.all ;

ENTITY gen_ld_out IS
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
END gen_ld_out;

ARCHITECTURE Behavior OF gen_ld_out IS
BEGIN	
	PROCESS (ldREG, REGout,
			axsel, bxsel, cxsel, dxsel, 
			spsel, bpsel, sisel, disel,
			bxout2, bpout2, siout2, diout2,
			upldSP, upSPout) IS 
			BEGIN
				ldax <= ldREG AND axsel;
				ldbx <= ldREG AND bxsel;
				ldcx <= ldREG AND cxsel;
				lddx <= ldREG AND dxsel;
				ldsi <= ldREG AND sisel;
				lddi <= ldREG AND disel;
				ldbp <= ldREG AND bpsel;
				ldsp <= (ldREG AND spsel) OR upldSP;
				
				axout <= REGout AND axsel;
				bxout <= (REGout AND bxsel) OR bxout2;
				cxout <= REGout AND cxsel;
				dxout <= REGout AND dxsel;
				siout <= (REGout AND sisel) OR siout2;
				diout <= (REGout AND disel) OR diout2;
				spout <= (REGout AND spsel) OR upSPout;
				bpout <= (REGout AND bpsel) OR bpout2;
	END PROCESS;		
END Behavior ;