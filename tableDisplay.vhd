-- it is an entity that defines the characters
-- that are displayed on the screen
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity tableDisplay is
port(
			clock_50Mhz  : in std_logic;			
			-- data to display
			microCommand : in std_logic_vector(0 to 39);
			nxMicro : in std_logic_vector(0 to 7);
			macroAddr : in std_logic_vector(0 to 7);
			macroData : in std_logic_vector(0 to 7);
			mapAddr : in std_logic_vector(0 to 7);
			mapData : in std_logic_vector(0 to 7); --mapQ
			aluOut : in std_logic_vector(0 to 7);
			execOut : in std_logic_vector(0 to 7);
			macroZOCS : in std_logic_vector(0 to 3);
			microZOCS : in std_logic_vector(0 to 3);
			addrA : in std_logic_vector(0 to 3);
			addrB : in std_logic_vector(0 to 3);
			AQ : in std_logic_vector(0 to 7);
			BQ : in std_logic_vector(0 to 7);
			dataB : in std_logic_vector(0 to 7);
			microData : in std_logic_vector(0 to 39);
			mapperData : in std_logic_vector(0 to 7);
			reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,
		reg11,reg12,reg13,reg14,reg15 : in std_logic_vector(0 to 7);
		MDRdisplay : in std_logic_vector(0 to 7);
		QRegister : in std_logic_vector(0 to 7);
			
			--to vga
			vgaRed : out std_logic;
			vgaGreen : out std_logic;
			vgaBlue : out std_logic;
			vgaClock :out std_logic;
			vgaOn : out std_logic;
			vgaHorizSync : out std_logic;
			vgaVertSync : out std_logic
			

	);
end tableDisplay;

architecture a of tableDisplay is

subtype letter is std_logic_vector(5 downto 0);
type letterVector is array(natural range<>) of letter;

--80x60=4800
type letterTable is array(4799 downto 0) of letter;


signal bra : std_logic_vector(0 to 4);
signal bin : std_logic_vector(0 to 2);
signal con : std_logic_vector(0 to 2);
signal i20 : std_logic_vector(0 to 2);
signal i53 : std_logic_vector(0 to 2);
signal i86 : std_logic_vector(0 to 2);
signal aMicro : std_logic_vector(0 to 3);
signal bMicro : std_logic_vector(0 to 3);
signal dMicro : std_logic_vector(0 to 1);
signal controlBitsHigh : std_logic_vector(0 to 4);
signal controlBitsLow : std_logic_vector(0 to 4);

constant a :letter:= o"01";
constant b :letter:=o"02";
constant c :letter :=o"03";
constant d :letter :=o"04";
constant e :letter :=o"05";
constant i :letter :=o"11";
constant f :letter :=o"06";
constant g :letter :=o"07";
constant h : letter:=o"10";
constant l :letter :=o"14";
constant m :letter :=o"15";
constant n :letter :=o"16";
constant o :letter :=o"17";
constant p :letter :=o"20";
constant q :letter :=o"21";
constant r :letter :=o"22";
constant s :letter :=o"23";
constant t :letter :=o"24";
constant u :letter :=o"25";
constant w: letter:=o"27";
constant x :letter :=o"30";
constant y :letter:=o"31";
constant z :letter :=o"32";
constant zero : letter:=o"60";
constant one : letter:=o"61";
constant two : letter:=o"62";
constant three : letter:=o"63";
constant five : letter:=o"65";
constant six : letter:=o"66";
constant seven : letter:=o"67";
constant eight : letter:=o"70";
constant nine : letter:=o"71";

constant sp : letter:=o"40";
constant pavla : letter:=o"55";
constant comma : letter:=o"56";
constant slash : letter:=o"57";


shared variable	printTable:  letterTable :=(others=>sp);

constant microcmdW : letterVector :=(m,i,c,r,o,c,m,d);
constant nextmcmdW : letterVector :=(n,x,t,sp,m,c,m,d,sp,a,d,d,r);
constant microDataW : letterVector:=(m,i,c,r,o,sp,d,a,t,a);
constant macroaddrW : letterVector:=(m,a,r);
constant macrodataW : letterVector:=(m,a,c,r,o,sp,d,a,t,a);
constant mdrW : letterVector:=(m,d,r);
constant mapraddrW : letterVector:=(m,e,m,o,u,t,slash,m,a,p,a,d,d,r);
constant mapprdataW : letterVector:=(m,a,p,p,r,sp,d,a,t,a);
constant accW : letterVector:=(a,c,c);
constant pcW : letterVector:=(p,c);
constant  xW : letterVector:=(x,sp);

