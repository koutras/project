library ieee;
use ieee.std_logic_1164.all;

--diaferei apo tin control unit
--tis endiamesis epeidi den perilamvanei
--tin mnimi sto swma tis

entity controlUnit is
	port
	(
		-- Input ports
		conditionBit : in std_logic; --used for conditional jumps
		firstMcmdAddr : in  std_logic_vector(7 downto 0);
		--first microCommand Address		
		--retrieved from mapper
		
		microQ : in std_logic_vector(39 downto 0);
		-- signals to the execution unit
		d : out std_logic_vector( 1 downto 0);
		clock : in std_logic;
		i : out std_logic_vector( 8 downto 0);
		a : out std_logic_vector( 3 downto 0);
		b : out std_logic_vector( 3 downto 0);
		sh : out std_logic;
		selB : out std_logic;
		switchesAlu : out std_logic;
		carryEnable : out std_logic; 
		mapperSeq : out std_logic;
		ddataAlu : out std_logic; --enable the two bit direct data
		aluMacro : out std_logic; -- write enable
		aluMar : out std_logic; --place output of alu to mar
		mdrAlu : out std_logic;
		updateFlags : out std_logic;
		con	: out std_logic_vector(2 downto 0);
		microAddress : out std_logic_vector(7 downto 0);--for display purposes
		microCmd : out std_logic_vector( 39 downto 0);
		externalReset : in std_logic
		);
end controlUnit;

architecture controlUnit of controlUnit is
	component mseq is
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
		externalReset : in std_logic;
		stackEnable : in std_logic;

		-- OUTPUT PORTS
		Y			: out std_logic_vector(7 downto 0));
	end component;
	
	component pipelineReg is
			port (
			-- 
			dataIn : in std_logic_vector(39 downto 0);
			clk : in std_logic;
			
			-- the 40 bits broken tou subgroups--
			bra : out std_logic_vector(4 downto 0);
			bin : out std_logic_vector(2 downto 0);
			con : out std_logic_vector(2 downto 0);
			
			i876 : out std_logic_vector(2 downto 0);
			i543 : out std_logic_vector(2 downto 0);
			i210 : out std_logic_vector(2 downto 0);
			a :out std_logic_vector(3 downto 0);
			b : out std_logic_vector(3 downto 0);
			d : out std_logic_vector(1 downto 0);
			sh : out std_logic;
			selB : out std_logic;
			mwe : out std_logic;
			aluMar : out std_logic;
			updateFlags : out std_logic;
			mapperSeq : out std_logic;
			switchesAlu : out std_logic;
			carryEnable : out std_logic;
			mdrAlu : out std_logic;
			ddataAlu : out std_logic
		
		);
end component;

component mscc is
port (
		bin : in std_logic_vector(2 downto 0);
		mapperSeq: in std_logic;--mapper seq
		cond	: in std_logic;  -- bit of selected condition
		
		-- output ports
		sel : out std_logic_vector(1 downto 0); --input of mux
			-- uPC:0, AR:1, F:2, D:3
		stackEnable : out std_logic;
		push : out std_logic;
		jumpToStart : out std_logic);
end component;
	
	component addressReg is
		 port (clk : in std_logic; 
		branch : in std_logic_vector(4 downto 0);
		mcmdAddr : in std_logic_vector(7 downto 0);
		newAddr : out std_logic_vector(7 downto 0));

	end component;

	
	
	
 
	component routineStack is
			
		generic (bits : integer:=8; -- # of bits per word
					words : integer := 4); --# of words in stack
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
	
		--microsequencer
	signal MSjumpToStart : std_logic;
	signal MSAddrReg : std_logic_vector( 7 downto 0);
	signal MSSelect : std_logic_vector( 1 downto 0);	
	signal MSpush : std_logic;
	signal MSStackEnable : std_logic;


	--mscc
	signal MSCCBin : std_logic_vector(2 downto 0);
	signal MSCCMapperSeq : std_logic;
	
	--addressReg
	signal ARBranch : std_logic_vector( 4 downto 0);
	signal mcmdAddr: std_logic_vector( 7 downto 0); 
	
	--microMemory also input of addressReg
	signal microAddr : std_logic_vector( 7 downto 0);
	
	--pipelineRegister
	signal pipelineDataIn : std_logic_vector(39 downto 0);
begin
	c1: mscc port map(sel=>MSSelect,
		stackEnable=>MSStackEnable, push=>MSPush, jumpToStart=> MSjumpToStart,
			bin=>MSCCBin, mapperSeq=>MSCCMapperSeq,
			 cond=>conditionBit);
			
	c2: mseq port map(D=> firstMcmdAddr, AR=> MSAddrReg,push=>MSpush,clock=>clock,
		 jumpToStart=>MSjumpToStart,selectMux=> MSSelect, stackEnable=>MSStackEnable, Y=> microAddr,
		 externalReset=>externalReset);

	c3 : pipelineReg port map(dataIn=> pipelineDataIn, clk=>clock, bra => ARBranch, bin=> MSCCBin, 
				con=>con,i876=>i(8 downto 6), i543=>i(5 downto 3), i210=> i(2 downto 0), a=>a, b=>b, d=>d,
				sh=>sh, selB=>selB, mwe=>aluMacro, aluMar=>aluMar,updateFlags=>updateFlags,
				mapperSeq=>MSCCmapperSeq,switchesAlu=>switchesAlu,
			   carryEnable=>carryEnable,mdrAlu=>mdrAlu, ddataAlu=>ddataAlu);
			   
	c4 : addressReg port map(clk => clock, branch =>ARBranch, mcmdAddr => microAddr, 
				newAddr =>MSAddrReg);


	microAddress<=microAddr;
	
	mapperSeq<=MSCCMapperSeq;
	microCmd<=pipelineDataIn;
	pipelineDataIn<=microQ;
	microCmd<=microQ;
end controlUnit;
	