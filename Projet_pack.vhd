library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;


Package Projet_pack is
	--those are properties of the screen.
	constant iXA		:integer	:=160;      --160
	constant iXAB		:integer	:=270;		--origin X   270
	constant iXABC		:integer	:=1270;		--max X  1270
	constant iXABCD		:integer	:=1320;     --1320
	
	constant iYA		:integer	:=4;        --4
	constant iYAB		:integer	:=27;		--origin Y   27 
	constant iYABC		:integer	:=627;		--max Y    627
	constant iYABCD		:integer	:=628;      --628
	
	constant iDep		:integer	:=10; --10
	
	constant iXSPOT	    :integer	:=(iXAB+iXABC)/2;  -- (iXAB+iXABC)/2
	constant iYSPOT	    :integer	:=(iYAB+iYABC)/2;   --(iYAB+iYABC)/2
	
	constant iLShell	:integer	:=50;  -- 50
	constant iHShell	:integer	:=40;   -- 40
	

	constant iYTarget_cte	:integer	:=(iYABC-(iYAB*3)); -- 627-27*3 maximum 

	type T_Tab13Int is Array(1 to 13) of integer;	-- Variable call : iTab10Dep(X)
	constant iTab10DepX	: T_Tab13Int := (99, 98, 95, 91, 87, 81, 74, 67, 59, 50, 41, 31, 21); -- Length of the canon when shot
	constant iTab10DepY	: T_Tab13Int := (10, 21, 31, 41, 50, 59, 67, 74, 81, 87, 91, 95, 98); -- widht of the canon when shot
	
	type T_Tab7Int is Array (0 to 6) of integer ;
	constant iTabRandom : T_Tab7Int:=
	(iXSPOT, 100, 400, 600, 300, 50, 400); -- WHERE THE TARGET IS
	
	--components
	component CalcPosShell -- THE Canon
	port 
		(	signal Clk		    : in std_logic;
			signal InitS		: in std_logic; -- sw[1]
			signal EndImage 	: in std_logic;
			signal Pause		: in std_logic; --  sw[2]
			signal Fire		    : in std_logic; --SW(0)
			signal iAngle		: in integer range 1 to 13;
			signal iXShell		: out integer range 0 to iXABCD;
			signal iYShell		: out integer range 0 to iYABCD
		);
	end component;
	
	component CalcPosTarget -- the target
	port
		(	signal Clk		    : in std_logic;
			signal Random 		: in std_logic;
			signal iXTarget 	: out integer range 0 to iXABCD
			);
	end component;	
		
	component CalcAngle -- the angle of the canon
	port
		(	signal Plus	    : in	std_logic;
			signal iAngle	: out	integer range 1 to 13
		);
	end component;
	
	component GeneRGB  -- VGA display
		port 
		(	signal iX		: in integer range 0 to iXABCD;
			signal iY		: in integer range 0 to iYABCD;
			signal iXShell	: in integer range 0 to iXABCD;
			signal iYShell	: in integer range 0 to iYABCD;
			signal iXTarget	: in integer range 0 to iXABCD;
			signal iYTarget	: in integer range 0 to iYABCD;
			signal iAngle	: in integer range 1 to 13;
			signal Fire	    : in std_logic;
			signal R		: out std_logic;
			signal G		: out std_logic;
			signal B		: out std_logic
		);
	end component;	
	
	component CounterY is --Y 
		port 
		(	signal Clk			: in 	STD_LOGIC;
			signal EnC			: in 	STD_LOGIC;
			signal iY			: buffer integer range 0 to iYABCD;
			signal SynchroFrame	: out std_logic;
			signal EndImage		: out std_logic
		);
	end component;
	
	component CounterX  --X 
		port 
		(	signal Clk			: in 	STD_LOGIC;
			signal iX			: buffer integer range 0 to iXABCD;
			signal EnVGA		: in	STD_LOGIC;
			signal SynchroLine	: out std_logic;
			signal EndLine		: out std_logic
		);
	end component;	
	
--component declaration
	component Projet
		port
		(	--inputs
			Horloge50MHz			:in std_logic;
			v3KEY					:in std_logic_vector(2 downto 0);	
			v10SW					:in std_logic_vector(9 downto 0);	
			
			v8LEDG				    :out std_logic_vector(7 downto 0);
			
			R						:out std_logic;
			G						:out std_logic;
			B						:out std_logic;
			VGA_SynchroLine		    :out std_logic;
			VGA_SynchroFrame		:out std_logic
		);
	end component;
	
end Projet_pack;

