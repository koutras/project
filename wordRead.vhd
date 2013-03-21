library ieee;
use  ieee.std_logic_1164.all;
entity wordRead is
port (			
				clk : in std_logic;
				rst : in std_logic;
				input : std_logic_vector(3 downto 0);
				isReady : out std_logic;
				enable : in std_logic;
				output :  out std_logic_vector( 7 downto 0)
	);
end wordRead;
	
architecture a of wordRead is

		type state is(zero,one,final);
	signal prState,nxState : state;
	
	shared variable tempInput : std_logic_vector(7 downto 0);
	begin
		process(prState,input)
		begin
			case prState is
				when zero=>tempInput(7 downto 4):=input;	nxState<=one;isReady<='0'; --first half (high part)
				when one=>tempInput(3 downto  0):=input;nxState<=final;isReady<='0'; --second half
				when final=>nxState<=zero;isReady<='1'; 
			end case;
		end process;
		
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