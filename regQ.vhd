--regQ shifter --
--reg is one of internal registers
--Q is a register

library ieee;
use ieee.std_logic_1164.all;

--sel bits
--Circular/Linear Double/Single shift Up/down
entity regQ is
	port(
		cyclicShift : in std_logic;
		sel : in std_logic_vector(2 downto 0);
		clk : in std_logic;
		Qout : out  std_logic_vector(7 downto 0);
		regOut : out std_logic_vector(7 downto 0);
	);
end regG;

architecture regQ of regQ is
	signal Q : std_logic_vector(7 downto 0);
	signal reg : std_logic_vector(7 downto 0);
	signal C : std_logic;
	signal microC : std_logic;
end regQ;