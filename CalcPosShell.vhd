library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use work.Projet_pack.all;

entity CalcPosShell is  -- this entity is to calculate the position of the arrow/bomb/shell
	port 
	(	signal Clk		    : in std_logic;
		signal InitS		: in std_logic; -- sw[1]
		signal EndImage 	: in std_logic;
		signal Pause		: in std_logic; -- to pause game
		signal Fire		    : in std_logic;
		signal iAngle		: in integer range 1 to 13; -- 13 options of shoting
		signal iXShell		: out integer range 0 to iXABCD; -- --1320
		signal iYShell		: out integer range 0 to iYABCD  -- --628
	);
end CalcPosShell;


architecture CalcPosShell_arch of CalcPosShell is
	type T_State is ( INIT, MOUNT, DESCEND, endd);
	signal State			: T_State; -- 4 states for 4 swiches
	signal iCtXShell		: integer range 0 to iXABCD; --1320
	signal iCtYShell		: integer range 0 to iYABCD; --628
	signal iDepX		    : integer range 0 to iXABCD; --1320
	signal iDepY		    : integer range 0 to iYABCD; --628
	signal iCtImage		    : integer range 0 to 9;

begin	
	process (Clk)
	begin
		if (Clk'event and Clk = '1') then
			if (InitS='1') then -- when action -- sw[1]
					State	<= INIT; -- one of the 4 states
					iCtXShell	<= iXAB-1+(iLShell/2);   --origin X   270 - 1 +   -- 50/2
					iCtYShell	<= iYABC-(iHShell/2);    --max Y    627  - 40/2
			elsif (EndImage='1' and Pause='0') then	  -- SW(2)
				case State is
					when INIT => -- what happen when active
						iCtImage	<= 5; -- 0
						iCtXShell	<= iXAB-1+(iLShell/2); --origin X   270 - 1 +   -- 50/2 becuase every time is /2
						iCtYShell	<= iYABC-(iHShell/2);   --max Y    627 - 40/2
						iDepX		<= iTab10DepX(iAngle)/10;    --  T_Tab13Int := (99, 98, 95, 91, 87, 81, 74, 67, 59, 50, 41, 31, 21); /10
						iDepY		<= iTab10DepY(iAngle)/10;    --  T_Tab13Int := (10, 21, 31, 41, 50, 59, 67, 74, 81, 87, 91, 95, 98); / 10
						if (Fire='1') then  -- SW(0)
							State	<= MOUNT; 
						end if;
					when MOUNT =>  -- what happen when action the swiches -- one of the 4 states
						if (iCtImage >=  9) then
							iCtImage	<= 0;
							iDepY		<= iDepY - 1;
						else
							iCtImage	<= iCtImage + 1;
						end if;
						iCtXShell	<= iCtXShell + iDepX;
						iCtYShell	<= iCtYShell - iDepY;
						if (	(iDepY <= 0) or ((iCtYShell-iHShell/2) <= iYAB) or ((iCtXShell+iLShell/2) >= iXABC)	) then
							State <= DESCEND;
						end if;
						
					when DESCEND => -- what happen when pause -- one of the 4 states
						if (iCtImage >=  9) then
							iCtImage	<= 0;
							iDepY		<= iDepY + 1;
						else
							iCtImage	<= iCtImage + 1;
						end if;
						if ( ((iCtXShell+iLShell/2) >= iXABC) or ((iCtYShell+iHShell/2) >= iYABC)	) then
							State <=endd;
						else
							iCtXShell	<= iCtXShell + iDepX;
							iCtYShell	<= iCtYShell + iDepY;
						end if;
							
					when endd =>  -- black screen -- one of the 4 states
						iCtXShell	<= iCtXShell;
						iCtYShell	<= iCtYShell;
						
				end case;
			end if;
		end if;
	end process;
	
	iXShell	<= iCtXShell;
	iYShell	<= iCtYShell;
	
end CalcPosShell_arch;