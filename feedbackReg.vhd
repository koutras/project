-- feedbackReg--
library ieee;
use ieee.std_logic_1164.all;

entity feedbackReg is
	port ( dataIn : in std_logic_vector(3 downto 0);
			   B : in std_logic_vector(3 downto 0);
				selB : in std_logic;
				clk : in std_logic;
				-- out 
				dataOut : out std_logic_vector(3 downto 0)
			);
end feedbackReg;

architecture feedbackReg of feedbackReg is
signal stored : std_logic_vector(3 downto 0);
begin			
	process(clk,selB,B,dataIn,stored)
	begin
	
		if(selB='0') then
				dataOut<=B;
		else dataOut<=stored;
		end if;
		
	
		if(clk'event and clk='0') then
			if(selB='0') then
				stored<=dataIn;
			end if;
		end if;
		
	end process;
		
	

end feedbackReg;