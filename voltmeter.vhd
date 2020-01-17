

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;
 
entity Voltmeter is
    Port ( clk                           							: in  STD_LOGIC;
           reset                         							: in  STD_LOGIC;
			  switch_v2d  													: in  STD_LOGIC;
			  switch_0														: in std_logic;
			  switch_1														: in std_logic;
			  switch_2														: in std_logic;
			  TT_1															: in std_logic;
			  TT_0															: in std_logic;
			  ampl_freq_switch											: in std_logic;
			  switch_buzz													: in std_logic;
           LEDR                          							: out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 							: out STD_LOGIC_VECTOR (7 downto 0);
			  PWM_OUT_voltmeter											: out std_logic;
			  PWM_OUT_buzz													: out std_logic
          );
           
end Voltmeter;

architecture Behavioral of Voltmeter is

Signal A, Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 		: STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
Signal DP_in																					: STD_LOGIC_VECTOR (5 downto 0);
Signal ADC_read,rsp_data,q_outputs_2 													: STD_LOGIC_VECTOR (11 downto 0);
Signal voltage																					: STD_LOGIC_VECTOR (12 downto 0);
Signal busy																						: STD_LOGIC;
signal response_valid_out_i1,response_valid_out_i3 								: STD_LOGIC_VECTOR(0 downto 0);
Signal bcd																						: STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal Q_temp2 																				: std_logic_vector(11 downto 0);
signal distance_s																				: std_logic_vector(12 downto 0);
signal binary_bcd_s																			: std_logic_vector(12 downto 0);
signal clk_1kHz_pulse_i																		: STD_LOGIC;
signal PWM_OUT_i																				: STD_LOGIC;
signal zero_i																					: STD_LOGIC;
signal debounced_increase																	: STD_LOGIC;
signal debounced_decrease																	: STD_LOGIC;
signal amplitude_wave_gen																	: std_logic_vector(8 downto 0);
signal frequency_wave_gen																	: integer;
signal mux4_out																				: integer;
signal amp_buzz																				: std_logic_vector(12 downto 0);
--signal frq_buzz																				: STD_LOGIC;
signal downcounter_buzz																		: integer;
signal zero_b																					: STD_LOGIC;




Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component ADC_Conversion is
    Port( MAX10_CLK1_50      : in STD_LOGIC;
          response_valid_out : out STD_LOGIC;
          ADC_out            : out STD_LOGIC_VECTOR (11 downto 0)
         );
End Component ;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset   : IN  STD_LOGIC;                      --active low asynchronus reset
      ena     : IN  STD_LOGIC;                      --latches in new binary number and starts conversion
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      busy    : OUT STD_LOGIC;                      --indicates conversion in progress
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;

Component registers is
   generic(bits : integer);
   port
     ( 
      clk       : in  std_logic;
      reset     : in  std_logic;
      enable    : in  std_logic;
      d_inputs  : in  std_logic_vector(bits-1 downto 0);
      q_outputs : out std_logic_vector(bits-1 downto 0)  
     );
END Component;

Component averager is
  port(
    clk, reset : in std_logic;
    Din 			: in  std_logic_vector(11 downto 0);
    EN  			: in  std_logic; -- response_valid_out
    Q   			: out std_logic_vector(11 downto 0)
    );
  end Component;

component	mux2to1 is
	generic(bits : integer);
	port(
			in1 : in std_logic_vector(bits-1 downto 0);
			in2 : in std_logic_vector(bits-1 downto 0);
			switch : in std_logic;
			mux_out : out std_logic_vector(bits-1 downto 0)
			);
end component;



component voltage2distance is
   PORT(
      clk            :  IN    STD_LOGIC;                                
      reset          :  IN    STD_LOGIC;  
      v_in		  	    :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
      distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0));  
END component;


component multiple_registers is
generic(bits : integer);
	port( 
	  clk       : in  std_logic;
	  reset     : in  std_logic;
	  enable    : in  std_logic;
     d_inputs  : in  std_logic_vector(bits-1 downto 0);
	  q_outputs : out std_logic_vector(bits-1 downto 0)	
    );
end component;


component wave_gen is
    Port ( reset						: in STD_LOGIC;
           clk 						: in STD_LOGIC;
           clk_1kHz_pulse 			: in STD_LOGIC;
			  state_0					: in STD_LOGIC;
			  state_1					: in STD_LOGIC;
			  state_2					: in STD_LOGIC;
			  duty_cycle_in			: in STD_LOGIC_VECTOR(8 DOWNTO 0);
--			  frequency_in				: in STD_LOGIC_VECTOR(8 DOWNTO 0);
           PWM_OUT 					: out STD_LOGIC
          );
