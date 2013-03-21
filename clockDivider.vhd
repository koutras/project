library ieee;
use ieee.std_logic_1164.all;

entity clockDivider is
port ( inClock : in std_logic;
				outClock : buffer std_logic);
end clockDivider;


architecture a of clockDivider is
begin
	process(inClock)
	begin
		if(inClock'event and inClock='1') then
			outClock<=not outClock;
		end if;
	end process;
end a;