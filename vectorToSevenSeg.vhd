library ieee;
use ieee.std_logic_1164.all;
--takes 4 bits and drives a seven segment
--outputing 0 to F 
entity vectorToSevenSeg is
	port(
				input : in std_logic_vector(3 downto 0);
				ha : out std_logic;
				hb : out  std_logic;
				hc : out  std_logic;
				hd : out std_logic;
				he : out std_logic;
				hf	: out std_logic;
				hg : out std_logic);
end vectorToSevenSeg;

architecture a of vectorToSevenSeg is
signal a :std_logic;
signal b: std_logic;
signal c : std_logic;
signal d : std_logic;
signal e : std_logic;
signal f : std_logic;
signal g : std_logic;

begin
	process(input)
	begin
		case input is
			when "0000" => a<='1';b<='1';c<='1';d<='1';e<='1';f<='1';g<='0';
			when "0001"=> a<='0';b<='1';c<='1';d<='0';e<='0';f<='0';g<='0';
			when "0010"=> a<='1';b<='1';c<='0';d<='1';e<='1';f<='0';g<='1';
			when "0011"=> a<='1';b<='1';c<='1';d<='1';e<='0';f<='0';g<='1';
			when "0100"=> a<='0';b<='1';c<='1';d<='0';e<='0';f<='1';g<='1';
			when "0101"=> a<='1';b<='0';c<='1';d<='1';e<='0';f<='1';g<='1';
			when "0110"=> a<='1';b<='0';c<='1';d<='1';e<='1';f<='1';g<='1';
			when "0111"=> a<='1';b<='1';c<='1';d<='0';e<='0';f<='0';g<='0';
			when "1000"=>a<='1';b<='1';c<='1';d<='1';e<='1';f<='1';g<='1';
			when "1001"=>a<='1';b<='1';c<='1';d<='1';e<='0';f<='1';g<='1';
			when "1010"=>a<='1';b<='1';c<='1';d<='0';e<='1';f<='1';g<='1';
			when "1011"=>a<='0';b<='0';c<='1';d<='1';e<='1';f<='1';g<='1';
			when "1100"=>a<='1';b<='0';c<='0';d<='1';e<='1';f<='1';g<='0';
			when "1101"=>a<='0';b<='1';c<='1';d<='1';e<='1';f<='0';g<='1';
			when "1110"=>a<='1';b<='0';c<='0';d<='1';e<='1';f<='1';g<='1';
			when "1111"=>a<='1';b<='0';c<='0';d<='0';e<='1';f<='1';g<='1';
		end case;
	end process;
		ha<= not a;
		hb<= not b;
		hc<= not c;
		hd<= not d;
		he<= not e;
		hf<= not f;
		hg<= not g;
end a;
	