end component;



component downcounter is
-- Generic ( period : natural := 1000); -- number to count       
    PORT ( clk    : in  STD_LOGIC; -- clock to be divided
           reset  : in  STD_LOGIC; -- active-high reset
			  period : in  integer;
           enable : in  STD_LOGIC; -- active-high enable
           zero   : out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
--           value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
end component;

component amplitude IS
   PORT(
      clk            			:  IN    STD_LOGIC;                                
      reset          			:  IN    STD_LOGIC;  
		enable          			:  IN    STD_LOGIC;    
		button_increase			: 	in		std_logic;
		button_decrease			: 	in		std_logic;		
      duty_cycle     			:  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
END component;

component frequency IS
   PORT(
      clk            			:  IN    STD_LOGIC;                                
      reset          			:  IN    STD_LOGIC;
		button_increase			: 	in		std_logic;	
		button_decrease			: 	in		std_logic;			
      enable 						: 	in  STD_LOGIC; -- active-high enable
      freq  						: 	out integer
		);						
END component;

component debounce1 IS
  --GENERIC(
    --counter_size  :  INTEGER := 20); --counter size (20 bits gives 10.5ms with 100MHz clock)
  PORT(
    clk     : IN  STD_LOGIC;  --input clock
    button  : IN  STD_LOGIC;  --input signal to be debounced
    reset   : IN  STD_LOGIC;  --reset
    result  : OUT STD_LOGIC   --debounced signal
    );
END component;


component mux2to1lab4 is



port( 		
			in1 			: in 	integer;
			in2 			: in	integer;
			switch 		: in 	std_logic;
			mux_out 		: out integer
			);
end component;

component wave_gen_buzz is
    Port ( reset						: in STD_LOGIC;
           clk 						: in STD_LOGIC;
           clk_1kHz_pulse 			: in STD_LOGIC;
			  state_0					: in STD_LOGIC;
			  state_1					: in STD_LOGIC;
			  state_2					: in STD_LOGIC;
			  duty_cycle_in			: in STD_LOGIC_VECTOR(12 DOWNTO 0);
           PWM_OUT 					: out STD_LOGIC

          );
end component;

begin
   Num_Hex0 <= bcd(3  downto  0); 
   Num_Hex1 <= bcd(7  downto  4);
   Num_Hex2 <= bcd(11 downto  8);
	
	leading_zeros_process: process(Num_Hex3, clk)
	begin
		if rising_edge(clk) then
			if Num_Hex3 = "0000" then
				Num_Hex3 <= "1111";
			else
				Num_Hex3 <= bcd(15 downto 12);
			end if;
		end if;
	end process;
			
			
   Num_Hex4 <= "1111";  -- blank this display
   Num_Hex5 <= "1111";  -- blank this display
	
	dp_process: process(switch_v2d)
	begin
		if switch_v2d = '0' then 
			DP_in    <= "001000";-- position of the decimal point in the display
		else
			DP_in		<= "000100";
		end if;
	end process;

	
	
voltage2distance_ins :		voltage2distance
			port map( 
						clk		=> clk,
						reset		=> reset,
						v_in		=> voltage,
						distance => distance_s
						);
						
						
lab3mux :		mux2to1
			generic map(bits => 13)
			port map( 
						in1		=> voltage,
						in2 		=> distance_s,
						switch	=> switch_v2d, 									
						mux_out	=> binary_bcd_s
						);
	

   
ave :    averager
         port map(
                  clk       => clk,
                  reset     => reset,
                  Din       => q_outputs_2,
                  EN        => response_valid_out_i3(0),
                  Q         => Q_temp2
                  );
   

sync_1	: multiple_registers
        generic map(bits => 12)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => ADC_read,
                 q_outputs => q_outputs_2
                );		


sync_2	: multiple_registers
        generic map(bits => 1)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => response_valid_out_i1,
                 q_outputs => response_valid_out_i3
                );
               
wave_jenn		:	 wave_gen 
    Port map (
				reset						=> reset,
           clk 						=> clk,
           clk_1kHz_pulse 			=>	zero_i,
			  state_0					=> switch_0,
			  state_1					=> switch_1,
			  state_2					=> switch_2,
			  duty_cycle_in			=> amplitude_wave_gen,
           PWM_OUT 					=> PWM_OUT_voltmeter
          );
			 
