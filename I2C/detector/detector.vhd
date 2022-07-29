--*************************************************************************************
--
-- Module   :  SINC_UART
-- Inputs   :
--			      i_CLK			--> Global system clock.
--			      i_RST 		--> Assynchronous reset for the FPGA.
--			      i_CLK_UART 	--> Reference signal for the UART. It comes from the PLL.
-- Outputs:
--         		o_EDGE_UP	--> Pulse informing the rising edge of the UART clock.
--		         o_EDGE_DOWN	--> Pulse informing the falling edge of the UART clock.
--
--
--	Timing diagram:
--
--				                  /---\		   /---\	      /---\		   /---\       
--			 i_CLK_UART	 <------/     \-----/     \-----/     \-----/     \-----
--
--                                |            |           |           | 
--        o_EDGE_DOWN <-----------|------------|-----------|-----------|-----
--
--                            |           |           |           |
--        O_EDGE_UP <---------|-----------|-----------|-----------|----------
--
--*************************************************************************************

--temos um problema, como o I2C fica com o SCL em alta impedancia (1 sem conexão)
--somamos até 9 para solucionar isso

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity DETECTOR is port
	(
		i_RST   			: in std_logic;
		i_CLK 			: in std_logic;
		--
		i_CLK_UART 		: in std_logic;
		o_EDGE_UP		: out std_logic;
		o_EDGE_DOWN		: out std_logic
	);
end DETECTOR;

architecture Behavioral of DETECTOR is
----------------------------------------------------------------------------------------------
-- Internal signals.
----------------------------------------------------------------------------------------------
	signal w_CLK_R, w_CLK_S, w_CLK_T : std_logic;
begin
----------------------------------------------------------------------------------------------
-- Edge detector
----------------------------------------------------------------------------------------------
	U1 : process(i_CLK, i_RST)														
 	begin																							
		if (i_RST = '1')  then																	
			w_CLK_R <= '0';																		
			w_CLK_S <= '0';																		
			w_CLK_T <= '0';																		
		elsif rising_edge (i_CLK) then												
			w_CLK_R <= i_CLK_UART;																			
			w_CLK_S <= w_CLK_R;																		
			w_CLK_T <= w_CLK_S;																		
		end if;																					
	end process U1;																

	-- Falling edge of the UART clock.
   o_EDGE_DOWN <= not(w_CLK_S) and w_CLK_T;		
	
   -- Rising edge of the UART clock.
   o_EDGE_UP <= w_CLK_S and not(w_CLK_T);													   


----------------------------------------------------------------------------------------------
end Behavioral;
