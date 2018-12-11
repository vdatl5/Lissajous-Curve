----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2018 09:47:50 AM
-- Design Name: 
-- Module Name: Keypad_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Keypad_top is
    Port (
        Rows: in std_logic_vector(3 downto 0);
        Columns: inout std_logic_vector(3 downto 0) := "0000";       
        clock: in std_logic; 
        A_0 : out std_logic_vector(3 downto 0) := x"1";
        A_1 : out std_logic_vector(3 downto 0) := x"0";
        B_0 : out std_logic_vector(3 downto 0) := x"1";
        B_1 : out std_logic_vector(3 downto 0) := x"0"  
     );
end Keypad_top;

architecture Behavioral of Keypad_top is

    component keypad_interface is
      Port (
        clk: in std_logic; 
        Rows: in std_logic_vector(3 downto 0);
        Columns: inout std_logic_vector(3 downto 0) := "0000";
        button_press : out std_logic := '0'; --indicates when a button press has been detected. 
        Decoded: out std_logic_vector(3 downto 0) := "0000"
       );
    end component;

    component keypad_adder_top is
  Port ( 
    A_0 : out std_logic_vector(3 downto 0) := x"0";
    A_1 : out std_logic_vector(3 downto 0) := x"0";
    B_0 : out std_logic_vector(3 downto 0) := x"0";
    B_1 : out std_logic_vector(3 downto 0) := x"0";  
    clock: in std_logic; 
    button_pressed: in std_logic;
    control: in std_logic_vector(3 downto 0) :=x"0";
    decoded_out: in std_logic_vector(3 downto 0)
    
    );
    end component;
    
        
    component keypad_adder is
      Port (
        control_signal: out std_logic_vector(3 downto 0);
        clock: in std_logic; 
        button_pressed: in std_logic;
        decoded_out: in std_logic_vector(3 downto 0)
       );
    end component;

    signal A_0_Value, A_1_value, B_0_value, B_1_value: std_logic_vector(3 downto 0);
   -- signal clock, button_pressed: std_logic := '0';
   signal button_pressed: std_logic := '0';
   signal decoded_out: std_logic_vector(3 downto 0);
    --type int_array is array (0 to 8) of std_logic_vector(3 downto 0);
    --constant keypress: int_array :=(x"1", x"2", x"A", x"2", x"4", x"A", x"1", x"2", x"B");
    --signal key: std_logic_vector(3 downto 0):=x"0";
    signal controler: std_logic_vector(3 downto 0) :=x"0";
    
    
begin

ki: keypad_interface
  Port MAP(
    clk => clock,
    Rows => rows, 
    Columns => columns,
    button_press => button_pressed,
    Decoded => decoded_out
   );

    uut:keypad_adder_top Port MAP (
        A_0 => A_0,
        A_1 => A_1,
        B_0 => B_0,
        B_1 => B_1, 
        clock => clock,
        button_pressed => button_pressed,
        control => controler,
        decoded_out => decoded_out
       );
       
      k1: keypad_adder Port map (
           control_signal => controler,
           clock => clock, 
           button_pressed => button_pressed, 
           decoded_out => decoded_out
      );

end Behavioral;
