
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity myRegisters is

	port
	(
--		inclock	: in std_logic;
--		outclock	: in std_logic;
		clk : in std_logic;
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

end myRegisters;

architecture rtl of myRegisters is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((8-1) downto 0);
	type memory_t is array(2**4-1 downto 0) of word_t;

	-- Declare the RAM 
	shared variable ram : memory_t;

begin
	--process(inclock)
	process(clk,externalReset)
	begin
		if(externalReset='1') then
			for i in 0 to 15 loop
				ram(i):=(others=>'0');
			end loop;
		elsif(clk'event and clk='0') then
			if(we_b='1') then
				ram(conv_integer(addr_b)):=data_b;
			end if;	
		end if;
	end process;
	
	process(addr_a,addr_b,we_b)
	begin
				q_a<=ram(conv_integer(addr_a));
				q_b<=ram(conv_integer(addr_b));
	end process;
	
	
	reg0<=ram(0);
	reg1<=ram(1);
	reg2<=ram(2);
	reg3<=ram(3);
	reg4<=ram(4);
	reg5<=ram(5);
	reg6<=ram(6);
	reg7<=ram(7);
	reg8<=ram(8);
	reg9<=ram(9);
	reg10<=ram(10);
	reg11<=ram(11);
	reg12<=ram(12);
	reg13<=ram(13);
	reg14<=ram(14);
	reg15<=ram(15);
end rtl;
