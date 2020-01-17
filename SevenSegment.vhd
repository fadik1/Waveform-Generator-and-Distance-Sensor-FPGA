-- --- Seven segment component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegment is
    Port ( DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0);
           Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5                         : out STD_LOGIC_VECTOR (7 downto 0)
          );
end SevenSegment;
architecture Behavioral of SevenSegment is

--Note that component declaration comes after architecture and before begin (common source of error).
   Component SevenSegment_decoder is 
      port(  H     : out STD_LOGIC_VECTOR (7 downto 0);
             input : in  STD_LOGIC_VECTOR (3 downto 0);
             DP    : in  STD_LOGIC                               
          );                  
   end  Component; 

type NUM is array(0 to 5) of std_logic_vector(3 downto 0);
signal NUM_x: NUM;	
type HEX is array(0 to 5) of std_logic_vector(7 downto 0);
signal HEX_x: HEX;

begin


	Seven_segment_loop: for i in 0 to 5 generate
		begin
			FAx: SevenSegment_decoder port map	(	H				=>	HEX_x(i),
																input			=>	NUM_x(i),
																DP				=>	DP_in(i)
															);
		end generate Seven_segment_loop;
   NUM_x(0)		<=			Num_Hex0;
	NUM_x(1)		<=			Num_Hex1;
	NUM_x(2)		<=			Num_Hex2;
	NUM_x(3)		<=			Num_Hex3;
	NUM_x(4)		<=			Num_Hex4;
	NUM_x(5)		<=			Num_Hex5;
	HEX0			<=			HEX_x(0);
	HEX1			<=			HEX_x(1);
	HEX2			<=			HEX_x(2);
	HEX3			<=			HEX_x(3);
	HEX4			<=			HEX_x(4);
	HEX5			<=			HEX_x(5);
	
end Behavioral;