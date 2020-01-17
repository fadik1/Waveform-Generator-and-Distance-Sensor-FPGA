library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_wave_gen is
end tb_wave_gen;

architecture Behavioral of tb_wave_gen is

    component wave_gen is
        Port ( reset : in STD_LOGIC;
               clk : in STD_LOGIC;
               clk_1kHz_pulse :  in STD_LOGIC;              
               PWM_OUT : out STD_LOGIC
              );
        end component;
        
    signal reset,clk,PWM_OUT,clk_1kHz_pulse : std_logic;
              
    constant clk_period : time := 100 ns; -- 1/(100 ns) = 10 MHz

begin

    uut : wave_gen port map (
        reset => reset,
        clk => clk,
        clk_1kHz_pulse => clk_1kHz_pulse,
        PWM_OUT => PWM_OUT
        );

   -- Clock process
   ClkProcess : process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process; 
   
   -- clk_1kHz_pulse process
   kHz_pulse : process
   begin
        clk_1kHz_pulse <= '0';
        wait for clk_period*5000;
        clk_1kHz_pulse <= '1';
        wait for clk_period;
        clk_1kHz_pulse <= '0';
        wait for clk_period*4999;
   end process; 
   

   -- Reset process
   ResetProcess : process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';
      wait;
   end process; 
    
end Behavioral;
