

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;



ENTITY frequency IS
   PORT(
      clk            			:  IN    STD_LOGIC;                                
      reset          			:  IN    STD_LOGIC;
		button_increase			: 	in		std_logic;	
		button_decrease			: 	in		std_logic;			
      enable 						: 	in  STD_LOGIC; -- active-high enable
      freq  						: 	out integer
		
		
		);

END frequency;

ARCHITECTURE behavior OF frequency IS

signal plussing			: integer:=0;
--signal period				: integer:=0;
--signal current_count 	: integer;

type sixteen_steps is array (0 to 15) of integer;
constant j_cycle : sixteen_steps := (


(	48	)	,
(	250	)	,
(	400	)	,
(	600	)	,
(	800	)	,
(	1000	)	,
(	1200	)	,
(	1400	)	,
(	1600	)	,
(	1800	)	, 
(	2000	)	, 
(	2200	)	, 
(	2500	)	, 
(	2800	)	, 
(	3000	)	, 
(	3200	)	

);
begin
	stepping : process(clk, reset)
		begin
		if(reset = '1') then
				plussing 	<= 0;
				
			
		elsif rising_edge(clk) then
				if enable = '1' then
						if plussing = 16	then
							plussing <= 0;
						end if;
						if button_increase = '1' and button_decrease = '0' then
							plussing 	<= plussing + 1 ;
						end if;
						
						
						if button_decrease = '1' and button_increase = '0' then
							plussing		<= plussing - 1 ;
						end if;
				else
					plussing	<= 16;
				end if;
				
		end if;
	end process stepping;

			freq <= j_cycle(plussing);


  


end behavior;