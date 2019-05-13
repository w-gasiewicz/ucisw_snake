----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:19:07 04/28/2019 
-- Design Name: 
-- Module Name:    snake - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity snake is
    Port ( KBD : in  STD_LOGIC_VECTOR (3 downto 0);
           DO_RDY : in  STD_LOGIC;
			  CLK : in STD_LOGIC;
           X : in  STD_LOGIC_VECTOR (11 downto 0);
           Y : in  STD_LOGIC_VECTOR (11 downto 0);
           D : out  STD_LOGIC);
end snake;

architecture Behavioral of snake is
-- Basic snake array:
type INT_ARRAY is array (integer range <>, integer range <>) of integer;
SIGNAL snake_arr : INT_ARRAY(0 to 1, 0 to 20):=((399,299), others=> (others=>-1));
SIGNAL snake_len : INTEGER := 0;

SIGNAL h_pos : INTEGER := 0;
SIGNAL v_pos : INTEGER := 0;
SIGNAL direction : INTEGER := 0;
SIGNAL draw_temp : STD_LOGIC := '0';

SIGNAL time_signals : std_logic_vector(25 downto 0):= (others => '0');
SIGNAL move_rdy : STD_LOGIC := '0';

begin

-- Should move the snake each half a sec 
time_counter:process(time_signals, move_rdy)
begin
   if(CLK'event and CLK = '1') then
      time_signals <= std_logic_vector( unsigned(time_signals) + 1 );
      if(time_signals = "01011111010111100001000000") then
			time_signals <= (others => '0');
         move_rdy <= '1';
      end if;
   end if;
end process;


change_direction:process(DO_RDY, direction, KBD)
begin
   if(DO_RDY = '1') then
      direction <= to_integer(unsigned(KBD));
   end if;
end process;

move_snake:process(CLK, snake_arr, snake_len, direction)
begin
   if(move_rdy = '1') then
		move_rdy <= '0';
		-- Shift the whole array
		if(snake_len > 0) then
			shift_loop : for k in snake_len to 1 loop
				snake_arr(k,0) <= snake_arr(k-1,0);
				snake_arr(k,1) <= snake_arr(k-1,1);
			end loop shift_loop;
		end if;
		-- Move the snake head
      if(direction = 8) then
         snake_arr(0,1) <= snake_arr(0,1) - 2;
      elsif(direction = 4) then
         snake_arr(0,1) <= snake_arr(0,1) + 2;
      elsif(direction = 2) then
         snake_arr(0,0) <= snake_arr(0,0) + 2;
      elsif(direction = 1) then
         snake_arr(0,0) <= snake_arr(0,0) - 2;
      end if;
   end if;
end process;

draw:process(CLK, X, Y, draw_temp)
begin
	if(CLK'event and CLK = '1') then
		h_pos <= to_integer(unsigned(X));
		v_pos <= to_integer(unsigned(Y));
		
      if(((h_pos >= 0 AND h_pos <= 6) OR (h_pos >= 792 AND h_pos <= 798))) then -- vertical boundaries
         D <= '1';
		elsif((h_pos > 0 AND h_pos < 799) AND ((v_pos >= 0 AND v_pos <= 6) OR (v_pos >= 593 AND v_pos <= 599))) then -- horizontal boundaries
			D <= '1';
      else	-- snake body
			draw_temp <= '0';
			draw_snake: for k in 0 to snake_arr'length loop
				if((h_pos > snake_arr(k,0) - 5 AND h_pos < snake_arr(k,0) + 5) AND ((v_pos > snake_arr(k,1) - 5) AND (v_pos < snake_arr(k,1) + 5))) then
					draw_temp <= '1';
				end if;
			end loop draw_snake;
			D <= draw_temp;
		end if;
	end if;
end process;

end Behavioral;

