library ieee;
use ieee.std_logic_1164.all;
-- opou yparxei praxi me kratoumeno exw enoisei to macrocarry
--diladi stis arithmitikes praxeis kai shift
entity executionUnit is
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
				execOut : out std_logic_vector(7 downto 0);--execution output
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
	
end executionUnit;

architecture executionUnit of executionUnit is
		

	component alu is
		port(
			 carryEnable : in std_logic;
			 cin : in std_logic;
			 R : in  std_logic_vector(7 downto 0);
			 S : in	std_logic_vector(7 downto 0);
			 sel : in std_logic_vector(2 downto 0);
			 dataOut : out std_logic_vector(7 downto 0);
			 clk : in std_logic;
			 carry : out std_logic;
			 sign : out std_logic;
			 overflow : out std_logic;
			 zero : out std_logic
			 
	);
	end component;
	


	component sourceSelector is
		port (
				 -- out 
				R : out std_logic_vector(7 downto 0);
				S : out std_logic_vector(7 downto 0);
				 -- in
				sel : in std_logic_vector(2 downto 0);
				A : in std_logic_vector(7 downto 0);
				B : in std_logic_vector(7 downto 0);
				D : in std_logic_vector(7 downto 0);
				Q : in std_logic_vector(7 downto 0)
				
	);
	end component;
	


component myRegisters is

	port
	(
		clk				: in std_logic;
		addr_a	: in  std_logic_vector(3 downto 0);
		addr_b	: in std_logic_vector(3 downto 0);
		data_b	: in std_logic_vector((8-1) downto 0);
		we_b	: in std_logic := '1';
		externalReset : in std_logic;
		q_a		: out std_logic_vector((8 -1) downto 0);
		q_b		: out std_logic_vector((8 -1) downto 0);
		reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,
		reg11,reg12,reg13,reg14,reg15 : out std_logic_vector(7 downto 0)
	);

end component;

	component destSelector is
	port(
				sel : in std_logic_vector(2 downto 0);
		--out
		
		circEnable : in std_logic; -- enable circular shift
		
		A : in std_logic_vector(7 downto 0);--needed to forward to
														-- to ouput
		
		aluRes : in std_logic_vector(7 downto 0);--alu result		
		dataOut : out std_logic_vector(7 downto 0);--output
		--signals from/to the status register
		microCarry : out std_logic;
		Carry : in std_logic;
		
		
		--outputs to register memory and q register

		qEnable : out std_logic;
		regEnable :out std_logic;
		
		outQ : out std_logic_vector(7 downto 0);
		outReg : out std_logic_vector(7 downto 0)
			
	);
	end component;
	
	component qReg is
		port (
		inData : in std_logic_vector(7 downto 0);
		writeEnable : in std_logic;
		clk : in std_logic;
		outData : out std_logic_vector(7 downto 0)

	);
	end component;
	
component DDataMux is
	port(
		MDR : in std_logic_vector(7 downto 0);
		switchData : in std_logic_vector( 7 downto 0);
		microData : in std_logic_vector( 1 downto 0);

		memE : in std_logic;
		swiE : in std_logic;
		micE : in std_logic;

		dataOut : out std_logic_vector(7 downto 0)
	);

end component;

component feedbackReg is
	port ( dataIn : in std_logic_vector(3 downto 0);
			   B : in std_logic_vector(3 downto 0);
				selB : in std_logic;
				clk : in std_logic;
				-- out 
				dataOut : out std_logic_vector(3 downto 0)
			);
end component;

component statusRegister is
port
	(	con : in std_logic_vector(2 downto 0); -- condition
		updateFlags : in std_logic; --refresh data
		y : out std_logic; -- output condition bit
		carry : in std_logic;
		sign : in std_logic;
		overflow : in std_logic;
		zero : in  std_logic;
		clk : in std_logic;
		macroCarryOut :  out std_logic;
		macroSignOut : out std_logic;
		macroOverflowOut : out std_logic;
		macroZeroOut : out std_logic;
		microCarryOut : out std_logic;
		microSignOut : out std_logic;
		microOverflowOut : out std_logic;
		microZeroOut : out std_logic
	);
end component;
--alu
signal aluR : std_logic_vector(7 downto 0);
signal aluS : std_logic_vector(7 downto 0);
signal aluSel : std_logic_vector(2 downto 0);
signal aluDataOut : std_logic_vector(7 downto 0);


--registers
signal regAddr_b : std_logic_vector(3 downto 0);
signal regAddr_a : std_logic_vector(3 downto 0);
signal regWe_b : std_logic;
signal regData_b : std_logic_vector( 7 downto 0);
signal regQ_a : std_logic_vector(7 downto 0);
signal regQ_b : std_logic_vector(7 downto 0);


--source selector
signal sourceA: std_logic_vector(7 downto 0);
signal sourceB: std_logic_vector(7 downto 0);
signal sourceD: std_logic_vector(7 downto 0);
signal sourceQ: std_logic_vector(7 downto 0);
signal sourceSel : std_logic_vector( 2 downto 0);

--dest selector
signal destSel :  std_logic_vector(2 downto 0);
signal destCirc : std_logic;
signal destA : std_logic_vector(7 downto 0);
signal destAluRes :std_logic_vector(7 downto 0);
signal destCarry : std_logic;


