library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity Projet is

	port
	(	--input	
		Horloge50MHz			:in std_logic;
		v3KEY					:in std_logic_vector(2 downto 0);	--poussoirs de la maquette
		v10SW					:in std_logic_vector(9 downto 0);	--inters de la maquette	
		
		v8LEDG				    :out std_logic_vector(7 downto 0);
		
		R						:out std_logic;
		G						:out std_logic;
		B						:out std_logic;
		VGA_SynchroLine		    :out std_logic;
		VGA_SynchroFrame		:out std_logic
	);
end Projet;

use work.Projet_pack.all;
Architecture Projet_arch of Projet is
	
	signal EnVGA_int		: std_logic;
	signal Pause_int		: std_logic;
	
	signal EndLine_int	    : std_logic;	
	signal EndImage_int	    : std_logic;
	signal InitS_int 		: std_logic;
	signal Fire_int		    : std_logic;
	
	signal Plus_int		    : std_logic;
	signal iAngle_int		: integer range 1 to 13;
	
	signal iX_int			: integer range 0 to iXABCD;
	signal iY_int			: integer range 0 to iYABCD;
	
	signal iXShell_int		: integer range 0 to iXABCD;
	signal iYShell_int		: integer range 0 to iYABCD;
	
	signal iXTarget_int		: integer range 0 to iXABCD;
	signal iYTarget_int		: integer range 0 to iYABCD;
begin
   Fire_int 	<= v10SW(0); --active
	InitS_int <= v10SW(1); --action
	Pause_int <= v10SW(2); -- pause 
	EnVGA_int <= not v10SW(3); --black screen
	Plus_int	<= v3KEY(2); --change distance
	v8LEDG(4) <= EnVGA_int;  --led is on if screen is working
	v8LEDG(3)	<= (not InitS_int) and (not Pause_int); --for the pause
	 
	
	CounterX_Ex1 : CounterX
		port map
		(	Clk			=>	Horloge50MHz,
			iX				=>	iX_int,
			EnVGA			=>	EnVGA_int,
			SynchroLine 	=> 	VGA_SynchroLine,
			EndLine		=>	EndLine_int
		);
	
	CounterY_Ex1 : CounterY
		port map
		(	Clk			=>	Horloge50MHz,
			EnC			=>	EndLine_int,
			iY				=>	iY_int,
			SynchroFrame 	=> 	VGA_SynchroFrame,
			EndImage	 	=> 	EndImage_int			
		);
		
	GeneRGB_Ex1 : GeneRGB 	
		port map
		(	iX			=>	iX_int,
			iY			=>	iY_int,
			iXShell		=>	iXShell_int,
			iYShell		=>	iYShell_int,
			iXTarget		=>	iXTarget_int,
			iYTarget		=>	iYTarget_cte,
			iAngle		=>	iAngle_int,
	        Fire	=>	Fire_int,
			R			=>	R,
			G			=>	G,
			B			=>	B
		);

	CalcPosShell_Ex1 : CalcPosShell 
		port map
		(	Clk		=>	Horloge50MHz,
			InitS		=>	InitS_int, -- -- sw[1]
			EndImage 	=>	EndImage_int,
			Pause		=>	Pause_int,     		Fire	=>	Fire_int,
			iAngle		=>	iAngle_int,
			iXShell		=>	iXShell_int,
			iYShell		=>	iYShell_int
		);
		
	CalcPosTarget_Ex1 : CalcPosTarget
		port map
		(	Clk		=>	Horloge50MHz,
			Random		=>	InitS_int,
			iXTarget		=>	iXTarget_int
		);
		
	CalcAngle_Ex1 : CalcAngle
		port map
		(	
			Plus		=>	Plus_int,
			iAngle		=>	iAngle_int
		);
	
	
end Projet_arch;





