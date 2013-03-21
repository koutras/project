library ieee;
use ieee.std_logic_1164.all;

entity systemInit is
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
				----------------------------------------------------------------
				mapperData : out std_logic_vector(7 downto 0);
				mapperAddressOut : out std_logic_vector(7 downto 0);
				mapperWeOut : out std_logic;
				
				macroAddressOut : out std_logic_vector(7 downto 0);
				macroDataOut : out std_logic_vector(7 downto 0);
				macroWeOut : out std_logic;
				
				microAddressOut : out std_logic_vector(7 downto 0);
				microData : out std_logic_vector(39 downto 0);
				fiveLeds : out std_logic_vector(4 downto 0);
				left7	: out std_logic_vector(6 downto 0);
				middle7 : out std_logic_vector(6 downto 0);
				right7 : out std_logic_vector(6 downto 0);
				microWeOut : out std_logic
);
end systemInit;

architecture a of systemInit is

signal mapperAddressTemp : std_logic_vector(7 downto 0);

signal macroAddressTemp : std_logic_vector(7 downto 0);
signal macroDataTemp : std_logic_vector(7 downto 0);
signal macroWeTemp : std_logic;
signal macroDataInit : std_logic_vector(7 downto 0);
signal macroWeInit : std_logic;

signal microAddressTemp : std_logic_vector(7 downto 0);

signal mapReadEnable :std_logic;
signal microReadEnable : std_logic;
signal macroReadEnable : std_logic;

component wordRead is
port (			
				clk : in std_logic;
				rst : in std_logic;
				input : std_logic_vector(3 downto 0);
				isReady : out std_logic;
				enable : in std_logic;
				output :  out std_logic_vector( 7 downto 0)
	);
end component;

component pipelineReader is
	port (
				clk : in std_logic;
				rst : in std_logic;
				input : std_logic_vector(4 downto 0);
				enable : in std_logic;
				isReady : out std_logic;
				fiveLeds : out std_logic_vector(4 downto 0);
				left7	: out std_logic_vector(6 downto 0);
				middle7 : out std_logic_vector(6 downto 0);
				right7 : out std_logic_vector(6 downto 0);
				
				output :  out std_logic_vector( 39 downto 0)
	);
end component;

begin

pipelineRead : pipelineReader port map(clk=>clk,rst=>rst,input=>boardInput(4 downto 0),
	isReady=>microWeOut,output=>microData,enable=>microReadEnable,fiveLeds=>fiveLeds,
	middle7=>middle7,right7=>right7,left7=>left7);

macroWordRead :component wordRead port map(clk=>clk,rst=>rst,input=>boardInput(3 downto 0),
isReady=>macroWeInit,output=>macroDataInit,enable=>macroReadEnable);

mapperWordRead : component wordRead port map(clk=>clk,rst=>rst,input=>boardInput(3 downto 0),
isReady=>mapperWeOut,output=>mapperData,enable=>mapReadEnable);

process(enable,sel,mapperAddress,macroAddress,microAddress,boardAddress,
macroData,macroWe,macroDataInit,macroWeInit,mapReadEnable,macroReadEnable,
microReadEnable,enableWriting)
begin
	if(enable='0') then
		mapperAddressTemp<=mapperAddress;
		macroAddressTemp<=macroAddress;
		microAddressTemp<=microAddress;
		macroDataTemp<=macroData;
		macroWeTemp<=macroWe;
		
		mapReadEnable<='0';
		macroReadEnable<='0';
		microReadEnable<='0';
	else
		case sel is
			when "00"=>mapperAddressTemp<=boardAddress; --change mapper
										macroAddressTemp<=macroAddress;
										microAddressTemp<=microAddress;
										
										macroDataTemp<=macroData;
										macroWeTemp<=macroWe;
										
										if(enableWriting='1') then
											mapReadEnable<='1';
										else
											mapReadEnable<='0';
										end if;
										macroReadEnable<='0';
										microReadEnable<='0';
			when "01"=>
										mapperAddressTemp<=mapperAddress;--change macromemory
										macroAddressTemp<=boardAddress;
										microAddressTemp<=microAddress;
										
										macroDataTemp<=macroDataInit;
										macroWeTemp<=macroWeInit;
										
										mapReadEnable<='0';
										if(enableWriting='1') then
											macroReadEnable<='1';
										else
											macroReadEnable<='0';
										end if;
										microReadEnable<='0';
			when others=>
										mapperAddressTemp<=mapperAddress;-- change micromemory
										macroAddressTemp<=macroAddress;
										microAddressTemp<=boardAddress;
										
										macroDataTemp<=macroData;
										macroWeTemp<=macroWe;
										
										mapReadEnable<='0';
										macroReadEnable<='0';
										if(enableWriting='1') then
											microReadEnable<='1';
										else
											microReadEnable<='0';
										end if;
		end case;
	end if;
end process;


mapperAddressOut<=mapperAddressTemp;

macroAddressOut<=macroAddressTemp;
macroDataOut<=macroDataTemp;
macroWeOut<=macroWeTemp;

process(externalReset,microAddressTemp)
begin
	if(externalReset='1') then
		microAddressOut<="00000000";
	else
		microAddressOut<=microAddressTemp;
	end if;
end process;

end a;

			