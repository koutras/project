library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity alu is
	port(
			 carryEnable : in std_logic;
			 cin : in std_logic;
			 R : in  std_logic_vector(7 downto 0);
			 S : in	std_logic_vector(7 downto 0);
			 sel : in std_logic_vector(2 downto 0);
			 dataOut : out std_logic_vector(7 downto 0);
			 clk : in std_logic;
			 carry : out std_logic;
			 sign : out std_logic;
			 overflow : out std_logic;
			 zero : out std_logic
			 
	);
	
end alu;

architecture alu of alu is
	
signal result : std_logic_vector(8 downto 0);
signal c: std_logic;
	
	
begin
process(sel,R,S,c)
--process(clk,R,S)
	variable Rint : integer range -128 to 127;
	variable Sint : integer range -128 to 127;
	variable cInt : integer range 0 to 1;
	variable tempOverflow : std_logic;
	begin
			Rint:=conv_integer(R);
			Sint:=conv_integer(S);
			cInt:=conv_integer(c);
			tempOverflow:='0';
		--	if(clk'event and clk='1') then
				case sel is
						when "000"=>	result <= '0'&(R + S +c);
											if((Rint>0 and Sint>127-(Rint+cInt)) or (Rint<0 and Sint<-128-(Rint+cInt)))then
												tempOverflow:='1';
											end if;
											
						when"001"=>result<='0'&(S-(R+c)) ;
										if((-Rint>0 and Sint>127+(Rint+cInt)) or (-Rint<0 and Sint<-128+(Rint+cInt)))then
												tempOverflow:='1';
											end if;
						when "010"=>result<='0'&(R-(S+c)) ;
											if((Rint>0 and -Sint>127-(Rint+cInt)) or (Rint<0 and -Sint<-128-(Rint+cInt)))then
												tempOverflow:='1';
											end if;
						when "011"=>result<='0'&(R or S);
						when "100"=>result<='0'&(R and S);
						when "101"=>result<='0'&((not R) and S) ;
						 when "110"=>result<='0'&(R xor S);
						 when "111"=>result<=	'0'&(not(R xor S)) ;	
				end case;
			overflow<=tempOverflow;
			--	end if;

	end process;
					
process(carryEnable,cin)
begin
	if(carryEnable='1') then
		c<=cin;
	else
		c<='0';
	end if;
	
end process;

process(result)
begin
	if (result="000000000") then
		zero<='1';
	else
		zero<='0';
	end if;
dataOut<=result(7 downto 0);
carry<=result(8);
sign<=result(7); 
end process;

end alu;