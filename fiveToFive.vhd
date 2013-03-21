library ieee;
use ieee.std_logic_1164.all;

entity fiveToFive is
port ( input  :  in std_logic_vector(4 downto 0);
				out4,out3,out2,out1,out0 : out std_logic);
end fiveTofive;

architecture a of fiveToFive is
begin
out4<=input(4);
out3<=input(3);
out2<=input(2);
out1<=input(1);
out0<=input(0);
end  a;