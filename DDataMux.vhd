--DDataMux
library ieee;
use ieee.std_logic_1164.all;

entity DDataMux is
	port(
		MDR : in std_logic_vector(7 downto 0);
		switchData : in std_logic_vector( 7 downto 0);
		microData : in std_logic_vector( 1 downto 0);

		memE : in std_logic;
		swiE : in std_logic;
		micE : in std_logic;

		dataOut : out std_logic_vector(7 downto 0)
	);

end DDataMux;

architecture DDataMux of DDataMux is
	begin
		process(memE,swiE,micE,microData,MDR,switchData)
		begin
			if(memE='1') then
				dataOut<=MDR;
			elsif(swiE='1') then
				dataOut<=switchData;
			elsif(micE='1') then
				dataOut<="000000"&microData;
			else
				dataout<="00000000";
			end if;
		end process;
end DDataMux;