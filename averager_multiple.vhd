-- averages 16 samples
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity averager_multiple is
	port (
		  clk   : in  std_logic;
		  EN    : in  std_logic;
		  reset : in  std_logic;
		  Din   : in  std_logic_vector(11 downto 0);
		  Q     : out std_logic_vector(11 downto 0));
	end averager_multiple;

architecture rtl of averager_multiple is

type reg_for is array(0 to 3) of std_logic_vector(11 downto 0);
type temp_for is array(0 to 14) of integer;

signal tmp16 : std_logic_vector(15 downto 0);

signal data_for: reg_for;
signal plussing: integer;


begin

shift_reg : process(clk, reset)
	begin
	
		if(reset = '1') then
			data_for 	<= (others => (others => '0') );
			Q     		<= (others => '0');
			
		elsif rising_edge(clk) then
			if EN = '1' then
				plussing 	<= 0;
				data_for(0) <= Din;
				plussing		<=	to_integer(unsigned(data_for(0)));
				
				loop_1: for i in 1 to data_for'length-1 loop
					data_for(i) <= data_for(i-1);
					plussing		<=		plussing 	+ 	to_integer(unsigned(data_for(i)));	
				end loop loop_1;
				
				Q <= tmp16(15 downto 4); 
			end if;
		end if;
	end process shift_reg;
	
	
	  
tmp16 <= std_logic_vector(to_unsigned(plussing, tmp16'length));
	
end rtl;

