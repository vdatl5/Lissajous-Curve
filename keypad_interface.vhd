----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2018 11:08:50 AM
-- Design Name: 
-- Module Name: keypad_interface - Behavioral
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

entity keypad_interface is
  Port (
    clk: in std_logic; 
    Rows: in std_logic_vector(3 downto 0);
    Columns: inout std_logic_vector(3 downto 0) := "0000";
    button_press : out std_logic := '0'; --indicates when a button press has been detected. 
    Decoded: out std_logic_vector(3 downto 0) := "0000"
   );
end keypad_interface;

architecture Behavioral of keypad_interface is

type states is (A, B, C, D, E, F);
signal current_state, next_state: states := A; --current state and next state are of the type state 
signal Qflip, debounce_in, debounce_out : std_logic := '0'; -- input and output signals from the debounce flipflops

begin
    debounce_in <= (not rows(0)) or (not rows(1)) or (not rows(2)) or (not rows(3)); --if any of the rows are true, means we have a response    
    process(clk)
    begin
        if(clk'event and clk = '1') then
            Qflip <= debounce_in; --debouncing
            debounce_out <= Qflip;  -- debouncing
                           
            button_press <= '0'; --by default, the button press is 0 unless changed.
            columns <= "0000"; --by default they are on
            case current_state is
                when A =>
                    --seaching for a press 
                    columns <= "0000";
                    if((debounce_out and debounce_in) = '1') then 
                        --if after debouncing, there is an agreement that a row signal is 1
                        current_state <= B; -- go to the next state
                        columns <= "1110";
                    else
                        current_state <= A; --stay in current state
                    end if;                    
                when B =>
                     columns <= "1110"; -- only turn the first column on
                     if((debounce_out and debounce_in) = '1') then --if a row signal is 1
                        -- button press in this column has been detected 
                        button_press <= '1';
                        current_state <= F;
                        --decode the rows
                        if rows = "1110" then 
                            Decoded <= "0001"; --1
                        elsif rows = "1101" then 
                            Decoded <= "0100"; --4
                        elsif rows = "1011" then 
                            Decoded <= "0111";  --7
                        elsif rows = "0111" then 
                            Decoded <= "0000"; --0
                        end if; 
                        
                     elsif debounce_in = '0' then
                        current_state <= C;
                         columns <= "1101";
                     else 
                        current_state <= B;
                     end if; 
                when C =>
                          columns <= "1101"; -- only turn the second column on
                          if((debounce_out and debounce_in) = '1') then --if a row signal is 1
                             -- button press in this column has been detected 
                             button_press <= '1';
                             current_state <= F;
                             --decode the rows
                             if rows = "1110" then 
                                 Decoded <= "0010"; --2
                             elsif rows = "1101" then 
                                 Decoded <= "0101"; --5
                             elsif rows = "1011" then 
                                 Decoded <= "1000"; --8
                             elsif rows = "0111" then 
                                 Decoded <= "1111"; --F
                             end if; 
                             
                          elsif debounce_in = '0' then
                             current_state <= D;
                             columns <= "1011"; 
                          else 
                             current_state <= C;
                          end if;                     
                when D =>
                        columns <= "1011"; -- only turn the third column on
                        if((debounce_out and debounce_in) = '1') then --if a row signal is 1
                           -- button press in this column has been detected 
                           button_press <= '1';
                           current_state <= F;
                           --decode the rows
                           if rows = "1110" then 
                               Decoded <= "0011"; --3
                           elsif rows = "1101" then 
                               Decoded <= "0110"; --6
                           elsif rows = "1011" then 
                               Decoded <= "1001"; --9
                           elsif rows = "0111" then 
                               Decoded <= "1110"; --E
                           end if; 
                           
                        elsif debounce_in = '0' then
                           current_state <= E;
                           columns <= "0111";
                        else 
                           current_state <= D;
                        end if;
                when E =>
                        columns <= "0111"; -- only turn the fourth column on
                        if((debounce_out and debounce_in) = '1') then --if a row signal is 1
                           -- button press in this column has been detected 
                           button_press <= '1';
                           current_state <= F;
                           --decode the rows
                           if rows = "1110" then 
                               Decoded <= "1010"; --A
                           elsif rows = "1101" then 
                               Decoded <= "1011"; --B
                           elsif rows = "1011" then 
                               Decoded <= "1100"; --C
                           elsif rows = "0111" then 
                               Decoded <= "1101"; --D
                           end if; 
 
                         elsif debounce_in = '0' then
                              current_state <= A;
                              columns <= "0000";                          
                        else 
                           current_state <= E; --remain in this state
                        end if;
               when F =>
                        columns <= "0000"; --turn all the columns on and wait for the button release
                        --decoded <= "0000"; --the decoded output is reset
                        if(debounce_out = '1' or debounce_in = '1') then  --wait until the debounce out signal is 0 before moving to the starting state
                            current_state <= F;  
                        else
                            current_state <= A;
                        end if; 
                                 
            end case; 
            
        end if;  
    end process; 
end Behavioral;
