library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_i2c is
end tb_i2c;

architecture behavioral of tb_i2c is

--component central is 
--PORT(
--	i_RST : in std_logic; --setar qual o botão é o de reset
--	i_CLK : in std_logic; --esse será o clock do FPGA antes do PLL
--	i_START : in std_logic := '0' --botão de start global do FPGA
--);
--end component;

component central is 
PORT(
	i_RST : in std_logic;
	i_CLK_50 : in std_logic;
	i_CLK_100 : in std_logic;
	i_START : in std_logic
);
end component;

	signal w_RST : std_logic;
	signal w_CLK_50 : std_logic;
	signal w_START : std_logic;
	signal w_CLK_100 : std_logic;
	
	begin
	
	TESTE_I2C : central
	PORT MAP (
		i_RST => w_RST,
		i_CLK_50 => w_CLK_50,
		i_CLK_100 => w_CLK_100,
		i_START => w_START
	);
	
	process 
	begin
		w_RST <= '1';
		wait for 10 ns;
		w_RST <= '0';
		wait;
	end process;
	
	--visto que nosso clock vai ser de 50mhz, o ciclo completo é de 20 ns, subida dura 10ns e descida 10ns
	
	process
	begin
		w_CLK_50 <= '1';
		wait for 10 ns; 
		w_CLK_50 <= '0';
		wait for 10 ns;
	end process;
	--da maneira acima pode-se emular um clock de 50 mhz
	
	--o ciclo completo com 100kbps será de 10 ms, 5 ms para subida e 5 para descida, ou seja, 5k ns para cada
	process
	begin
	w_CLK_100 <= '1';
	wait for 5000 ns; 
	w_CLK_100 <= '0';
	wait for 5000 ns;
	end process;
		
	process
	begin
	wait for 30 ns;
	w_start <= '0';
	wait for 10 ns;
	w_START <= '1';
	wait for 20 ns;
	w_START <= '0';
	wait;
	end process;
	end behavioral;
