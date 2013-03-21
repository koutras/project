---mscc microsequencer control circuit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mscc is
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
end mscc;

-- bin cond loadSeq load_dir_seq,s,fileEnable,push,jumpTostart
architecture mscc of mscc is


	
	constant TRUE : std_logic :='1';
	constant FALSE : std_logic:='0';
	constant MPC : std_logic_vector:="00";
	constant AR : std_logic_vector:="01";
	constant STK : std_logic_vector:="10";
	constant DDATA : std_logic_vector:="11";
	
	
	--BIN
	constant CONT : std_logic_vector(2 downto 0):="000";
	constant J2S : std_logic_vector(2 downto 0):="001";
	constant UJMP : std_logic_vector(2 downto 0) :="010";
	constant CJMP : std_logic_vector(2 downto 0):="011";
	constant UJSR : std_logic_vector(2 downto 0):="100";
	constant CJSR : std_logic_vector(2 downto 0):="101";
	constant URSR : std_logic_vector(2 downto 0):="110";
	constant CRSR : std_logic_vector(2 downto 0):="111";


begin

process(bin,mapperSeq,cond)
begin
		if(mapperSeq=TRUE) then
			sel<=DDATA;
			stackEnable<=FALSE;
			push<='0';
			jumpToStart<=FALSE;
		else
			case bin is
				when CONT => sel<=MPC;
								 stackEnable<=FALSE;
								 push<='0';
								 jumpToStart<=FALSE;
				
				when J2S => sel<=(others=>'0');
								jumpToStart<=TRUE;
								stackEnable<=FALSE;
								 push<='0';
								
				when UJMP => sel<=AR;
								 stackEnable<=FALSE;
								 push<='0';
								 jumpToStart<=FALSE;
								 
				when CJMP =>if(cond=TRUE) then
								sel<=AR;
								stackEnable<=FALSE;
								 push<='0';
								 jumpToStart<=FALSE;
								 
								else
								sel<=MPC;
								stackEnable<=FALSE;
								 push<='0';
								 jumpToStart<=FALSE;
							end if;
								 
				when UJSR => sel<= AR;
								 stackEnable<=TRUE;
								 push<=TRUE;
								 jumpToStart<=FALSE;
								 
				when CJSR =>if(cond=TRUE) then
									sel<=AR;
									stackEnable<=TRUE;
									push<=TRUE;
									jumpToStart<=FALSE;
								else
									sel<=MPC;
									stackEnable<=FALSE;
									push<='0';
									jumpToStart<=FALSE;
								end if;
								 
				when URSR => stackEnable<=TRUE;
									push<=FALSE;
									sel<=STK;
									jumpToStart<=FALSE;
									
				when CRSR => if(cond=TRUE) then
									stackEnable<=TRUE;
									push<=FALSE;
									sel<=STK;
									jumpToStart<=FALSE;
								else
									sel<=MPC;
									stackEnable<=FALSE;
									push<='0';
									jumpToStart<=FALSE;
								end if;
			end case;
		end if;
end process;
	
end mscc;