--q register
signal qIN :std_logic_vector(7 downto 0);
signal qWriteEnable : std_logic;
--signal qOut : std_logic_vector(7 downto 0);

--DData Mux
signal DMDR : std_logic_vector(7 downto 0);
signal DswitchData : std_logic_vector( 7 downto 0);
signal DmicroData : std_logic_vector( 1 downto 0);
signal DmemE : std_logic;
signal DswiE : std_logic;
signal DmicE : std_logic;

--feedback reg
signal feedbackDataIn : std_logic_vector(3 downto 0);
signal feedbackOut : std_logic_vector(3 downto 0);

--status register
signal statusCon : std_logic_vector(2 downto 0);
signal statusUpdateFlags : std_logic;
signal statusCarry : std_logic;
signal statusCarryDest : std_logic;
signal statusCarryAlu : std_logic;
signal statusSign : std_logic;
signal statusOverflow : std_logic;
signal statusZero : std_logic;
		
--signals with many uses
signal dataOut : std_logic_vector(7 downto 0);

signal macroCarry : std_logic;

signal memAddrStore : std_logic_vector(7 downto 0);  
signal memDataStore : std_logic_vector(7 downto 0);

begin

c1 : alu port map( carryEnable=>carryEnable, cin=>macroCarry, R=>aluR,
		S=>aluS, sel=>aluSel, dataOut=>destAluRes,carry=>statusCarryAlu,
		sign=>statusSign,overflow=>statusOverflow,zero=>statusZero,clk=>clk);
		
	
c2: myRegisters port map(addr_a=>regAddr_a,addr_b=>regAddr_b,data_b=>regData_b,clk=>clk,
				we_b=>regWe_b,q_a=>sourceA,q_b=>sourceB,
		reg0=>reg0,reg1=>reg1,reg2=>reg2,reg3=>reg3,reg4=>reg4,reg5=>reg5,reg6=>reg6,
		reg7=>reg7,reg8=>reg8,reg9=>reg9,reg10=>reg10,reg11=>reg11,reg12=>reg12,reg13=>reg13,
		reg14=>reg14,reg15=>reg15,externalReset=>externalReset);		
				
c3 : sourceSelector port map(sel=>sourceSel,A=>sourceA,B=>sourceB,d=>sourceD,
		Q=>sourceQ,R=>aluR, S=>aluS);
		
c4 : destSelector port map(sel=>destSel, circEnable=>sh, A=>destA,
			aluRes=>destAluRes, Carry=>macroCarry,microCarry=>statusCarryDest,
			dataOut=>dataOut,qEnable=>qWriteEnable,regEnable=>regWe_b,
			outQ=>qIN,outReg=>regData_b);
			
c5: qReg port map(inData=>qIN,writeEnable=>qWriteEnable,outData=>sourceQ,clk=>clk);

c6 : DDataMux port map(MDR=>memQ,switchData=>switchesData,
			microData=>d, memE=>mdrAlu,swiE=>switchesAlu,micE=>ddataAlu
			,dataOut=>sourceD);
			
c7 : feedbackReg port map(dataIn=>feedbackDataIn,clk=>clk,
				B=>b,selB=>selB,
				dataOut=>feedBackOut);
				
c8 : statusRegister port map(con=>con,updateFlags=>updateFlags,y=>cond,
		carry=>statusCarry,sign=>statusSign,overflow=>statusOverflow,zero=>statusZero,
		clk=>clk,macroCarryOut=>macroCarry,microCarryOut=>microCarryOut,
		macroZeroOut=>macroZeroOut,macroOverflowOut=>macroOverflowOut,
		microZeroOut=>microZeroOut,microOverflowOut=>microOverflowOut,
		macroSignOut=>macroSignOut,microSignOut=>microSignOut);



regAddr_a<=a;
regAddr_b<=feedBackOut;

feedbackDataIn<=dataOut(3 downto 0);
destA<=sourceA;


process(i,statusCarryDest,statusCarryAlu)
begin
		if(i(7)='1') then
			statusCarry<=statusCarryDest;
		else
			statusCarry<=statusCarryAlu;
		end if;	
		
sourceSel<=i(2 downto 0);	
aluSel<=i(5 downto 3);
destSel<=i(8 downto 6);
end process;

process(aluMar,aluMacro,dataOut,memQ,clk)
begin
	if(clk'event and clk='0') then --want to be steady
		if(aluMar='1') then
			memAddr<=dataOut;
		end if;
	
		if(aluMacro='1') then
			memWe<='1';
			memData<=dataOut;
			MDRdisplay<=dataOut;
		else
			memWe<='0';
			MDRdisplay<=memQ;
		end if;
		
	end if;
end process;

--process(alu,aluMacro) --refresh a virtual MDR
--							--used for display purposes
--begin
--	if(aluMacro'event) then
--		MDRdisplay<=dataOut;
--	else
--		MDRdisplay<=memQ;
--	end if;
--end process;
	

aluOut<=destAluRes;
regAddr_aOut <=regAddr_a;
regAddr_bOut <=regAddr_b;
execOut <= dataOut;
q_aOut<=sourceA;
q_bOut<=sourceB;
regData_bOut <= regData_b;
regWe_bOut<= regWe_b;
macroCarryOut<=macroCarry;
QRegister<=sourceQ;
end executionUnit;