Downcounter_v	:	 downcounter 
 --Generic map ( period => 1000) -- number to count       
    PORT map ( 
				clk  		 	=> clk,
           reset  		=> reset,
			  period			=> mux4_out,
           enable 		=> '1',
           zero   		=> zero_i  
         );

			
debounce_increase		:	 debounce1 

  PORT map(
				clk     					=> clk,
				button  					=> TT_1,
				reset   					=> reset,
				result  					=> debounced_increase
			);
			
debounce_decrease		:	 debounce1 

	PORT map(
				clk     					=> clk,
				button  					=> TT_0,
				reset   					=> reset,
				result  					=> debounced_decrease
);
		
amplitude_v		:	 amplitude 
   PORT map(
				clk          			=> clk,                               
				reset        			=> reset,  
				enable					=> ampl_freq_switch,
				button_increase		=> debounced_increase,
				button_decrease		=> debounced_decrease,				
				duty_cycle   			=> amplitude_wave_gen
			);			

freq_v			:	 frequency 
   PORT map(
				clk          			=> clk,                               
				reset        			=> reset,  
				enable					=> ampl_freq_switch,
				button_increase		=> debounced_increase,
				button_decrease		=> debounced_decrease,				
				freq   					=> frequency_wave_gen
				
			);			
			



			
lab4mux :		mux2to1lab4
		port map( 
				in1		=> 1000,
				in2 		=> frequency_wave_gen,
				switch	=> ampl_freq_switch, 									
				mux_out	=> mux4_out
				);
	

wave_jenny		:	 wave_gen_buzz 
    Port map (
				reset						=> reset,
           clk 						=> clk,
           clk_1kHz_pulse 			=>	zero_b,
			  state_0					=> '1',
			  state_1					=> '0',
			  state_2					=> '0',
			  duty_cycle_in			=> amp_buzz,
           PWM_OUT 					=> PWM_OUT_buzz
          );	
			  
mux_amp_buzz :		mux2to1
			generic map(bits => 13)
			port map( 
						in1		=> distance_s,
						in2 		=> "1111111111111",
						switch	=> switch_buzz, 									
						mux_out	=> amp_buzz
						);

mux_frq_buzz :		mux2to1lab4
			port map( 
						in1		=> 50,
						in2 		=> (to_integer(unsigned(distance_s))/ 64)+1,
						switch	=> switch_buzz, 									
						mux_out	=> downcounter_buzz
						);

						
Downcounter_b	:	 downcounter 
 --Generic map ( period => 1000) -- number to count       
    PORT map ( 
				clk  		 	=> clk,
           reset  		=> reset,
			  period			=> downcounter_buzz,
           enable 		=> '1',
           zero   		=> zero_b  
         );
	
	
SevenSegment_ins: SevenSegment  
                  PORT MAP( Num_Hex0 => Num_Hex0,
                            Num_Hex1 => Num_Hex1,
                            Num_Hex2 => Num_Hex2,
                            Num_Hex3 => Num_Hex3,
                            Num_Hex4 => Num_Hex4,
                            Num_Hex5 => Num_Hex5,
                            Hex0     => Hex0,
                            Hex1     => Hex1,
                            Hex2     => Hex2,
                            Hex3     => Hex3,
                            Hex4     => Hex4,
                            Hex5     => Hex5,
                            DP_in    => DP_in
                          );
                                     
ADC_Conversion_ins:  ADC_Conversion  PORT MAP(      
                                     MAX10_CLK1_50       => clk,
                                     response_valid_out  => response_valid_out_i1(0),
                                     ADC_out             => ADC_read);
 
LEDR(9 downto 0) <=Q_temp2(11 downto 2); -- gives visual display of upper binary bits to the LEDs on board

-- in line below, can change the scaling factor (i.e. 2500), to calibrate the voltage reading to a reference voltmeter
voltage <= std_logic_vector(resize(unsigned(Q_temp2)*2500*2/4096,voltage'length));  -- Converting ADC_read a 12 bit binary to voltage readable numbers

binary_bcd_ins: binary_bcd                               
   PORT MAP(
      clk      => clk,                          
      reset    => reset,                                 
      ena      => '1',                           
      binary   => binary_bcd_s,    
      busy     => busy,                         
      bcd      => bcd         
      );
end Behavioral;