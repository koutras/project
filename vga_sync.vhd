library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity vga_sync is
	port( clock_25Mhz, red, green,blue : in std_logic;
			red_out, green_out,blue_out : out std_logic;
			horiz_sync_out, vert_sync_out : out std_logic;
			video_on_out :  out std_logic;
			pixel_clock_out : out std_logic;
			pixel_row, pixel_column : out std_logic_vector(9 downto 0));
end vga_sync;

architecture a of vga_sync is
	signal horiz_sync, vert_sync : std_logic;
	signal video_on, video_on_v, video_on_h : std_logic;
	signal h_count, v_count : std_logic_vector(9 downto 0);
	

begin

video_on <= video_on_h and video_on_v;
pixel_clock_out<=clock_25Mhz;	

process
	begin
	wait until( clock_25Mhz'event) and ( clock_25Mhz='1');

	--Generate Horizontal and Vertical Timing signals for video signal
	--H_count counts pixels(650 + extra time for sync signals)
	--
	-- Horiz_sync -------------------------________------
	-- H_count	 	0		640			   659	755   799

	if(h_count=799) then
		h_count <= "0000000000";
	else
		h_count <=h_count + 1;
	end if;

		--Generate Horizontal Sync Signal using H_count

	if (h_count <=755 and h_count >=659) then
		horiz_sync<='0';
	else
		horiz_sync<='1';
	end if;
		
		--V_count counts row of pixels(480 + extra time for sync signals)
		--
		-- Vert_sync ---------------------________---------
		-- V_count 	 0			480		  493-494		524

	if(v_count>=524 and h_count>=699) then
		v_count <="0000000000";
	elsif( h_count = 699) then
		v_count <=v_count +1;
	end if;
			-- Generate Vertical Sync Signal using v_count

	if(v_count<=494 and v_count >=493) then
		vert_sync<='0';
	else
		vert_sync<='1';
	end if;

			--Generate Video on Screen Signals for pixel data

	if (h_count<=639) then
		video_on_h<='1';
		pixel_column<=h_count;
	else
		video_on_h<='0';
	end if;

	if(v_count<=479) then
		video_on_v<='1';
		pixel_row <=v_count;
	else
		video_on_v<='0';
	end if;

	red_out <= red and video_on;
	green_out <=green and video_on;
	blue_out <=blue and video_on;
	horiz_sync_out <= horiz_sync;
	vert_sync_out <=vert_sync;
	video_on_out <=   video_on;
	end process;
end a;


