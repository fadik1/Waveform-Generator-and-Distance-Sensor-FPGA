library ieee;
use ieee.std_logic_1164.all;

entity tb_mux is
end tb_mux;

architecture behavior of tb_mux is

component mux2to1 is
	port( W : in std_logic_vector(11 downto 0);
			V : in std_logic_vector(11 downto 0);
			S : in std_logic;
			F : out std_logic_vector(11 downto 0)
			);
	end component;
	
	signal S_i : std_logic:='0';
	signal W_i : std_logic_vector(11 downto 0):=(others => '0');
	signal V_i : std_logic_vector(11 downto 0):=(others => '0');
	signal F_i : std_logic_vector(11 downto 0);
	
begin
	uut: mux2to1
	port map (
					W	=> W_i,
					V	=> V_i,
					S	=> S_i,
					F	=> F_i
				);
				
stim_proc: process
begin
	S_i	<= '0';
	W_i	<= "000000001000";
	V_i	<= "100000000000";
	wait for 100 ns;
	W_i	<= "001000000001";
	V_i	<= "000010001000";
	wait for 100 ns;
	S_i	<= '1';
	W_i	<= "000100000000";
	V_i	<= "000000001100";
	wait for 100 ns;
	W_i	<= "001000101001";
	V_i	<= "000010110010";
	wait for 100 ns;
	
	wait;
end process;
end;
	