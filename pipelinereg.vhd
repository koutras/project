-- pipelineReg --
library ieee;
use ieee.std_logic_1164.all;

entity pipelineReg is
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
end pipelineReg;

architecture pipelineReg of pipelineReg is
begin
			bra <= dataIn(39 downto 35); --branch offset	
			bin <= dataIn(34 downto 32); -- how to obtain next address
			con <= dataIn(31 downto 29); -- how's the condition selected
			a<= dataIn(19 downto 16);-- A register address
			b<= dataIn(15 downto 12);-- B register address
			i210 <= dataIn(28 downto 26);-- operands
			i543 <= dataIn(25 downto 23);-- arithmetic/logic operation
			i876 <= dataIn(22 downto 20);-- destination of result
			d<= dataIn(11 downto 10);-- 2 bit direct data
			sh <= dataIn(9);-- circular or linear shift
			selb<= dataIn(8);-- feedback of alu output to register address
			mwe <= dataIn(7);-- enable of writing to macromemory
			aluMar <=dataIn(6); -- place output of alu to MAR
			updateFlags<= dataIn(5); --update alu flags
			mapperSeq<= dataIn(4); -- enable mapper to read next macroaddress
			switchesAlu <= dataIn(3); --direct data obtained for circuit switches
			carryEnable <= dataIn(2); -- carry Enable
			mdrAlu <= dataIn(1); -- place contents of MDR to ALU direct Input
			ddataAlu <= dataIn(0); -- enable the two bit direct data 'd'	

end pipelineReg;
			
			
			