library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux is

generic(bits : integer := 1);

port( 		
			in0 			: in	std_logic_vector(bits-1 downto 0);
			in1 			: in	std_logic_vector(bits-1 downto 0);
			in2 			: in	std_logic_vector(bits-1 downto 0);
			switch 		: in	std_logic_vector(1 downto 0);
			mux_out 		: out std_logic_vector(bits-1 downto 0)
			);
end mux;

architecture behavior of mux is

			begin
				process (switch,in0,in1,in2)
					begin	
						if			switch ='0' then
							mux_out <= in0;
						elsif 	switch ='1' then
							mux_out <= in1;
						elsif 	switch ='2' then
							mux_out <= in2;
						end if;
						
				end process;
				
end behavior;