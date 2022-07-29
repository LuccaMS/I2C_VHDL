library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity master is 
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
end master;


architecture behavioral of master is 
	
	type Estado is (idle,enviando);
		attribute syn_encoding : string;
		attribute syn_encoding of Estado : type is "safe";
	
	signal w_state : Estado := idle;
	
	begin
	
PROCESS (i_CLK,i_RST) --nosso processo central do master
	begin
	if(i_RST = '1') then
		o_LOAD <= '0';
		en_SCL <= '0';
		en_SDA <= '0';
		w_state <= idle;
	elsif rising_edge(i_CLK) then
		case w_state is
			when idle =>
				if(i_STARTBUTTON = '1') then
					o_LOAD <= '1';
					w_state <= enviando;
				else
					w_state <= idle;
				end if;
			when enviando =>
				o_LOAD <= '0'; 
				if(i_RESULT = '1') then --isso nos indica que já enviamos 8 bordas de clock no SCL
					en_SCL <= '0';
					en_SDA <= '0';
					w_state <= idle; 
				else
					if(i_EDGE = '1') then 
						en_SDA <= '1';
						en_SCL <= '1';
					else
						en_SCL <= '1'; 
						w_state <= enviando;
						end if;
				end if;
			when others =>
				null;
			end case;
	end if;
			
	end PROCESS;
end behavioral;