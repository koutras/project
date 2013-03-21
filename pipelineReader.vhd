library ieee;
use ieee.std_logic_1164.all;

entity pipelineReader is
	port (
				clk : in std_logic;
				rst : in std_logic;
				input : std_logic_vector(4 downto 0);
				isReady : out std_logic;
				enable : in std_logic;
				output :  out std_logic_vector( 39 downto 0);
				fiveLeds : out std_logic_vector(4 downto 0);
				left7	: out std_logic_vector(6 downto 0);
				middle7 : out std_logic_vector(6 downto 0);
				right7 : out std_logic_vector(6 downto 0)
	);
end pipelineReader;

architecture a of pipelineReader is
	type state is(zero,one,two,three,four,five,six,seven,eight,nine,ten,final);
	signal prState,nxState : state;
	
	signal l7,m7,r7 : std_logic_vector(6 downto 0);
	--																													 abcdefg
	constant a7 : 		std_logic_vector(6 downto 0):= "1110111";
	constant b7 : 		std_logic_vector(6 downto 0):= "0011111";
	constant c7 : 		std_logic_vector(6 downto 0):= "1001110";
	constant d7 : 		std_logic_vector(6 downto 0):= "0111101";
	constant e7 : 		std_logic_vector(6 downto 0):= "1001111";
	constant  i7 : 		std_logic_vector(6 downto 0):= "0110000";
	constant n7 : 		std_logic_vector(6 downto 0):= "0010101";
	constant o7 :			std_logic_vector(6 downto 0):= "0011101";
	constant  ar7 :			std_logic_vector(6 downto 0):= "0000111";
	constant zero7:	std_logic_vector(6 downto 0):= "1111110";
	constant two7:		std_logic_vector(6 downto 0):= "1101101";
	constant three7: std_logic_vector(6 downto 0):= "1111001";
	constant four7  : std_logic_vector(6 downto 0):= "0110011";
	constant five7: 	std_logic_vector(6 downto 0):= "1011011";
	constant six7:		std_logic_vector(6 downto 0):= "1011111";
	constant eight7: std_logic_vector(6 downto 0):= "1111111";
	constant nine7 : std_logic_vector(6 downto 0):="1111011";
	constant nil :			std_logic_vector(6 downto 0):= "0000000";
	
	shared variable tempInput : std_logic_vector(39 downto 0);
	begin
		process(prState,input)
		begin
			case prState is
				when zero=>tempInput(39 downto 35):=input;	nxState<=one;isReady<='0';fiveLeds<="11111";l7<=b7;m7<=ar7;r7<=a7;--bra read
				when one=>tempInput(34 downto 32):=input(2 downto 0);nxState<=two;isReady<='0'; fiveLeds<="00111";l7<=b7;m7<=i7;r7<=n7;--bin read
				when two=>tempInput(31 downto 29):=input(2 downto 0);nxState<=three;isReady<='0'; fiveLeds<="00111";l7<=c7;m7<=o7;r7<=n7;--con read
				when three=>tempInput(28 downto 26):=input(2 downto 0);nxState<=four;isReady<='0';fiveLeds<="00111"; l7<=i7;m7<=two7;r7<=zero7;--i210 read
				when four=>tempInput(25 downto 23):=input(2 downto 0);nxState<=five;isReady<='0'; fiveLeds<="00111";l7<=i7;m7<=five7;r7<=three7;--i543 read;
				when five=>tempInput(22 downto 20):=input(2 downto 0);nxState<=six;isReady<='0'; fiveLeds<="00111";l7<=i7;m7<=eight7;r7<=six7;--i876 read;
				when six=>tempInput(19 downto 16):=input(3 downto 0); nxState<=seven;isReady<='0';fiveLeds<="01111" ;l7<=a7;m7<=nil;r7<=nil;--A read;
				when seven=>tempInput(15 downto 12):=input(3 downto 0); nxState<=eight;isReady<='0';fiveLeds<="01111"; l7<=b7;m7<=nil;r7<=nil;--Bread;
				when eight=>tempInput(11 downto 10):=input(1 downto 0); nxState<=nine;isReady<='0';fiveLeds<="00011"; l7<=d7;m7<=nil;r7<=nil;--Dread
				when nine=>tempInput(9 downto 5):=input;nxState<=ten;isReady<='0';fiveLeds<="11111"; l7<=c7;m7<=nine7;r7<=five7;-- 5 bits of control read
				when ten=>tempInput(4 downto 0):=input;nxState<=final;isReady<='0';fiveLeds<="11111"; l7<=c7;m7<=four7;r7<=zero7;-- next five bits read
				when final=>nxState<=zero;isReady<='1';fiveLeds<="00000";l7<=e7;m7<=n7;r7<=d7; 
			end case;
		end process;
		
		left7 <=not l7;
		right7 <= not  r7;
		middle7 <= not m7;
		
		process(clk,rst,enable)
		begin	
			if(rst='1' or enable='0') then
				prState<=zero;	
			elsif (clk'event and clk='1') then
				prState<=nxState;
			end if;		
		end process;
		output<=tempInput;
end a;