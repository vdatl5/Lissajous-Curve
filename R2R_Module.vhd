----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2018 02:20:15 PM
-- Design Name: 
-- Module Name: R2R_Module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity R2R_Module is
  Port ( 
    clock: std_logic; 
    x_out: out std_logic_vector(7 downto 0);
    y_out: out std_logic_vector(7 downto 0);
    read_address: out std_logic_vector(5 downto 0);
    syncronization: in std_logic; 
    data_in: in std_logic_vector(15 downto 0)
  );
end R2R_Module;

architecture Behavioral of R2R_Module is

begin


    process(clock) is 
    variable read_value : std_logic_vector(5 downto 0) := "000000";
    begin
        if(clock'event and clock = '1') then 
            --get the new read value 
            if(syncronization = '1') then 
                --syncronize to the cordic input speed
                read_value := read_value + "000001";
                read_address <= read_value; 
                
                x_out <= data_in(15 downto 8);
                y_out <= data_in(7 downto 0);            
            end if; 
            
        end if; 
    end process; 

end Behavioral;
