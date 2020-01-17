library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Voltmeter_tb is
end Voltmeter_tb;

architecture test of Voltmeter_tb is 

signal clk, reset																				: STD_LOGIC;
signal LEDR																						: STD_LOGIC_VECTOR (9 downto 0);
signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5												: STD_LOGIC_VECTOR (7 downto 0);
signal switch_v2d																				: std_logic:='0';
signal switch_0,switch_1,switch_2, TT_0,TT_1, PWM_OUT_voltmeter, switch_buzz, ampl_freq_switch, PWM_OUT_buzz  						: STD_LOGIC;

constant clk_period 														: time:= 20 ns;
component voltmeter is
	Port ( 
				clk                           						: in  STD_LOGIC;
           reset                         							: in  STD_LOGIC;
			  switch_v2d  													: in  STD_LOGIC;
			  switch_0														: in std_logic;
			  switch_1														: in std_logic;
			  switch_2														: in std_logic;
			  TT_0															: in std_logic;
			  TT_1															: in std_logic;
			  ampl_freq_switch											: in std_logic;
			  switch_buzz													: in std_logic;
           LEDR                          							: out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 							: out STD_LOGIC_VECTOR (7 downto 0);
			  PWM_OUT_voltmeter											: out std_logic;
			  PWM_OUT_buzz													: out std_logic
			);
			 
end component;

begin

v : voltmeter
port map(
clk => clk,
reset => reset,
LEDR  => LEDR,
HEX0  => HEX0,
HEX1  => HEX1,
HEX2  => HEX2,
HEX3  => HEX3,
HEX4  => HEX4,
HEX5  => HEX5,
PWM_OUT_voltmeter => PWM_OUT_voltmeter,
switch_v2d		=> switch_v2d,
switch_0 => switch_0,
switch_1 => switch_1,
switch_2 => switch_2,
TT_1		=> TT_1,
TT_0		=> TT_0,
PWM_OUT_buzz => PWM_OUT_buzz,
ampl_freq_switch => ampl_freq_switch,
switch_buzz 		=> switch_buzz

);

clk_process: process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;
		
stim_proc: process
	begin
		reset <= '0';
		wait for (5*clk_period);
		reset <= '1';
		wait for (5*clk_period);
		reset <= '0';
		wait;

	end process;

voltage2distance_process: process
	begin
		switch_v2d <= '0';
		wait for 175 ns;
		switch_v2d <= '1';
		wait for 175 ns;
	end process;
	
	switch_0_process: process
	begin
		switch_0 <= '0';
		wait for 500 ns;
		switch_0 <= '1';
		wait;
	end process;
	
	switch_1_process: process
	begin
		switch_1 <= '0';
		wait;

	end process;
		
	switch_2_process: process
	begin
		switch_2 <= '0';
		wait;

	end process;
	
	
	TT_0_process: process
	begin
		TT_0 <= '0';
		wait for 700 ns;
		TT_0 <= '1';
		wait for 700 ns;
	end process;
	
		TT_1_process: process
	begin
		TT_1 <= '0';
		wait for 1400 ns;
		TT_1 <= '1';
		wait for 1400 ns;
	end process;
	
		ampl_freq_switch_process: process
	begin
		ampl_freq_switch <= '0';
		wait for 1000 ns;
		ampl_freq_switch <= '1';
		wait;
	end process;

			switch_buzz_process: process
	begin
		switch_buzz <= '0';
		wait for 2000 ns;
		switch_buzz <= '1';
		wait;
	end process;
	

	
end;