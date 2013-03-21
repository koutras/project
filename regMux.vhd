library ieee;
use ieee.std_logic_1164.all;
use work.my_package.all; --inputs declaration
					
					
entity regMux is
	port(
					inputs : in regArray;
					sel 	: in std_logic_vector(3 downto 0);
					output : out std_logic_vector(7 downto 0));
end regMux;

architecture regMux of regMux is
begin
	process(sel,inputs)
	variable storedInput : std_logic_vector(7 downto 0);
	begin
		storedInput:=(others=>'0');
		case sel is
				when "0000" =>storedInput:=inputs(0);
				when "0001"=>storedInput:=inputs(1);
				when "0010"=>storedInput:=inputs(2);
				when "0011"=>storedInput:=inputs(3);
				when "0100"=>storedInput:=inputs(4);
				when "0101"=>storedInput:=inputs(5);
				when "0110"=>storedInput:=inputs(6);
				when "0111"=>storedInput:=inputs(7);
				when "1000"=>storedInput:=inputs(8);
				when "1001"=>storedInput:=inputs(9);
				when "1010"=>storedInput:=inputs(10);
				when "1011"=>storedInput:=inputs(11);
				when "1100"=>storedInput:=inputs(12);
				when "1101"=>storedInput:=inputs(13);
				when "1110"=>storedInput:=inputs(14);
				when "1111"=>storedInput:=inputs(15);
		end case;
		output<=storedInput;
	end process;
	end regMux;