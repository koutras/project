--source selector --
library ieee;
use ieee.std_logic_1164.all;

entity sourceSelector is
	port (
				 -- out 
				R : out std_logic_vector(7 downto 0);
				S : out std_logic_vector(7 downto 0);
				 -- in
				sel : in std_logic_vector(2 downto 0);
				A : in std_logic_vector(7 downto 0);
				B : in std_logic_vector(7 downto 0);
				D : in std_logic_vector(7 downto 0);
				Q : in std_logic_vector(7 downto 0)
				
	);
	
end sourceSelector;

architecture  sourceSelector of sourceSelector is
signal storeA,storeB,storeQ : std_logic_vector(7 downto 0);
begin
	process(sel,storeA,storeB,D,storeQ)
	begin
			case sel is
		 
			 when "000"=>	R <= storeA;S<=storeQ;
			when "001"=>R<=storeA;S<=storeB;
			when"010"=>R<="00000000";S<=storeQ;
			when"011"=>R<="00000000";S<=storeB;
			
			when"100"=>R<="00000000";S<=storeA;
			when "101"=>	R<=D ;S<=storeA;
			 when "110"=>R<=D;S<=storeQ;
			when "111"=>R<=D ;S<="00000000";
			end case;
	end process;
	
	process(A,B,Q)
	begin
		storeA<=A;
		storeQ<=Q;
		storeB<=B;
	end process;
end sourceSelector;