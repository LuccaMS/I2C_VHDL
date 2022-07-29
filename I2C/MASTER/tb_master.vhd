library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_master is
end tb_master;

architecture behavioral of tb_master is

component master is 
PORT(
	i_CLK : in std_logic;
	i_CLK_100_TEST : in std_logic;
	i_RST : in std_logic;
	en_SCL : out std_logic := '0'; 
	en_SDA : out std_logic := '0'; 
	i_EDGE : in std_logic; 
	o_LOAD : out std_logic;
	i_STARTBUTTON : in std_logic; 
	i_RESULT : in std_logic 
);	
end component;

	--ENTRADAS
	signal w_CLK : std_logic;
	signal w_CLK_100 : std_logic;
	signal w_RST : std_logic;
	--signal w_IsEdgeUp : std_logic;
	signal w_STARTBUTTON : std_logic;
	signal w_EDGE : std_logic;
	signal w_RESULT : std_logic;
	--SAÍDAS
	
	signal w_en_SCL : std_logic;
	signal w_en_SDA : std_logic;
	signal w_LOAD : std_logic;
	
begin


	UTT : master 
	port map(
	i_CLK => w_CLK,
	i_CLK_100_TEST => w_CLK_100,
	i_RST  => w_RST,
	en_SCL  => w_en_SCL,
	en_SDA  => w_en_SDA,
	i_EDGE  => w_EDGE,
	o_LOAD  => w_LOAD,
	i_STARTBUTTON  => w_STARTBUTTON,
	i_RESULT  => w_RESULT
	);
	
	process 
	begin
	w_CLK_100 <= '1';
	wait for 5000 ns;
	w_CLK_100 <= '0';
	wait for 5000 ns;
	end process;
	
	process
	begin
	w_CLK <= '1';
	wait for 10 ns;
	w_CLK <= '0';
	wait for 10 ns;
	end process;
	
	process
	begin
	w_RST <= '1';
	wait for 10 ns;
	w_RST <= '0';
	wait;
	end process;
	
	
	process
	begin
	w_STARTBUTTON <= '0';
	w_RESULT <= '0';
	w_EDGE <= '1';
	wait for 20 ns;
	--esperando o clock baixar e uma borda de subida
	w_STARTBUTTON <= '1';
	wait for 10 ns;
	w_STARTBUTTON <= '0';
	wait;
	end process;
	
	
end behavioral;
	
