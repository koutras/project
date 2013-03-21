library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY romController IS
	PORT(	clock						: IN 	STD_LOGIC;
			character_address			: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
			font_row, font_col			: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			rom_mux_output	: OUT	STD_LOGIC);
END romController;

ARCHITECTURE a OF romController IS
	SIGNAL	rom_data: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL	rom_address: STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	component charRom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;
BEGIN

c0 : charRom  port map(address=>rom_address,clock=>clock,q=>rom_data);

rom_address <= character_address & font_row;
-- Mux to pick off correct rom data bit from 8-bit word
-- for on screen character generation
rom_mux_output <= rom_data ( (CONV_INTEGER(NOT font_col(2 downto 0))));

END a;
