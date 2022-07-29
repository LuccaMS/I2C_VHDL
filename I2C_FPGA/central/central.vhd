library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity central is 
PORT(
	i_RST : in std_logic; 
	i_CLK : in std_logic; 
	i_START : in std_logic := '1';
	i_BIT0 : in std_logic;
	i_BIT1 : in std_logic;
	i_BIT2 : in std_logic;
	i_BIT3 : in std_logic;
	o_DISPLAY : out std_logic_vector(6 downto 0) --configs serão no pin planner;
);
end entity;

architecture behavioral of central is
	
component PLL
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC 
	);
end component;

component slave 
PORT
(
	i_CLK : in std_logic; --clock global de 50 mhz
	i_SCL : in std_logic; --"clock" de dados de 100 kbps
	i_SDA : in std_logic; --dado vindo do master
	i_RST : in std_logic; --reset global assincrono que irá ver do bloco central
	i_COUNT : in std_logic; --dado que irá vir lá do counter, quando acabar o SCL, indica que tivemos 8 bordas
	i_EDGE : in std_logic; --sinal se tem borda de subida do SCL, usado para pegar o dado do SDA no right time
	o_DISPLAY : out std_logic_vector(6 downto 0) 
);
end component;


component DETECTOR 
port
	(
		i_RST   			: in std_logic;
		i_CLK 			: in std_logic;
		--
		i_CLK_UART 		: in std_logic;
		o_EDGE_UP		: out std_logic;
		o_EDGE_DOWN		: out std_logic
	);
end component;


component master
PORT(
	i_CLK : in std_logic;
	i_RST : in std_logic;
	en_SCL : out std_logic := '0'; --padrão para alta impedancia
	en_SDA : out std_logic := '0'; --padrão para alta impedancia
	i_EDGE : in std_logic; --borda vindo do detector
	o_LOAD : out std_logic := '0';
	i_STARTBUTTON : in std_logic; -- botao de inicio de tudo
	i_RESULT : in std_logic --conta as bordas do SCL, chegando em 8 bordas será 1
);	
end component;


component COUNTER
 Port 
( 
		i_RST 		: in std_logic;
		i_CLK   		: in std_logic;
  	 	i_NEW_EDGE  : in std_logic; --enviaremos as bordas detectadas do detector
      o_ND	 		: out std_logic
);
end component;

component Pa2Se
Port(
		i_RST 	  	: in std_logic;
		i_CLK 		: in std_logic;
  	 	i_LOAD    	: in std_logic;
		i_ND  	 	: in std_logic;
		i_EDGE 		: in std_logic;
		o_TX    	: out std_logic := '1';
		i_BIT0	:	in std_logic;
		i_BIT1	:	in std_logic;
		i_BIT2	:	in std_logic;
		i_BIT3	:	in std_logic
) ;
end component;

   signal w_CLK100KBPS : std_logic;
  	signal w_CLK50MHZ : std_logic; --clock geral do sistema
	signal w_SCL : std_logic; --SCL gerado pelo NAND do clock 100kbps e da saida do master
	signal w_enSCL : std_logic; --output do master que vai para o AND --padrão 0
	signal w_enSDA : std_logic; --output do master que indica enable SDA
	signal w_EDGE_UP : std_logic; --detecção da borda de subida do SCL através do detector de bordas
	signal w_EDGE_DOWN : std_logic;
	signal w_LOAD : std_logic;
	signal w_RESULT : std_logic; -- se chegamos a 8 bordas no SCL vai ser 1
	signal w_SDA : std_logic; --nosso sinal do SDA
	signal w_RST_NOT : std_logic;
	signal w_START : std_logic;
 
begin

	PLL_inst : PLL PORT MAP (
		areset	 => w_RST_NOT,
		inclk0	 => i_CLK,
		c0	 => w_CLK50MHZ,
		c1	 => w_CLK100KBPS
	);

	w_RST_NOT <= not i_RST;
	w_START <= not i_START;
	
	w_SCL <= not(w_CLK100KBPS and w_enSCL); 
	
	P2S : Pa2Se
	PORT MAP
	(
		i_RST 	  	=> w_RST_NOT,
		i_CLK 		=> w_CLK50MHZ,		
  	 	i_LOAD    	=> w_LOAD,
		i_ND  	 	=> w_enSDA,
		i_EDGE		=> w_EDGE_UP,
		o_TX    		=> w_SDA,
		i_BIT0		=> i_BIT0,
		i_BIT1		=> i_BIT1,
		i_BIT2		=> i_BIT2,
		i_BIT3		=> i_BIT3
	);
	
	COUNTERA : COUNTER
	PORT MAP
	(
		i_RST 		=> w_RST_NOT,
		i_CLK   		=> w_CLK50MHZ,
  	 	i_NEW_EDGE  => w_EDGE_UP, --recebendo os edge up do contador
      o_ND	 		=> w_RESULT
	);
	
	DETECT : DETECTOR
	PORT MAP
	(
		i_RST   		=> w_RST_NOT, --reset assincrono global
		i_CLK 		=> w_CLK50MHZ, --clock global de trabalho
		i_CLK_UART  => w_SCL, --clock para detectarmos as bordas ( SCL)
		o_EDGE_UP   => w_EDGE_UP,
		o_EDGE_DOWN => w_EDGE_DOWN
	);
	
	MASTERA : master 
	PORT MAP
	(
		i_CLK => w_CLK50MHZ,
		i_RST  => w_RST_NOT,
		en_SCL  => w_enSCL,
		en_SDA  => w_enSDA,
		i_EDGE  => w_EDGE_UP,
		o_LOAD  => w_LOAD,
		i_STARTBUTTON  => w_START,
		i_RESULT  => w_RESULT
	);
	
	slv : slave
	PORT MAP 
	(
		i_CLK => w_CLK50MHZ,
		i_SCL => w_SCL,
		i_SDA => w_SDA,
		i_RST => w_RST_NOT,
		i_COUNT => w_RESULT,
		i_EDGE => w_EDGE_UP,
		o_DISPLAY => o_DISPLAY
	);
	
end behavioral;