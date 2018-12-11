----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/01/2018 09:03:46 PM
-- Design Name: 
-- Module Name: keypad_adder_top - Behavioral
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

entity keypad_adder_top is
  Port ( 
  A_0 : out std_logic_vector(3 downto 0) := x"1";
  A_1 : out std_logic_vector(3 downto 0) := x"0";
  B_0 : out std_logic_vector(3 downto 0) := x"1";
  B_1 : out std_logic_vector(3 downto 0) := x"0";  
  clock: in std_logic; 
  button_pressed: in std_logic;
  control: in std_logic_vector(3 downto 0) :=x"0";
  decoded_out: in std_logic_vector(3 downto 0)
  
  );
end keypad_adder_top;

architecture Behavioral of keypad_adder_top is

signal s1, s2: std_logic_vector(3 downto 0);
type two_number_array is array (1 downto 0) of std_logic_vector(3 downto 0); --an array of two numbers
signal temp_sum: two_number_array := (x"0", x"0"); --hold entered number
signal input_buffer: two_number_array := (x"0", x"0"); --hold entered number

signal A_value: two_number_array := (x"0", x"0");
signal B_value: two_number_array := (x"0", x"0");

begin

    process(clock)
    begin 
       if(clock'event and rising_edge(clock)) then
           if(control = x"0") then 
                --reset the buffer
                input_buffer <= (x"0", x"0"); 
           elsif(control = x"1") then 
                --record number
                input_buffer(0) <= decoded_out;
                input_buffer(1) <= input_buffer(0);
           elsif (control = x"2") then
                -- A is pressed 
                A_0 <= input_buffer(0);
                A_1  <= input_buffer(1);
                -- Reset the buffer
                input_buffer(0) <= x"0";
                input_buffer(1) <= x"0"; 
           elsif(control = x"3") then
                -- B is pressed
                B_0 <= input_buffer(0);
                B_1 <= input_buffer(1);
                -- Reset the buffer 
                input_buffer(0) <= x"0";
                input_buffer(1) <= x"0";
                
           elsif(control = x"5") then
                -- F is pressed 
                B_0 <= x"1";
                B_1 <= x"0";
                A_0 <= x"1";
                A_1 <= x"0";
                 
           end if; 
       
       end if;

    
    end process; 


end Behavioral;
