--filename file.vhd
--entity that contains
--a 4x8 file as well as
--a stack pointer register that
--enables push and pop into and from
-- the stack respectively
library ieee;
use ieee.std_logic_1164.all;

entity routineStack is
		
		generic (bits : integer:=8; -- # of bits per word
					words : integer := 50); --# of words in stack
	port(
			--input ports
		clk : in std_logic;	
		stackEnable :in std_logic; -- file enable
		push :in std_logic;-- push with one
		inAddr :in std_logic_vector(7 downto 0);--microcommand
			--right through microprogram counter register
			
			--output ports
		outAddr :out std_logic_vector(7 downto 0)-- top of the stack   
		 
	);
end routineStack;

architecture routineStack of routineStack is
	type vector_array is array(0 to words - 1) of
		std_logic_vector(bits-1 downto 0);
		signal stack: vector_array;
		shared variable  top : natural range 0 to 50 :=0;
	begin
		process(clk)
		--0 is considered the bottom of the stack
		begin
		if(clk'event and clk='0') then
			if(stackEnable='1') then
					if(push = '1') then
						top:=top+1;
						stack(top) <= inAddr;
					else
						top:=top-1;
					end if;
			end if;
	   end if;
		end process;
		outAddr <= stack(top);
end routineStack;