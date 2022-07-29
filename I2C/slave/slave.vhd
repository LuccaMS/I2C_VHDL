library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity slave is 
PORT
(
	i_CLK : in std_logic; --clock global de 50 mhz
	i_SCL : in std_logic; --"clock" de dados de 100 kbps
	i_SDA : in std_logic; --dado vindo do master
	i_RST : in std_logic; --reset global assincrono que irá ver do bloco central
	i_COUNT : in std_logic; --dado que irá vir lá do counter, quando acabar o SCL, indica que tivemos 8 bordas
	i_EDGE : in std_logic --sinal se tem borda de subida do SCL, usado para pegar o dado do SDA no right time
	--o_DISPLAY : out std_logic_vector(6 downto 0) --pinos do 7 segment
);
end entity;

architecture behavioral of slave is 
	type Estado is  (idle,lendo,escrevendo);
		attribute syn_encoding	: string;
		attribute syn_encoding of Estado : type is "safe";
	--tres estados, idle, lendo os dados que estão sendo recebidos pelo barramento SDA e escrevendo no 7 segment
	--após a conversão de serial para paralelo
	
		signal w_state : Estado := idle;

	component SER2PAR 
	PORT
	(
		i_RST 	  	: in std_logic;
		i_CLK 		: in std_logic;
		--
		i_ND  	 	: in std_logic;
		o_DATA		: out std_logic_vector(7 downto 0);
		i_RX    		: in std_logic
	);
	end component;
	
--	component SETE_SEGMENTOS 
--	 Port ( 
--				i_RST			: in STD_LOGIC;
--				i_NUMERO		: in STD_LOGIC_VECTOR(3 DOWNTO 0);
--				o_DISPLAY	: out STD_LOGIC_VECTOR(6 DOWNTO 0)
--	 );
--	end component; 
	
	signal w_ND : std_logic;
	signal w_RX : std_logic; --nosso SDA no tempo correto
	signal w_CONVERTIDO : std_logic_vector(7 downto 0);
	signal w_SDA_PAST : std_logic; --estado do SDA na última borda de clock
	signal w_number_to_display : std_logic_vector(3 downto 0) := "0000";
	
	begin
	
	S2P : SER2PAR
	PORT MAP 
	(
		i_RST 	  	=> i_RST,
		i_CLK 		=> i_CLK,
		i_ND  	 	=> w_ND,
		o_DATA		=> w_CONVERTIDO,
		i_RX    		=> w_RX
	);
	
--	DISPLAY : SETE_SEGMENTOS 
--	 Port Map 
--	 ( 
--				i_RST			=> i_RST,
--				i_NUMERO		=> w_number_to_display,
--				o_DISPLAY	=> o_DISPLAY
--	 );
	
	PROCESS(i_CLK,i_RST)
	begin
		if(i_RST = '1') then
			w_ND <= '0';
			w_RX <= '0';
			w_number_to_display <= "0000";
		elsif rising_edge(i_CLK) then
			case w_state is 
				when idle =>
					if(i_SCL = '0' and w_SDA_PAST = '0') then
							w_state <= lendo;
					else
						w_SDA_PAST <= i_SDA;
					end if;
				when lendo =>
					if(i_COUNT = '1') then
						w_ND <= '0';
						w_state <= escrevendo;
					elsif(i_EDGE = '1') then
						w_ND <= '1';
						w_RX <= i_SDA;
					else
						w_ND <= '0';
					end if;
				when escrevendo =>
					w_number_to_display <= w_CONVERTIDO(3) & w_CONVERTIDO(2) & w_CONVERTIDO(1) & w_CONVERTIDO(0);
					--está funcionando, teoricamente é só mandar pro 7 segment.
					w_state <= idle;
				when others => null;
				end case;
				
		end if;
	end process;
end behavioral;
	
	