-- start from column 27 
constant regsonefiveW : letterVector:=(r,e,g,s,sp,one,five,pavla,zero);

constant mapprqW : letterVector:=(m, a, p, p, r, sp, o,u,t);
constant aluoutW : letterVector:=(a, l, u, sp, o, u, t);
constant execoutW : letterVector:=(e, x, e, c, sp, o, u, t);
constant macrozocsW : letterVector:=(m, a, c, r, o, z, o, c, s);
constant microzocsW : letterVector:=(m, i, c, r, o, z, o, c, s);
constant addraW : letterVector:=(a, d, d, r, a);
constant addrbW : letterVector:=(a, d, d, r, b);
constant databW : letterVector:=(d, a, t, a, b);  
-------------------------------------------
constant braW : letterVector:=(b, r, a);
constant binW : letterVector:=(b, i, n);
constant conW : letterVector:=(c, o, n);
constant i20W : letterVector:=(i, two, comma, zero);
constant i53W : letterVector:=(i, five, comma, three);
constant i86W : letterVector:=(i, eight, comma, six);
constant aMW : letterVector:=(a,sp); -- fill an extra space
constant aBW : letterVector:=(b,sp);
constant aDW : letterVector:=(d,sp);
constant c95W : letterVector:=(c,nine,comma,five);
constant c50W : letterVector:=(c,five,comma,zero);
constant contHighW : letterVector:=(s,h,comma,sp,s,e,l,b,comma,sp,m,w,e,comma,sp,a,l,u,m,a,r,comma,sp,u,p,d,a,t,e,comma);
constant contLowW : letterVector:=(m,a,p,p,e,r,comma,sp,s,w,i,t,c,h,comma,sp,c,a,r,r,y,comma,sp,m,d,r,a,l,u,comma,sp,d,d,a,t,a);


component vga_sync is
	port( clock_25Mhz, red, green,blue : in std_logic;
			red_out, green_out,blue_out : out std_logic;
			horiz_sync_out, vert_sync_out : out std_logic;
			video_on_out :  out std_logic;
			pixel_clock_out : out std_logic;
			pixel_row, pixel_column : out std_logic_vector(9 downto 0));
end component;

component romController IS
	PORT(	clock						: IN 	STD_LOGIC;
			character_address			: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
			font_row, font_col			: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			rom_mux_output	: OUT	STD_LOGIC);
end component;

component clockDivider is
port ( inClock : in std_logic;
				outClock : buffer std_logic);
end component;


signal clock_25Mhz : std_logic;
signal pixel_clock : std_logic;
signal red_data,green_data,blue_data : std_logic;
signal pixel_row,pixel_col : std_logic_vector(9 downto 0);
signal char_address : std_logic_vector(5 downto 0);

signal tableRow : natural range 0 to 59;
signal tableCol : natural range 0 to 79;

procedure mapVector( aVector : std_logic_vector; ln : natural ; col : natural) is 
variable counter : natural := 0;
variable tempCol : natural;
begin
	for i in aVector'length-1 downto 0 loop 
		tempCol:=col+i;
		printTable(ln*80+tempCol):="110000"+conv_std_logic_vector(aVector(i),6);
	end loop;
end mapVector;

--beware the reverse order of the mapping
procedure mapWord (aVector : letterVector; ln : natural; col : natural ) is
begin
	for i in aVector'length-1 downto 0 loop
		printTable(ln*80+col +i) := aVector(i);
	end loop;
end mapWord;

function returnPrintTableData(ln : natural; col : natural) 
	return std_logic_vector is
begin
	return printTable(ln*80 + col);
end function;
	
begin
	c0 : vga_sync port map(clock_25Mhz=>clock_25Mhz,red=>red_data,
				green=>green_data,blue=>blue_data,horiz_sync_out=>vgaHorizSync,
				vert_sync_out=>vgaVertSync,video_on_out=>vgaOn,pixel_clock_out=>pixel_clock,
				pixel_row=>pixel_row,pixel_column=>pixel_col,red_out=>vgaRed,blue_out=>vgaBlue,
				green_out=>vgaGreen);
				

	c1 : clockDivider port map(inClock=>clock_50Mhz,outClock=>clock_25Mhz);
	
	c2 : romController port map(clock=>pixel_clock, character_address=>char_address,
				font_row=>pixel_row(2 downto 0),font_col=>pixel_col(2 downto 0),rom_mux_output=>green_data);

