library ieee;
use ieee.std_logic_1164.all;
	
entity statusRegister is
	port
	(	con : in std_logic_vector(2 downto 0); -- condition
		updateFlags : in std_logic:='0'; --refresh data
		y : out std_logic; -- output condition bit
		carry : in std_logic;
		sign : in std_logic;
		overflow : in std_logic;
		zero : in  std_logic;
		clk : in std_logic;
		macroCarryOut : out std_logic;
		macroSignOut : out std_logic;
		macroOverflowOut : out std_logic;
		macroZeroOut : out std_logic;
		microCarryOut : out std_logic;
		microSignOut : out std_logic;
		microOverflowOut : out std_logic;
		microZeroOut : out std_logic
		
	);
end statusRegister;

architecture statusRegister of statusRegister is
	signal microCarry : std_logic;
	signal macroCarry : std_logic;
	signal microSign : std_logic;
	signal macroSign : std_logic;
	signal microOverflow : std_logic;
	signal macroOverflow : std_logic;
	signal microZero : std_logic;
	signal macroZero : std_logic;
begin

	
	--process(clk)
	--begin
		process(carry,sign,zero,overflow,clk)
		begin
	
			if(clk'event and clk='0') then
				microCarry <= carry;
				microSign <= sign;
				microOverflow <= overflow;
				microZero <= zero;
		
				if(updateFlags = '1') then
					macroCarry <= carry;
					macroSign <= sign;
					macroOverflow <= overflow;
					macroZero <= zero;
				end if;
		end if;
	end process;
	
	with con select
	y <= macroCarry when "000",
			macroOverflow when "001",
			macroSign when "010",
			macroZero when "011",
			microCarry when "100",
			microOverflow when "101",
			microSign when "110",
			microZero when "111";
			

macroCarryOut<=macroCarry; --needed for rotate
--for display purposes
microCarryOut<=microCarry;
macroSignOut<=macroSign;
microSignOut<=microSign;
macroOverflowOut <=macroOverflow;
microOverflowOut<=microOverflow;
microCarryOut<= microCarry;
macroZeroOut<= macroZero;
microZeroOut<= microZero;

end statusRegister;