--system
library ieee;
use ieee.std_logic_1164.all;
 
entity project is
port(
	clock : in std_logic;
	switchesData : in std_logic_vector(7 downto 0);
	initBoardInput : in std_logic_vector(4 downto 0);
	initSel : in std_logic_vector(1 downto 0);
	initEnable : in std_logic;
	initRst : in std_logic;
	
	macroAddressOut : out std_logic_vector(7 downto 0);
	microAddressOut : out std_logic_vector(7 downto 0);
	
	execOut : out std_logic_vector(7 downto 0);
	
	cFirstMcmdAddrOut : out std_logic_vector(7 downto 0);
	regAddr_aOut : out std_logic_vector(3 downto 0);
	regAddr_bOut : out std_logic_vector(3 downto 0);
	q_aOut : out std_logic_vector(7 downto 0);
	q_bOut :  out std_logic_vector(7 downto 0);
		regData_bOut : out std_logic_vector(7 downto 0);
		regWe_bOut : out std_logic;
		microZOCS : out std_logic_vector(3 downto 0);
		macroZOCS: out std_logic_vector(3 downto 0);
		microCmd : out std_logic_vector(39 downto 0);
		aluOut : out std_logic_vector(7 downto 0);
		macroDataOut : out std_logic_vector(7 downto 0);
		
		externalReset : in std_logic;
		enableWriting : in std_logic;
		

		initMapperDataOut : out std_logic_vector(7 downto 0);
		mapperAddressOut : out std_logic_vector(7 downto 0);
		initMicroDataOut : out std_logic_vector(39 downto 0);
		fiveLeds : out std_logic_vector(4 downto 0);
		left7	: out std_logic_vector(6 downto 0);
		middle7 : out std_logic_vector(6 downto 0);
		right7 : out std_logic_vector(6 downto 0);
		reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,
		reg11,reg12,reg13,reg14,reg15 : out std_logic_vector(7 downto 0);
		MDRdisplay : out std_logic_vector(7 downto 0);
		QRegister : out std_logic_vector(7 downto 0)

	);
end project;


architecture project of project is
	
	component macro IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;



component mapperWritable IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;
 
	component microWritable IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (39 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (39 DOWNTO 0)
	);
