----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:26:54 03/16/2019 
-- Design Name: 
-- Module Name:    vga_driver - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_driver is
    Port ( CLK : in  STD_LOGIC;
           D : in STD_LOGIC;
			  X : out  STD_LOGIC_VECTOR (11 downto 0);
			  Y : out  STD_LOGIC_VECTOR (11 downto 0);
           RGB: out STD_LOGIC_VECTOR (2 downto 0);
           R : in STD_LOGIC;
           H_SYNC : out  STD_LOGIC;
           V_SYNC : out  STD_LOGIC);
end vga_driver;

architecture Behavioral of vga_driver is
	
	-- Horizontal timing constants:
	constant HD : integer := 799;		-- Display size 800X600 (799x599 counting from 0)
	constant HFP : integer := 56;		-- Horizontal Front Porch (right border)
	constant HSP : integer := 120;		-- Horizontal Sync Pulse (Retrace)
	constant HBP : integer := 64;		-- Horizontal Back Porch (left border)
	
	-- Vertical timing constants:
	constant VD : integer := 599;		
	constant VFP : integer := 37;		-- Vertical Front Porch
	constant VSP : integer := 6;		-- Vertical Sync Pulse
	constant VBP : integer := 23;		-- Vertical Back Porch;
	
	signal h_pos : integer := 0;
	signal v_pos : integer := 0;
	
	-- Flag that determines whether 
	-- the positions are within a drawable area.
	signal video_on : std_logic := '0';	
	
begin

-----------------------------------------
-- clk_div:process(CLK)
-- begin
	-- if(CLK'event and CLK = '1')then
		-- clk25 <= not clk25;
	-- end if;	
-- end process;
-----------------------------------------

-- Counting the horizontal and vertical position on screen
-- in sync with the 50 MHZ clock.

horiz_pos_counter:process(CLK, R)
begin
	if(R = '1') then
		h_pos <= 0;
	elsif(CLK'event and CLK = '1') then
		if(h_pos = HD + HFP + HSP + HBP) then
			h_pos <= 0;
		else
			h_pos <= h_pos + 1;
		end if;
	end if;
end process;

vert_pos_counter:process(CLK, R, h_pos)
begin
	if(R = '1') then
		v_pos <= 0;
	elsif(CLK'event and CLK = '1') then
		if(h_pos = HD + HFP + HSP + HBP) then
			if(v_pos = VD + VFP + VSP + VBP) then
				v_pos <= 0;
			else
				v_pos <= v_pos + 1;
			end if;
		end if;
	end if;
end process;

-- Horizontal and vertical syncing values. 
horiz_sync:process(CLK, R, h_pos)
begin
	if(R = '1') then
		H_SYNC <= '0';
	elsif(CLK'event and CLK = '1') then
		if((h_pos <= (HD + HFP) ) OR (h_pos > HD + HFP + HSP)) then
			H_SYNC <= '1';
		else
			H_SYNC <= '0';
		end if;
	end if;
end process;

vert_sync:process(CLK, R, v_pos)
begin
	if(R = '1') then
		V_SYNC <= '0';
	elsif(CLK'event and CLK = '1') then
		if((v_pos <= (VD + VFP) ) OR (v_pos > VD + VFP + VSP)) then
			V_SYNC <= '1';
		else
			V_SYNC <= '0';
		end if;
	end if;
end process;

-- Controlling the RGB output.
display_on:process(CLK, R, h_pos, v_pos)
begin
	if(R = '1') then
		video_on <= '0';
	elsif(CLK'event and CLK = '1') then
		if((h_pos <= HD) AND (v_pos <= VD)) then
			video_on <= '1';
		else
			video_on <= '0';
		end if;
	end if;
end process;

draw:process(CLK, R, h_pos, v_pos, video_on)
begin
	if(CLK'event AND CLK = '1') then
		if(video_on = '1') then
			X <= std_logic_vector(to_unsigned(h_pos, X'length));
			Y <= std_logic_vector(to_unsigned(v_pos, Y'length));
         if(D = '1') then
            RGB <= "111";
         else
            RGB <= "000";
         end if;
      else
         RGB <= "000";
		end if;
	end if;
end process;
end Behavioral;

