----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2018 10:14:41 AM
-- Design Name: 
-- Module Name: bcd_to_decimal - Behavioral
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

entity bcd_to_decimal is
  Port (
    bcd_1s: in std_logic_vector(3 downto 0);
    bcd_10s: in std_logic_vector(3 downto 0);
    bcd_decimal: out std_logic_vector(7 downto 0)
   );
end bcd_to_decimal;

architecture Behavioral of bcd_to_decimal is

begin

bcd_decimal <= bcd_1s + (bcd_10s * x"A");


end Behavioral;
