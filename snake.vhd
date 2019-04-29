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
           X : in  STD_LOGIC_VECTOR (8 downto 0);
           Y : in  STD_LOGIC_VECTOR (8 downto 0);
           RGB : out  STD_LOGIC_VECTOR (3 downto 0));
end snake;

architecture Behavioral of snake is
-- Basic snake array:
type INT_ARRAY is array (integer range <>, integer range <>) of integer;
SIGNAL snake_array : INT_ARRAY(0 to 1, 0 to 20):=(others=> (others=>-1));

SIGNAL h_pos : INTEGER := 0;
SIGNAL v_pos : INTEGER := 0;
SIGNAL direction : INTEGER := 0;

begin
move_snake:process(CLK, snake_array, KBD)
begin

end process;

draw:process(CLK, X, Y)
begin
	if(CLK'event) then
		h_pos <= to_integer(unsigned(X));
		v_pos <= to_integer(unsigned(Y));
		
      if(((h_pos >= 0 AND h_pos <= 6) OR (h_pos >= 794 AND h_pos <= 799)) AND v_pos >= 16) then -- vertical boundaries
         RGB <= "111";
		elsif((h_pos > 5 AND h_pos < 794) AND ((v_pos >= 16 AND v_pos <= 22) OR (v_pos >= 593 AND v_pos <= 599))) then -- horizontal boundaries
			RGB <= "111";
      else
			RGB <= "000";   
		end if;
	end if;
end process;

end Behavioral;

