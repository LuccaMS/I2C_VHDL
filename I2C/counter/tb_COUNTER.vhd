library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_COUNTER is 
end tb_COUNTER;


architecture behavioral of tb_COUNTER is 

component COUNTER is Port 
( 
		i_RST 		: in std_logic;
		i_CLK   		: in std_logic;
  	 	i_NEW_EDGE  : in std_logic;
      o_ND	 		: out std_logic
);
end component;

	signal w_RST : std_logic;
	signal w_CLK : std_logic;
	signal w_NEW_EDGE : std_logic;
	
	signal w_ND : std_logic;
	
	
begin

UUT : COUNTER
PORT MAP
(
		i_RST   => w_RST,
		i_CLK 	=> w_CLK,
		i_NEW_EDGE 		=> w_NEW_EDGE,
		o_ND		=> w_ND
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
	w_NEW_EDGE <= '1';
	wait for 5000 ns;
	w_NEW_EDGE <= '0';
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






