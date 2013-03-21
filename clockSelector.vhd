library ieee;
use ieee.std_logic_1164.all;

entity clockSelector is
port(
				clock50 : in std_logic;
				handClock : in std_logic;
				selectHand : in std_logic;
				clockOut : out std_logic);
end clockSelector;

architecture a of clockSelector is
signal clock5 : std_logic;
signal tempClock : std_logic;
begin
	process(clock50)
	variable  count : integer range 0 to 10:=0;
	begin
		if(clock50'event and clock50='1') then
			count:=count+1;
			if(count=10) then
				count:=0;
				clock5<=not clock5;
			end if;
		end if;
	end process;
	
	process(selectHand,clock5,handClock)
	begin
		case selectHand is
			when '1'=>tempClock<=handClock;
			when '0' =>tempClock<=clock5;
		end case;
	end process;
	
	clockOut<= not tempClock;
	--invert because of the push buttons
end a;
				
			
				