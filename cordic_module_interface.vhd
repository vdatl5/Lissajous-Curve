----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2018 01:03:29 PM
-- Design Name: 
-- Module Name: cordic_module_interface - Behavioral
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
use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic_module_interface is
  Port (
  clock: in std_logic; 
  A_value: in std_logic; 
  B_value: in std_logic;
  out_valid: out std_logic; 
  X_value: out std_logic_vector(7 downto 0);
  Y_value: out std_logic_vector(7 downto 0)
   );
end cordic_module_interface;

architecture Behavioral of cordic_module_interface is

--make an array of time value 
Component cordic_0 IS
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

signal changeValue: std_logic_vector(31 downto 0);
signal changeValueX: std_logic_vector(7 downto 0);
signal changeValueY: std_logic_vector(7 downto 0);



begin

c1: cordic_0 PORT MAP(
  aclk => clock,
  s_axis_phase_tvalid => '1',
  s_axis_phase_tdata => "0000000000000000",
  m_axis_dout_tvalid => out_valid,
  m_axis_dout_tdata => changeValue
);

X_value(7) <= not changeValue(31); 
X_value(6 downto 0) <= changeValue(30 downto 24);
Y_value(7) <= not changeValue(15);
Y_value(7) <= not changeValue(15);
Y_value(6 downto 0) <= changeValue(14 downto 8);




end Behavioral;






















