library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use work.Projet_pack.all;

entity CalcPosTarget is 
	port 
	(	signal Clk		       : in std_logic;
		signal Random 		   : in std_logic; -- sw 1
		signal iXTarget 	   : out integer range 0 to iXABCD --1320 pixel
		
	);
end CalcPosTarget;

architecture CalcPosTarget_arch of CalcPosTarget is
	signal iNothing			: integer range 0 to 2312; -- 2312 counter for clock signal, around every 115ms refresh the target becuase 50MHz clock
	signal iCtXTarget		: integer range 0 to iXABC;
	signal iCtSelect        : integer range 0 to iXABC;
begin	
	process (Clk)
	begin
		if (Clk'event and Clk = '1') then -- when clk is up
			
			if (iCtSelect >= iXABC) then        --then we can show the target on the screen
				iCtSelect <= (iXAB+200); 

			else 
				iCtSelect <= iCtSelect + 100;
			end if;
			
			if(Random = '1') then -- the position of the target
				if(iNothing = 2312) then
					iNothing <= 0;
				else
				iNothing <= iNothing + 1;
				end if;	
			end if;
			if (Random = '1' and iNothing >= 2312) then 
				iCtXTarget <= iCtSelect;
			end if;
			
		end if;
	end process;
	iXTarget  <= iCtXTarget;
end CalcPosTarget_arch;