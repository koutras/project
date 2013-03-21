library ieee;
use ieee.std_logic_1164.all;

entity mMux is
	port(
			ar, d, f, upc : in std_logic_vector(7 downto 0);
			sel			:	in std_logic_vector(1 downto 0);
			y: out std_logic_vector(7 downto 0));
end mMux;

architecture  mux1 of mMux is
begin
process(d,upc,ar,f,sel)
begin
	case sel is
					when "00"=>y<=upc; 
					  when"01"=>y<=ar;
						when "10"=>y<=f;
						when "11"=>y<=d;
		
	end case;
end process;
end mux1;
		
