
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



ENTITY amplitude IS
   PORT(
      clk            			:  IN    STD_LOGIC;                                
      reset          			:  IN    STD_LOGIC; 
		enable          			:  IN    STD_LOGIC;    
		button_increase			: 	in		std_logic;	
		button_decrease			: 	in		std_logic;		
      duty_cycle     			:  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
		);

END amplitude;

ARCHITECTURE behavior OF amplitude IS

signal plussing: integer:=0;

type sixteen_steps is array (0 to 15) of integer;
constant j_cycle : sixteen_steps := (


(	0	)	,
(	32	)	,
(	64	)	,
(	96	)	,
(	128	)	,
(	160	)	,
(	192	)	,
(	224	)	,
(	288	)	,
(	320	)	, 
(	352	)	, 
(	384	)	, 
(	416	)	, 
(	448	)	, 
(	480	)	, 
(	511	)	

);
begin
	stepping : process(clk, reset)
		begin
		if(reset = '1') then
				plussing 	<= 0;
				
			
		elsif rising_edge(clk) then
				if enable = '0' then
						if plussing = 16	then
							plussing <= 0;
						end if;
						if button_increase = '1' and button_decrease = '0' then
							plussing 	<= plussing + 1 ;
						end if;
						
						
						if button_decrease = '1' and button_increase = '0' then
							plussing		<= plussing - 1 ;
						end if;
				end if;
				
		end if;
	end process stepping;

			duty_cycle <= std_logic_vector(to_unsigned(j_cycle(plussing), duty_cycle'length));




end behavior;