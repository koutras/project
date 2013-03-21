library ieee;
use ieee.std_logic_1164.all;
entity mseq is
	port
	(
		-- INPUT PORTS 
		clock			: in	std_logic;
		--Inputs for MULTIPLEXER
		D			: in std_logic_vector(7 downto 0); --direct input
		AR			: in std_logic_vector(7 downto 0); --address register
		-- signals driven by mscc
		selectMux			: in std_logic_vector(1 downto 0); -- select inputs
		push 		: in std_logic;
		jumpToStart		: in std_logic;
		stackEnable : in std_logic;
		externalReset : in std_logic;
		-- OUTPUT PORTS
		Y			: out  std_logic_vector(7 downto 0));
end mseq;

---------------------------------------------------------------------

architecture mseq of mseq is
	component routineStack is -- the stack for routines
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
	end component;

	component incReg is
		port(
	   	inAddress : in std_logic_vector(7 downto 0);
	   	externalReset : in std_logic;
			outAddress : out std_logic_vector(7 downto 0);
			clk : in std_logic);
	end component;
	
	component mMux is
		port(
			ar, d, f, upc : in std_logic_vector(7 downto 0);
			sel			:	in std_logic_vector(1 downto 0);
			y: out std_logic_vector(7 downto 0)
			);
	end component;

	signal X : std_logic_vector(7 downto 0); -- muxOutput;
	signal F : std_logic_vector(7 downto 0); --file/stack
	signal uPC :std_logic_vector(7 downto 0); --microProgramCounter
	
	
begin
	c1: routineStack port map(stackEnable=>stackEnable,outAddr=>F,
			push=>push,inAddr=>uPC,clk=>clock);

	c2: incReg port map(inAddress=>X, outAddress=>uPC,
				clk=>clock,externalReset=>externalReset);

	c3: mMux port map (ar=>AR,y=>X, upc=>uPC,
			d=> D, f=>F, sel =>selectMux);
 
 process(X,jumpToStart,externalReset)
begin
		if(jumpToStart='1' or externalReset='1') then
			Y<=(others=>'0');
		else
			Y<=X;
		end if;
end process;
end mseq;