-- 2 to 1 multiplexer

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux2to1 is

generic(bits : integer := 1);

port( 		
			in1 			: in std_logic_vector(bits-1 downto 0);
			in2 			: in std_logic_vector(bits-1 downto 0);
			switch 		: in std_logic;
			mux_out 		: out std_logic_vector(bits-1 downto 0)
			);
end mux2to1;

architecture behavior of mux2to1 is
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