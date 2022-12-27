library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity FPGA is
	port
	(	--input
		
		Horloge50MHz			:in std_logic; -- clock 50 hz
		v3KEY					:in std_logic_vector(2 downto 0); -- 3 keys
		v10SW					:in std_logic_vector(9 downto 0);	 -- 10 swiches
		
		--output
		
		v10LEDG				:out std_logic_vector(9 downto 0); -- 10 options for led, for the 4 swiches.
		v4VGA_R				:out std_logic_vector(3 downto 0); --rgb
		v4VGA_G				:out std_logic_vector(3 downto 0);--rgb
		v4VGA_B				:out std_logic_vector(3 downto 0);--rgb
		VGA_SynchroLine		:out std_logic;--rgb
		VGA_SynchroFrame	:out std_logic--rgb
		
	);
end FPGA;

use work.Projet_pack.all;

Architecture FPGA_arch of FPGA is
	signal R		: std_logic;
	signal G		: std_logic;
	signal B		: std_logic;
begin
	
	Proj : Projet
		port map
			(Horloge50MHz			=>	Horloge50MHz, -- clock 50 hz
			v3KEY					=>	v3KEY, -- clock 50 hz
			v10SW					=>	v10SW,	 -- clock 50 hz
			v8LEDG				=>	v10LEDG(7 downto 0), -- 8 options for led, for the 4 swiches.
			R						=>	R,
			G						=>	G,
			B						=>	B,
			VGA_SynchroLine		=>	VGA_SynchroLine,
			VGA_SynchroFrame		=>	VGA_SynchroFrame
		);
		
	RGB : for i in 0 to 3 generate 
		v4VGA_R(i) <=R;
		v4VGA_G(i) <= G;
		v4VGA_B(i) <= B;
	end generate RGB;

		
end FPGA_arch;





