library ieee;
use ieee.std_logic_1164.all;

entity multiple_registers is

generic(bits : integer := 1);
 
port( 
	  clk       : in  std_logic;
	  reset     : in  std_logic;
	  enable    : in  std_logic;
     d_inputs  : in  std_logic_vector(bits-1 downto 0);
	  q_outputs : out std_logic_vector(bits-1 downto 0)	
    );
end entity;

architecture rtl2 of multiple_registers is

type reg_for is array(0 to 0) of std_logic_vector(bits-1 downto 0);				--set the array to one-less value ex; if you want 4 registers, set 0 to 2
signal data_for: reg_for;

begin

shift_reg : process(clk, reset)
	begin
	
		if(reset = '1') then
			data_for 			<= (others => (others => '0') );
			q_outputs     		<= (others => '0');
			
		elsif rising_edge(clk) then
			if enable = '1' then
				data_for(0) <= d_inputs;
				
				loop_1: for i in 1 to data_for'length-1 loop
					data_for(i) <= data_for(i-1);
				end loop loop_1;
				
				q_outputs <= data_for(data_for'length-1); 
			end if;
		end if;
	end process shift_reg;

		
end rtl2;