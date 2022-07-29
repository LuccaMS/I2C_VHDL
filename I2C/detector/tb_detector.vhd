library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_detector is 
end tb_detector;

architecture behavioral of tb_detector is 

component DETECTOR is port
	(
		i_RST   			: in std_logic;
		i_CLK 			: in std_logic;
		--
		i_CLK_UART 		: in std_logic;
		o_EDGE_UP		: out std_logic;
		o_EDGE_DOWN		: out std_logic
	);
end component;

	signal w_RST : std_logic;
	signal w_CLK : std_logic;
	signal w_CLK_UART : std_logic;
	
	signal w_EDGE_UP : std_logic;
	signal w_EDGE_DOWN : std_logic;
	
	begin
	
	UUT : DETECTOR
	port map
	(
		i_RST   => w_RST,
		i_CLK 	=> w_CLK,
		i_CLK_UART 		=> w_CLK_UART,
		o_EDGE_UP		=> w_EDGE_UP,
		o_EDGE_DOWN		=> w_EDGE_DOWN
	);
	
	process
	begin
	w_CLK <= '1';
	wait for 10 ns;
	w_CLK <= '0';
	wait for 10 ns;
	end process;
	
	process 
	begin
	w_CLK_UART <= '1';
	wait for 5000 ns;
	w_CLK_UART <= '0';
	wait for 5000 ns;
	end process;
	
	process
	begin
	w_RST <= '1';
	wait for 10 ns;
	w_RST <= '0';
	wait;
	end process;
	
end behavioral;