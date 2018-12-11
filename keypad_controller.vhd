----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/01/2018 06:05:35 PM
-- Design Name: 
-- Module Name: keypad_adder - Behavioral
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

entity keypad_adder is
  Port (
    control_signal: out std_logic_vector(3 downto 0) :=x"0";
    clock: in std_logic; 
    button_pressed: in std_logic;
    decoded_out: in std_logic_vector(3 downto 0)
   );
end keypad_adder;



architecture Behavioral of keypad_adder is
--states


type states is (Reset, Get_no, Add, Display);
signal current_state: states := reset; 

type two_number_array is array (1 downto 0) of std_logic_vector(3 downto 0); --an array of two numbers
signal temp_sum: two_number_array := (x"0", x"0"); --hold entered number
signal input_buffer: two_number_array := (x"0", x"0"); --hold entered number


begin          
    
    process(clock)
    begin
        if(clock'event and clock = '1') then 
        
            --if(button_pressed = '1') then -- if there is keypad input, record and shift buffer to the left
            --    input_buffer(0) <= decoded_out;
            --    input_buffer(1) <= input_buffer(0);
            --end if; 
            control_signal <= x"4";
            case current_state is 
            
                when reset =>
                
               -- if(button_pressed = '1' and decoded_out = x"A") then
               --     current_state <= Add; 
                --    control_signal <= x"2";
               -- elsif(button_pressed = '1' and decoded_out = x"B") then
                --    current_state <= Display;
                --    control_signal <= x"3";
               if(button_pressed = '1' and decoded_out = x"F") then
                    current_state <= reset;
                    control_signal <= x"5";                              
                elsif(button_pressed = '1') then --if there is a button press
                        current_state <= Get_no; 
                        input_buffer(0) <= decoded_out;
                        input_buffer(1) <= input_buffer(0);
                        control_signal <= x"1";
                    else
                        current_state <= reset; --stay in reset state    
                        temp_sum <= (x"0", x"0");
                        input_buffer <= (x"0", x"0"); 
                        control_signal <= x"0";
                    end if;
               
                when get_no =>

                     if(button_pressed = '1' and decoded_out = x"A") then
                         current_state <= Add; 
                         control_signal <= x"2";
                     elsif(button_pressed = '1' and decoded_out = x"B") then
                         current_state <= Display;
                         control_signal <= x"3";
                     elsif(button_pressed = '1' and decoded_out = x"F") then
                             current_state <= reset;
                             control_signal <= x"5";                     
                     elsif(button_pressed = '1') then --if there is a button press
                             current_state <= Get_no; 
                             input_buffer(0) <= decoded_out;
                             input_buffer(1) <= input_buffer(0);
                             control_signal <= x"1";
                     elsif(button_pressed = '0') then 
                         current_state <= get_no; 
                    end if; 
                
                
                when add => 
                    current_state <= get_no; 
               when display =>       
                    --go back to start state
                    current_state <= reset; 
                    control_signal <= x"0";
                    temp_sum <= (x"0", x"0");
                    input_buffer <= (x"0", x"0"); 
            end case;
            
        
        end if; 
    end process; 

end Behavioral;
