library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux2to1lab4 is



port( 		
			in1 			: in 	integer;
			in2 			: in	integer;
			switch 		: in 	std_logic;
			mux_out 		: out integer
			);
end mux2to1lab4;

architecture behavior of mux2to1lab4 is
			begin
				process (switch,in1,in2)
					begin	
						if			switch ='0' then
							mux_out <= in1;
						elsif 	switch ='1' then
							mux_out <= in2;
						end if;
						
				end process;
				
end behavior;