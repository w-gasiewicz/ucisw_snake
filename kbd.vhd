----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:26:54 03/16/2019 
-- Design Name: 
-- Module Name:    kbd - Behavioral 
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

entity kbd is
    Port ( CLK : in  STD_LOGIC;
			DO : in  STD_LOGIC_VECTOR (7 downto 0);
		    E0 : in STD_LOGIC;
            F0 : in  STD_LOGIC;
            DO_RDY : in  STD_LOGIC;
            KBD : out  STD_LOGIC_VECTOR (3 downto 0);
            RDY: out STD_LOGIC);
end kbd;

architecture Behavioral of kbd is	
SIGNAL keys : STD_LOGIC_VECTOR (3 downto 0) := "0000";
begin
first:process(CLK, DO, F0, E0, keys)
begin
    if(DO_RDY = '1') then
      RDY <= '0';
        if(DO = X"1D") then -- letter W
            if(E0 = '0' AND F0 = '0' AND keys(3) = '0') then
               keys <= "1000";
            elsif(E0 = '0' AND F0 = '1') then
               keys <= "0000";
            end if;
        end if;
        
        if(DO = X"1B") then -- letter S
            if(E0 = '0' AND F0 = '0' AND keys(2) = '0') then
               keys <= "0100";
            elsif(E0 = '0' AND F0 = '1') then
               keys <= "0000";
            end if;
        end if;
        
        if(DO = X"1C") then -- letter A
            if(E0 = '0' AND F0 = '0' AND keys(1) = '0') then
               keys <= "0010";
            elsif(E0 = '0' AND F0 = '1') then
               keys <= "0000";
            end if;
        end if;
        
        if(DO = X"23") then -- letter D
            if(E0 = '0' AND F0 = '0' AND keys(0) = '0') then
               keys <= "0001";
            elsif(E0 = '0' AND F0 = '1') then
               keys <= "0000";
            end if;
        end if;
        
    end if; 
    KBD <= keys;
    RDY <= '1';
end process;
end Behavioral;

