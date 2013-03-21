--q reg

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity qReg is
	port (
		inData : in std_logic_vector(7 downto 0);
		writeEnable : in std_logic;
		clk : in std_logic;
		outData : out std_logic_vector(7 downto 0)

	);
end qReg;

architecture qReg of qReg is

signal  storedData : std_logic_vector(7 downto 0);
begin
	process(clk)
	begin
		if(clk'event and clk='1') then
			if(writeEnable='1') then
				storedData<=inData;
			end if;
		end if;
	end process;
outData<=storedData;
end qReg;