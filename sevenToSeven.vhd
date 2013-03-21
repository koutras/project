library ieee;
use ieee.std_logic_1164.all;

entity sevenToSeven is
port ( input  :  in std_logic_vector(6 downto 0);
				a,b,c,d,e,f,g : out std_logic);
end sevenToSeven;

architecture a of sevenToSeven is
begin
a<=input(6);
b<=input(5);
c<=input(4);
d<=input(3);
e<=input(2);
f<=input(1);
g<=input(0);
end  a;