END component;

	component controlUnit is
		port
	(
		conditionBit : in std_logic;
		firstMcmdAddr : in  std_logic_vector(7 downto 0);
		
		--first microCommand Address		
		--retrieved from mapper
		
		microQ : in std_logic_vector(39 downto 0);
		-- signal to dmux
		d : out std_logic_vector( 1 downto 0);
		
		clock : in std_logic;
		-- signals to the execution unit
		i : out std_logic_vector( 8 downto 0);
		a : out std_logic_vector( 3 downto 0);
		b : out std_logic_vector( 3 downto 0);
		sh : out std_logic;
		selB : out std_logic;
		carryEnable : out std_logic; --enable carry
		mapperSeq : out std_logic; 
		switchesAlu : out std_logic;
		mdrAlu : out std_logic; --enable mdr as direct data
		ddataAlu : out std_logic; --enable the two bit direct data
		externalReset : in std_logic;
		
		
		-- signals to main memory (macromemory)
		aluMacro : out std_logic; -- write enable
		aluMar : out std_logic; --place output of alu to mar
		
		-- signals to status register
		updateFlags : out std_logic;
		con	: out std_logic_vector(2 downto 0);
		microCmd : out std_logic_vector(39 downto 0);
		microAddress : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component executionUnit is
port(	
		clk : in std_logic;
		
		--signals to memory
			memAddr : out std_logic_vector(7 downto 0);
			memData : out std_logic_vector(7 downto 0);
			memWe : out std_logic;
			memQ : in std_logic_vector(7 downto 0);
		
		--signals from control Unit
		
		a : in std_logic_vector(3 downto 0);
		b : in std_logic_vector(3 downto 0);
		d : in std_logic_vector(1 downto 0);
		
		i : in std_logic_vector(8 downto 0);
		
		
		con : in std_logic_vector(2 downto 0);
		
		sh : in std_logic;
		selB : in std_logic;
		aluMacro : in std_logic;
		aluMar : in std_logic;
		updateFlags : in std_logic;
		--mapperSeq : in std_logic;
		switchesAlu : in std_logic;
		carryEnable : in std_logic;
		mdrAlu : in std_logic;
		ddataAlu : in std_logic;
		externalReset : in std_logic;
		
		--signals to control Unit
		cond : out std_logic;
		
		--signals to DDataMux
		switchesData : in std_logic_vector(7 downto 0);
				execOut : out std_logic_vector(7 downto 0);
				regAddr_aOut : out std_logic_vector(3 downto 0);
	regAddr_bOut : out std_logic_vector(3 downto 0);
		q_aOut : out std_logic_vector(7 downto 0);
		q_bOut : out std_logic_vector(7 downto 0);
			regData_bOut : out std_logic_vector(7 downto 0);
				regWe_bOut : out std_logic;
				macroCarryOut : out std_logic;
				macroSignOut : out std_logic;
				macroOverflowOut : out std_logic;
				macroZeroOut : out std_logic;
				microCarryOut : out std_logic;
				microSignOut : out std_logic;
				microOverflowOut : out std_logic;
				aluOut : out std_logic_vector(7 downto 0);
				microZeroOut : out std_logic;
				reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,
			reg11,reg12,reg13,reg14,reg15 : out std_logic_vector(7 downto 0);
				MDRdisplay : out std_logic_vector(7 downto 0);
				QRegister : out std_logic_vector(7 downto 0)
		
);
		--data directly from switches
	end component;
	
	
component systemInit is
port	(
				mapperAddress : in std_logic_vector(7 downto 0);
				macroAddress : in std_logic_vector(7 downto 0);
				macroData : in std_logic_vector(7 downto 0);
				macroWe : in std_logic;
				microAddress : in std_logic_vector(7 downto 0);
				clk : in std_logic;
				boardAddress : in std_logic_vector(7 downto 0);
				boardInput : in std_logic_vector(4 downto 0);
				sel : in std_logic_vector(1 downto 0);
				enable : in std_logic;
				rst : in std_logic;
				enableWriting : in std_logic;
				externalReset : in std_logic;
				fiveLeds : out std_logic_vector(4 downto 0);
				left7	: out std_logic_vector(6 downto 0);
				middle7 : out std_logic_vector(6 downto 0);
				right7 : out std_logic_vector(6 downto 0);
				----------------------------------------------------------------
				mapperData : out std_logic_vector(7 downto 0);
				mapperAddressOut : out std_logic_vector(7 downto 0);
				mapperWeOut : out std_logic;
				
				macroAddressOut : out std_logic_vector(7 downto 0);
				macroDataOut : out std_logic_vector(7 downto 0);
				macroWeOut : out std_logic;
				
				microAddressOut : out std_logic_vector(7 downto 0);
				microData : out std_logic_vector(39 downto 0);
				microWeOut : out std_logic
);
end component;





--main memory
signal macroAddress : std_logic_vector(7 downto 0);
signal macroData : std_logic_vector(7 downto 0);
signal macroWE : std_logic;
signal macroQ : std_logic_vector(7 downto 0);
--mapper--
signal mapperAddress : std_logic_vector(7 downto 0);

--controlUnit
signal cConditionBit :  std_logic;
signal cFirstMcmdAddr : std_logic_vector(7 downto 0); 
signal microQ : std_logic_vector(39 downto 0);
signal microAddress : std_logic_vector(7 downto 0);

--executionUnit
signal eA : std_logic_vector(3 downto 0);
signal eB : std_logic_vector(3 downto 0);
signal eD : std_logic_vector(1 downto 0);
signal eI : std_logic_vector(8 downto 0);
signal eCon : std_logic_vector( 2 downto 0);
signal eSh : std_logic;
signal eSelB : std_logic;
signal eAluMacro : std_logic;
signal eAluMar : std_logic;
signal eUpdateFlags : std_logic;
signal mapperSeq : std_logic;

signal eSwitchesAlu : std_logic;
signal eCarryEnable : std_logic;
signal eMdrAlu : std_logic;
signal eDdataAlu : std_logic;
signal eAPeek : std_logic_vector(3 downto 0);
signal eBPeek : std_logic_vector(3 downto 0);
signal eI210Peek : std_logic_vector(2 downto 0);
signal 	microZero : std_logic;
signal microCarry : std_logic;
signal microOverflow:  std_logic;
signal microSign : std_logic;
signal macroZero :  std_logic;
signal macroCarry : std_logic;
signal macroOverflow : std_logic;
signal macroSign : std_logic;

signal execOutTemp : std_logic_vector(7 downto 0);

--systemInit

signal initMapperAddress : std_logic_vector(7 downto 0);
signal initMapperData : std_logic_vector(7 downto 0);
signal initMapperWe: std_logic;

signal initMicroAddress : std_logic_vector(7 downto 0);
signal initMicroData : std_logic_vector(39 downto 0);
signal initMicroWe : std_logic;

signal initMacroAddress  : std_logic_vector(7 downto 0);
signal initMacroData : std_logic_vector(7 downto 0);
signal initMacroWe : std_logic;

signal initBoardAddress : std_logic_vector(7 downto 0);

 
begin
c1 : macro port map(clock=>clock,address=>initMacroAddress,
			data=>initMacroData,wren=>initMacroWE,q=>macroQ);
			
c2: mapperWritable port map(clock=> not clock,address=>initMapperAddress,data=>initMapperData,wren=>initMapperWe,
	q=>cFirstMcmdAddr);
	
c3 : controlUnit port map(clock=>clock,conditionBit=>cConditionBit,
		firstMcmdAddr=>cFirstMcmdAddr,d=>eD,i=>eI,a=>eA,
		b=>eB,sh=>eSh,selB=>eSelB,carryEnable=>eCarryEnable,mapperSeq=>mapperSeq,
		switchesAlu=>eSwitchesAlu,
		mdrAlu=>eMdrAlu,ddataAlu=>eDdataAlu,aluMacro=>eAluMacro,aluMar=>eAluMar,
		updateFlags=>eUpdateFlags,con=>eCon,microAddress=>microAddress,microCmd=>microCmd,microQ=>microQ,
		externalReset=>externalReset);
			
c4: executionUnit port map(clk=>clock,memAddr=>macroAddress,
	memData=>macroData,memWe=>macroWE,memQ=>macroQ,a=>eA,b=>eB,d=>eD,
	i=>eI,con=>eCon,sh=>eSh,selB=>eSelB,aluMacro=>eAluMacro,aluMar=>eAluMar,
	updateFlags=>eUpdateFlags,switchesAlu=>eSwitchesAlu,carryEnable=>eCarryEnable,
	mdrAlu=>eMdrAlu,ddataAlu=>eDdataAlu,cond=>cConditionBit,switchesData=>switchesData,
	execOut=>execOutTemp,regAddr_aOut=>regAddr_aOut,regAddr_bOut=>regAddr_bOut,
	q_aOut=>q_aOut,q_bOut=>q_bOut,
	regData_bOut=>regData_bOut,regWe_bOut=>regWe_bOut,macroCarryOut=>macroCarry,microCarryOut=>microCarry,
		macroZeroOut=>macroZero,macroOverflowOut=>macroOverflow,
		microZeroOut=>microZero,microOverflowOut=>microOverflow,
		macroSignOut=>macroSign,microSignOut=>microSign,aluOut=>aluOut,
		reg0=>reg0,reg1=>reg1,reg2=>reg2,reg3=>reg3,reg4=>reg4,reg5=>reg5,reg6=>reg6,
		reg7=>reg7,reg8=>reg8,reg9=>reg9,reg10=>reg10,reg11=>reg11,reg12=>reg12,reg13=>reg13,
		reg14=>reg14,reg15=>reg15,MDRdisplay=>MDRdisplay,QRegister=>QRegister,externalReset=>externalReset);

	c5 : microWritable port map(clock=> clock, address=> initMicroAddress, q=>microQ,data=>initMicroData,wren=>initMicroWe);
	
	c6 : systemInit port map(mapperAddress=>mapperAddress,macroAddress=>macroAddress,microAddress=>microAddress,
	clk=> clock,macroData=>macroData,macroWe=>macroWE,boardAddress=>initBoardAddress,boardInput=>initBoardInput,
	sel=>initSel,enable=>initEnable,rst=>not initRst, mapperData=>initMapperData,mapperAddressOut=>initMapperAddress,
	mapperWeOut=>initMapperWe,macroAddressOut=>initMacroAddress,macroDataOut=>initMacroData,
	macroWeOut=>initMacroWe,microAddressOut=>initMicroAddress,microData=>initMicroData,microWeOut=>initMicroWe,
	enableWriting=>enableWriting,externalReset=>externalReset,fiveLeds=>fiveLeds,middle7=>middle7,right7=>right7,
	left7=>left7);
	
	process(macroQ)
	begin
			mapperAddress<=macroQ;
	end process;
	
	
	initBoardAddress<=switchesData;
	--signals for display/debugging
	macroAddressOut<=initMacroAddress;
	microAddressOut<=initMicroAddress;
	
	execOut<=  execOutTemp;
	mapperAddressOut <=initMapperAddress;
	cFirstMcmdAddrOut<=cFirstMcmdAddr;
	macroZOCS<=macroZero&macroOverflow&macroCarry&macroSign;
	microZOCS<=microZero&microOverflow&microCarry&microSign;
	macroDataOut<=initMacroData;
	initMapperDataOut<=initMapperData;
	initMicroDataOut<=initMicroData;

end project;
	