--*************************************************************************************
--
-- Module   :  COUNTER
-- Inputs   :
--			      i_CLK			--> Global system clock.
--			      i_RST 		--> Assynchronous reset for the FPGA.
--					i_NEW_EDGE	--> Pulse to inform a new edge in the uart clock.
-- Outputs:
--         		o_ND     	--> Pulse informing that the counter achieved eight edges.
--
--*************************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity COUNTER is Port 
( 
		i_RST 		: in std_logic;
		i_CLK   		: in std_logic;
  	 	i_NEW_EDGE  : in std_logic;
      o_ND	 		: out std_logic
);
end COUNTER;

architecture Behavioral of COUNTER is
----------------------------------------------------------------------------------------------
-- Internal signals.
----------------------------------------------------------------------------------------------
    signal w_CLR 	: std_logic;
    signal w_CONT : std_logic_vector(3 downto 0);

----------------------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------------------
-- 8 bits reached.
----------------------------------------------------------------------------------------------
	U1 : process (i_CLK, i_RST)		   								
	begin													            		
      if(i_RST = '1') then 										    
		   w_CLR <= '0';				         						
	   
		elsif falling_edge(i_CLK) then	   						
			if(w_CONT = x"8") then						         			
				w_CLR <= '1';										         
			else	            												
				w_CLR <= '0';	         									
			end if;							         						
		end if;											         			
	end process U1;										      	

	o_ND <= w_CLR;				         								

----------------------------------------------------------------------------------------------
-- Counter - 8 bits word.
----------------------------------------------------------------------------------------------
	U2 : process (i_CLK, i_RST)		     									   
	begin											                    			
      if(i_RST = '1') then 							   	      	
         w_CONT <= (others => '0');						   		      
			
	   elsif rising_edge(i_CLK) then						        		
   	   if((i_NEW_EDGE = '1')or(w_CLR = '1')) then	
      	   if (w_CLR = '1') then				   	   
         	   w_CONT <= (others => '0');       									   
	         else 								               				
   	         w_CONT <= w_CONT + 1;						      		      
         	end if;		         										   
	      end if;							            						
   	end if;												            		
	end process U2;	            											--

----------------------------------------------------------------------------------------------
end Behavioral;

