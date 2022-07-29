
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pa2Se is
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
end Pa2Se;

architecture behavioral of Pa2Se is

	signal w_DATA : std_logic_vector(7 downto 0);
	signal w_ND	: std_logic;
	
	
	signal data_fpga : std_logic_vector(7 downto 0) := "11111000"; --valor padrão
	
begin

		U1 : process(i_CLK,i_RST)
	
		begin
			if(i_RST = '1') then
				w_ND <= '0';
				o_TX <= '1';  
			elsif falling_edge(i_CLK) then
				if(i_LOAD = '1') then
					o_TX <= '0'; --indica o inicio da conexão
				elsif(i_ND = '1') then
					o_TX <= w_DATA(7);
					w_ND <= '1';
				else
					w_ND <= '0';
					o_TX <= '1'; --alta impedancia ao fim da conexão quando i_ND for 0
					
				end if;
				
			end if;
			
		end process U1;
	
	U2	: process(i_CLK,i_RST) 
			begin
				if(i_RST = '1') THEN
					w_DATA <= (others => '0');
				elsif rising_edge(i_CLK) then
					if(i_LOAD = '1') then
						data_fpga <= "1111" & i_BIT0 & i_BIT1 & i_BIT2 & i_BIT3; --quando for no FPGA
						w_DATA <= data_fpga;
					elsif(i_ND = '1') then
						if(i_EDGE = '1') then

							w_DATA <= w_DATA(6 downto 0) & '0';
						end if;
					end if;
				end if;
			end process u2;
end behavioral;
									