mapWord(microcmdW,2,0);
---------------------
mapWord(braW, 3,5);
mapWord(binW,4,5);
mapWord(conW,5,5);
mapWord(i20W,6,5);
mapWord(i53W,7,5);
mapWord(i86W,8,5);
mapWord(aMW,9,5);
mapWord(aBW,10,5);
mapWord(aDW,11,5);
mapWord(c95W,12,5);  mapWord(contHighW,12,25);
mapWord(c50W,13,5);  mapWord(contLowW,13,25);
-------------------------
mapWord(nextmcmdW,15,0);
mapWord(microDataW,41,6);
mapWord(macroaddrW,19,0);
mapWord(mdrW,20,0);
mapWord(macrodataW,21,0);

mapWord(mapraddrW,22,0);
mapWord(regsonefiveW,35,65);
mapWord(mapprDataW,23,7);
mapWord(mapprqW,24,7);
mapWord(aluoutW,27,0);
mapWord(execoutW,28,0);
mapWord(macrozocsW,30,0);
mapWord(microzocsW,31,0);
mapWord(addraW,37,0);
mapWord(addrbW,38,0);
mapWord(databW,39,0);

mapWord(xW,49,60);
mapWord(pcW,50,60);
mapWord(accW,51,60);





process(pixel_col,pixel_row)
begin
	tableRow<=conv_integer(pixel_row(9 downto 3)) mod 60;
	tableCol<=conv_integer(pixel_col(9 downto 3)) mod 80;
end process;

process(tableRow,tableCol)
begin
	char_address<=returnPrintTableData(tableRow,tableCol);
end process;

--map vector data


process(microCommand,
nxMicro,macroAddr,macroData,mapAddr,mapData,aluOut,execOut,
macroZOCS,microZOCS,addrA,addrB,AQ,BQ,dataB,microData,mapperData,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,
		reg11,reg12,reg13,reg14,reg15,MDRdisplay)
begin


bra<=microCommand(0 to 4);
bin<=microCommand(5 to 7);
con<=microCommand(8 to 10);
i20<=microCommand(11 to 13);
i53<=microCommand(14 to 16);
i86<=microCommand(17 to 19);
aMicro<=microCommand(20 to 23);
bMicro<=microCommand(24 to 27);
dMicro<=microCommand(28 to 29);
controlBitsHigh<=microCommand(30 to 34);
controlBitsLow<=microCommand(35 to 39);

mapVector(microCommand,2,16);
mapVector(nxMicro,15,16);
mapVector(microData,41,22);
mapVector(macroAddr,19,16);
mapVector(MDRdisplay,20,16);
mapVector(macroData,21,16);

mapVector(mapAddr,22,16);
mapVector(mapperData,23,24);
mapVector(mapData, 24, 24);							mapVector(reg15,36,65);
mapVector(aluOut, 27, 16);								mapVector(reg14,37,65);
mapVector(execOut, 28 ,16);							mapVector(reg13,38,65);
mapVector(macroZOCS, 30, 16);							mapVector(reg14,39,65);
mapVector(microZOCS, 31, 16);							mapVector(reg11,40,65);
mapVector(addrA, 37, 16);								mapVector(reg10,41,65);
mapVector(addrB, 38, 16);								mapVector(reg9,42,65);
mapVector(dataB, 39, 16); 								mapVector(reg8,43,65);
mapVector(reg7,44,65); 
mapVector(reg6,45,65);
mapVector(reg5,46,65);
mapVector(reg4,47,65);
mapVector(reg3,48,65);
mapVector(reg2,49,65);
mapVector(reg1,50,65);
mapVector(reg0,51,65);



end process;


process(bra,bin,con,i20,i53,i86,aMicro,bMicro,dMicro,controlBitsHigh,controlBitsLow)
begin

mapVector(bra, 3, 16); 	
mapVector(bin, 4, 16);	
mapVector(con, 5, 16);	
mapVector(i20, 6, 16);	
mapVector(i53, 7, 16);	
mapVector(i86, 8, 16);	
mapVector(aMicro, 9, 16);	
mapVector(bMicro, 10, 16);	
mapVector(dMicro, 11, 16); --D
mapVector(controlBitsHigh, 12, 16); -- ControlBits 10-6;
mapVector(controlBitsLow, 13, 16); -- ConrolBits  5-1
end process;



red_data<='0';
blue_data<='0';
vgaClock<=pixel_clock;
end a;
