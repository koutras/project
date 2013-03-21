library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity addressReg is
	port (
			clk : in std_logic; 
			branch : in std_logic_vector(4 downto 0);
			mcmdAddr : in std_logic_vector(7 downto 0);
			newAddr : out std_logic_vector(7 downto 0));
end addressReg;

architecture addressReg of addressReg is
begin
	process(clk)
	begin
		if(clk'event and clk='1') then
			newAddr<= mcmdAddr + ("000" & branch);
		end if;
	end process;
end addressReg;