LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY amplitude_tb IS
END amplitude_tb;

Architecture tb of amplitude_tb is


component amplitude 
   PORT(
      clk            			:  IN    STD_LOGIC;                                
      reset          			:  IN    STD_LOGIC;    
		button_increase			: 	in		std_logic;	
		button_decrease			: 	in		std_logic;		
      duty_cycle     			:  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
		);

END component;

   signal clk, reset, button_increase, button_decrease 	: std_logic;
   signal duty_cycle 												: std_logic_vector(8 downto 0); -- must change to match width of instantiation width
   constant clk_period 												: time := 10 ns;  
  
begin

uut : amplitude
         port map(
                   reset     				 => reset,
                   clk       				 => clk,
                   duty_cycle					=> duty_cycle,
                   button_increase   	 => button_increase,
						 button_decrease   	 => button_decrease

                  );
			
   clk_process : process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
 
   reset_proc : process
   begin      
      reset <= '1';
      wait for 2*clk_period;   
      reset <= '0';
      wait;		
   end process;
		
   button_increase_proc: process
   begin  
		button_increase <= '0';
      wait for 10*clk_period;   
      button_increase <= '1';
      wait for 50*clk_period; 	
      

   end process;	
	
	   button_decrease_proc: process
   begin  
		button_decrease <= '0';
      wait for 10*clk_period;   
      button_decrease <= '0';
      wait for 100*clk_period; 	
      

   end process;
					
end;	