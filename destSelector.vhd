--destSelector
library ieee;
use ieee.std_logic_1164.all;
entity destSelector is
	port(
		sel : in std_logic_vector(2 downto 0);
		--out	
		circEnable : in std_logic; -- enable carryIn
		A : in std_logic_vector(7 downto 0);--needed to forward to ouput
		--B : in std_logic_vector(7 downto 0); --the address to write
		aluRes : in std_logic_vector(7 downto 0);--alu result		
		dataOut : out std_logic_vector(7 downto 0);--output
		--signals from/to the status register
		microCarry : out std_logic;
		Carry : in std_logic;
		--outputs to register memory and q register
		qEnable : out std_logic;
		regEnable :out std_logic;
		outQ : out std_logic_vector(7 downto 0);
		clk : in std_logic;
		outReg : out std_logic_vector(7 downto 0)
	);
end destSelector;

architecture destSelector of destSelector is

	constant FALSE : std_logic:='0';
	constant TRUE : std_logic:='1';
	
	-- reg <---> Q (connected as shown )

begin
	process(sel,aluRes,Carry,A,circEnable)
		variable Q : std_logic_vector(7 downto 0);
		variable reg : std_logic_vector(7 downto 0);	
	begin
			case sel is
				when "000" =>
									dataOut <= aluRes;
									Q:=aluRes; 
									regEnable<=FALSE;
									qEnable<=TRUE;
									reg:="00000000";
									microCarry<='0';
				when "001" => dataOut <= aluRes; 
									regEnable<=FALSE;
									qEnable<=FALSE;
									Q:="00000000";
									reg:="00000000";
									microCarry<='0';

				when "010" => 	dataOut <= A;
									reg:=aluRes;
									regEnable<=TRUE;
									qEnable<=FALSE;
									Q:="00000000";
									microCarry<='0';

				when "011" => dataOut <= aluRes;
									reg:=aluRes;
									regEnable<=TRUE;
									qEnable<=FALSE;
									Q:="00000000";
									microCarry<='0';

				when "100" => dataOut <= aluRes;			--RAMQD						
									--double shift to the right
									Q:=aluRes;
									reg:=aluRes;
									microCarry<=Q(0);
									if(circEnable='1') then
										reg(reg'high downto 0):=Carry & reg(reg'high downto 1);
									else
										reg(reg'high downto 0):='0' & reg(reg'high downto 1);	
									end if;
									Q(Q'high downto 0):=reg(0) & Q(Q'high downto 1);
									regEnable<=TRUE;
									qEnable<=TRUE;
									
				when "101" =>dataOut <= aluRes;  --RAMD
									reg:=aluRes;
									microCarry<=reg(0);
									if(circEnable=TRUE) then
										reg(reg'high downto 0):=Carry & reg(reg'high downto 1);
									else
										reg(reg'high downto 0):='0' & reg(reg'high downto 1);
									end if;
									regEnable<=TRUE;
									qEnable<=FALSE;
									Q:="00000000";

				when "110" =>dataOut <= aluRes;  --RAMQU
									reg:=aluRes;
									Q:=aluRes;
									microCarry<=reg(7);
									reg(reg'high downto 0):=reg(reg'high -1 downto 0)&Q(7);
									if(circEnable=TRUE) then
										Q(Q'high downto 0):=Q(Q'high -1 downto 0) & Carry;
									else
										Q(Q'high downto 0):=Q(Q'high -1 downto 0)& '0';
									end if;
									regEnable<=TRUE;
									qEnable<=TRUE;
									
				when "111" =>dataOut <= aluRes; --RAMU
									reg:=aluRes;
									microCarry<=reg(7);
									if(circEnable=TRUE) then
										reg(reg'high downto 0):=reg(reg'high -1 downto 0)& Carry;
									else
										reg(reg'high downto 0):=reg(reg'high-1 downto 0) & '0';
									end if;
									regEnable<=TRUE;
									qEnable<=FALSE;
									Q:="00000000";

	end case;	
	outQ <= Q;
	outReg <= reg;
	end process;
end destSelector;