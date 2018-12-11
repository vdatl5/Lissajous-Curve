----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2018 06:51:16 PM
-- Design Name: 
-- Module Name: User_Interface - Behavioral
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

entity User_Interface is
  Port (
    clock:in std_logic;
    mode_switches:in std_logic_vector(1 downto 0);
    display_button:in std_logic;
    up_button:in std_logic; 
    down_button:in std_logic; 
    left_button:in std_logic; 
    right_button:in std_logic;
    keypad_A_1:in std_logic_vector(3 downto 0);
    keypad_A_2: in std_logic_vector(3 downto 0);
    keypad_B_1: in std_logic_vector(3 downto 0);
    keypad_B_2: in std_logic_vector(3 downto 0);
    v_offset: inout std_logic_vector(6 downto 0) := "0000000";
    h_offset: inout std_logic_vector(6 downto 0) := "0000000";
    v_sign: inout std_logic; 
    h_sign: inout std_logic; 
    displayStatus: inout std_logic := '0';
    A_out: out std_logic_vector(7 downto 0) := x"01";
    B_out: out std_logic_vector(7 downto 0) := x"01";
  SSEG1: out std_logic_vector(4 downto 0) := "00000";
    SSEG2: out std_logic_vector(4 downto 0) := "00000";
    SSEG3: out std_logic_vector(4 downto 0) := "00000";
    SSEG4: out std_logic_vector(4 downto 0) := "00000";
    SSEG5: out std_logic_vector(4 downto 0) := "00000";
    SSEG6: out std_logic_vector(4 downto 0) := "00000";
    SSEG7: out std_logic_vector(4 downto 0) := "00000";
    SSEG8: out std_logic_vector(4 downto 0) := "00000"
   );
end User_Interface;

--component Keypad_top is
--    Port (
--       Rows: in std_logic_vector(3 downto 0);
--        Columns: inout std_logic_vector(3 downto 0) := "0000";       
--        clock: in std_logic; 
--        A_0 : out std_logic_vector(3 downto 0) := x"0";
--        A_1 : out std_logic_vector(3 downto 0) := x"0";
--        B_0 : out std_logic_vector(3 downto 0) := x"0";
--        B_1 : out std_logic_vector(3 downto 0) := x"0"  
    
--     );
--end component;

architecture Behavioral of User_Interface is

component bcd_to_decimal is
  Port (
    bcd_1s: in std_logic_vector(3 downto 0);
    bcd_10s: in std_logic_vector(3 downto 0);
    bcd_decimal: out std_logic_vector(7 downto 0)
   );
end component;


type display_states is (NoPress, FirstPress, FirstRelease, SecondPress);
signal current_disp_state: display_states := NoPress ;

signal dispButtonQflip, dispButtonDebounce_in, dispButtonDebounce_out: std_logic := '0';

signal upButtonQflip, upButtonDebounce_in, upButtonDebounce_out, up_press: std_logic := '0';
signal downButtonQflip, downButtonDebounce_in, downButtonDebounce_out, down_press: std_logic := '0';
signal rightButtonQflip, rightButtonDebounce_in, rightButtonDebounce_out, right_press: std_logic := '0';
signal leftButtonQflip, leftButtonDebounce_in, leftButtonDebounce_out, left_press: std_logic := '0';


--keypad signals 
signal KA_decimal: std_logic_vector(7 downto 0);
signal KB_decimal: std_logic_vector(7 downto 0);

signal bcd_decimal_A1, bcd_decimal_A2, bcd_decimal_B1, bcd_decimal_B2 :  std_logic_vector(3 downto 0);
begin

    KA_Conv: bcd_to_decimal Port MAP (
        bcd_1s => keypad_A_1,
        bcd_10s => keypad_A_2,
        bcd_decimal => KA_decimal
       );
       
    KB_Conv: bcd_to_decimal Port MAP (
       bcd_1s => keypad_B_1,
       bcd_10s => keypad_B_2,
       bcd_decimal => KB_decimal
      );
             
    process(clock)
    
    variable v_button_count: std_logic_vector(7 downto 0) := "00000000";
    variable h_button_count: std_logic_vector(7 downto 0) := "00000000";
    variable previous_KA, previous_KB: std_logic_vector(7 downto 0);
    variable v_digit1, v_digit2, h_digit1, h_digit2: std_logic_vector(6 downto 0);
   
    
    begin 
        if(clock'event and clock = '1') then 
        
        --display button code -------------
            --disp button debouncing 
            dispButtonDebounce_in <= display_button;
            dispButtonQflip <= dispButtonDebounce_in;
            dispButtonDebounce_out <= dispButtonQflip; 
            
            
            --case statement for the display button operation
            case current_disp_state is 
                
                when NoPress => --There is no press, display not active
                    displayStatus <= '0';
                    if(dispButtonDebounce_in and dispButtonDebounce_out) = '1' then
                        --if there is a button press
                        current_disp_state <= FirstPress; 
                    else
                        --if there is no button press
                        current_disp_state <= NoPress;   
                    end if;
                
                when FirstPress => --Tehre is a press, display active
                    displayStatus <= '1';
                    if(dispButtonDebounce_in = '0' and dispButtonDebounce_out = '0') then
                        --if there is a button release
                        current_disp_state <= FirstRelease; 
                    else
                        --if there is a continued button press or noise
                        current_disp_state <= FirstPress;   
                    end if;                
                    
                when FirstRelease => --There is no press, display is active
                    displayStatus <= '1';
                    if(dispButtonDebounce_in and dispButtonDebounce_out) = '1' then
                        --if there is a button press
                        current_disp_state <= SecondPress; 
                    else
                        --if there is no button press
                        current_disp_state <= FirstRelease;   
                    end if;                    
                    
                when SecondPress => --There is a press, displau is not active
                    displayStatus <= '0';
                    if(dispButtonDebounce_in = '0' and dispButtonDebounce_out = '0') then
                        --if there is a button release
                        current_disp_state <= NoPress; 
                    else
                        --if there is a continued button press or noise
                        current_disp_state <= SecondPress;   
                    end if;      
            end case; 
            
                
 
            --up button debouncing 
             upButtonDebounce_in <= up_button;
             upButtonQflip <= upButtonDebounce_in;
             upButtonDebounce_out <= upButtonQflip;
        
             --left button debouncing 
             downButtonDebounce_in <= down_button;
             downButtonQflip <= downButtonDebounce_in;
             downButtonDebounce_out <= downButtonQflip;
           
             --right button debouncing 
             rightButtonDebounce_in <= right_button;
             rightButtonQflip <= rightButtonDebounce_in;
             rightButtonDebounce_out <= rightButtonQflip;

             --left button debouncing 
             leftButtonDebounce_in <= left_button;
             leftButtonQflip <= leftButtonDebounce_in;
             leftButtonDebounce_out <= leftButtonQflip;    
             
             
             --- set SSEG1 to be the mode switch number 
              SSEG1 <= "000" & mode_switches;
             
             --different modes
             if(mode_switches = "00") then 
             --circle mode
             
                 v_button_count := x"00";
                 h_button_count := x"00";
                 v_offset <= "0000000";
                 h_offset <= "0000000";
                 v_sign <= '0';
                 h_sign <= '0';
                 
                if(displayStatus = '0') then
                     A_out <= "00000001";
                     B_out <= "00000001"; 
                else 
                    A_out <= "00000000";
                    B_out <= "00000000"; 
                end if; 

                previous_KA := KA_decimal; 
                previous_KB := KB_decimal; 
             
             
             --SSEG
              SSEG1 <= "00000";
              SSEG2 <= "00000";
              SSEG3 <= "00000";
              SSEG4 <= "00000";
              SSEG5 <= "00000";
              SSEG6 <= "00000";
              SSEG7 <= "00000";
              
             elsif(mode_switches = "01") then 
                
                previous_KA := KA_decimal; 
                previous_KB := KB_decimal; 
                --A and B out are 1 and 1
                if(displayStatus = '0') then
                     A_out <= "00000001";
                     B_out <= "00000001"; 
                else 
                    A_out <= "00000000";
                    B_out <= "00000000"; 
                end if; 
                --if the up button is pressed
                if(upButtonDebounce_in = '1' and upButtonDebounce_out = '1' ) then 
                    if(up_press = '0') then 
                        up_press <= '1';
                        v_button_count := v_button_count + "00000001";
                        --increment variable
                    end if; 
                elsif ( not(upButtonDebounce_in) and not(upButtonDebounce_out)) = '1'  then 
                    --the button is not pressed 
                    if(up_press = '1') then 
                        up_press <= '0';
                   end if;     
                end if; 
             
                --if the down button is pressed
                if(downButtonDebounce_in = '1' and downButtonDebounce_out = '1' ) then 
                    if(down_press = '0') then 
                        down_press <= '1';
                         v_button_count := v_button_count - "00000001";
                        --decrement variable
                    end if; 
                elsif ( not(downButtonDebounce_in) and not(downButtonDebounce_out)) = '1'  then 
                    --the button is not pressed 
                    if(down_press = '1') then 
                        down_press <= '0';
                   end if;     
                end if; 
                
                --if the right button is pressed
                if(rightButtonDebounce_in = '1' and rightButtonDebounce_out = '1' ) then 
                    if(right_press = '0') then 
                        right_press <= '1';
                         h_button_count := h_button_count + "00000001";
                        --increment variable
                    end if; 
                elsif ( not(rightButtonDebounce_in) and not(rightButtonDebounce_out)) = '1'  then 
                    --the button is not pressed 
                    if(right_press = '1') then 
                        right_press <= '0';
                   end if;     
                end if; 
                
                --if the left button is pressed
                if(leftButtonDebounce_in = '1' and leftButtonDebounce_out = '1' ) then 
                    if(left_press = '0') then 
                        left_press <= '1';
                         h_button_count := h_button_count - "00000001";
                        --decrement variable
                    end if; 
                elsif ( not(leftButtonDebounce_in) and not(leftButtonDebounce_out)) = '1'  then 
                    --the button is not pressed 
                    if(left_press = '1') then 
                        left_press <= '0';
                   end if;     
                end if; 
       
               --v_offset <= v_button_count(6 downto 0);
               --h_offset <= h_button_count(6 downto 0); 
                               
               if(signed(v_button_count) < 0) then 
                    v_sign <= '1';
                    v_offset <= "0000000" - v_button_count(6 downto 0);
               else
                    v_sign <= '0';    
                    v_offset <= v_button_count(6 downto 0);
               end if;
               
               if(signed(h_button_count) < 0) then 
                     h_sign <= '1';
                    h_offset <= "0000000" - h_button_count(6 downto 0) ;
               else
                    h_sign <= '0';
                     h_offset <= h_button_count(6 downto 0);    
               end if;
               
               if(v_offset > "1011001") then 
                      --89
                      v_digit1 := v_offset - "1011001" - "0000001";
                      v_digit2 := "0001001";
               elsif(v_offset > "1001111") then
                       --79
                       v_digit1 := v_offset - "1001111" - "0000001";
                       v_digit2 := "0001000";              
               elsif(v_offset > "1000101") then
                        --69
                       v_digit1 := v_offset - "1000101" - "0000001";
                        v_digit2 := "0000111";                  
               elsif(v_offset > "0111011") then
                        --59
                       v_digit1 := v_offset - "0111011" - "0000001";
                        v_digit2 := "0000110";                           
               elsif(v_offset > "0110001") then
                       --49
                       v_digit1 := v_offset - "0110001" - "0000001";
                       v_digit2 := "0000101";                          
               elsif(v_offset > "0100111") then
                       --39          
                        v_digit1 := v_offset - "0100111" - "0000001";
                       v_digit2 := "0000100";                                                               
               elsif(v_offset > "0011101") then
                    v_digit1 := v_offset - "0011101" - "0000001";
                    v_digit2 := "0000011";
               elsif(v_offset > "0010011") then
                    v_digit1 := v_offset - "0010011" - "0000001";
                    v_digit2 := "0000010";
               elsif(v_offset > "0001001") then
                     v_digit1 := v_offset - "0001001" - "0000001";
                     v_digit2 := "0000001";
               else
                       v_digit1 := v_offset;
                       v_digit2 := "0000000";
               end if; 
 
               if(h_offset > "1011001") then 
                       --89
                       h_digit1 := h_offset - "1011001" - "0000001";
                       h_digit2 := "0001001";
                elsif(h_offset > "1001111") then
                        --79
                        h_digit1 := h_offset - "1001111" - "0000001";
                        h_digit2 := "0001000";              
                elsif(h_offset > "1000101") then
                         --69
                        h_digit1 := h_offset - "1000101" - "0000001";
                         h_digit2 := "0000111";                  
                elsif(h_offset > "0111011") then
                         --59
                        h_digit1 := h_offset - "0111011" - "0000001";
                         h_digit2 := "0000110";                           
                elsif(h_offset > "0110001") then
                        --49
                        h_digit1 := h_offset - "0110001" - "0000001";
                        h_digit2 := "0000101";                          
                elsif(h_offset > "0100111") then
                        --39          
                         h_digit1 := h_offset - "0100111" - "0000001";
                        h_digit2 := "0000100";                                                               
                elsif(h_offset > "0011101") then
                     h_digit1 := h_offset - "0011101" - "0000001";
                     h_digit2 := "0000011";
                elsif(h_offset > "0010011") then
                     h_digit1 := h_offset - "0010011" - "0000001";
                     h_digit2 := "0000010";
                elsif(h_offset > "0001001") then
                      h_digit1 := h_offset - "0001001" - "0000001";
                      h_digit2 := "0000001";
                else
                        h_digit1 := h_offset;
                        h_digit2 := "0000000";
                end if; 
                              
               SSEG7 <= v_sign & v_digit1(3 downto 0);
               SSEG8 <= v_sign & v_digit2(3 downto 0);
               
               SSEG5 <= h_sign & h_digit1(3 downto 0);
               SSEG6 <= h_sign & h_digit2(3 downto 0);
             elsif(mode_switches = "10") then
                --keypad mode
                
                v_button_count := x"00";
                h_button_count := x"00";
                v_offset <= "0000000";
                h_offset <= "0000000";
                v_sign <= '0';
                h_sign <= '0';
                
                if(previous_KA = KA_decimal) then
                    A_out <= "00000001";
                    SSEG5 <= "00001";
                    SSEG6 <= "00000";
                else
                    A_out <= KA_decimal;
                    SSEG5 <= '0' & keypad_A_1;
                    SSEG6 <= '0' & keypad_A_2;
                end if; 
                
                if(previous_KB = KB_decimal) then 
                    B_out <= "00000001"; 
                    SSEG7 <= "00001";
                    SSEG8 <= "00000";
                else 
                    B_out <= KB_decimal;
                    SSEG7 <= '0' & keypad_B_1;
                    SSEG8 <= '0' & keypad_B_2;
                
                end if; 
                
                if(displayStatus = '1') then
                    --reset
                    A_out <= "00000000";
                    B_out <= "00000000"; 
                end if; 
                
                 --SSEG
                 SSEG2 <= "00000";
                 SSEG3 <= "00000";
                 SSEG4 <= "00000";
             elsif (mode_switches = "11") then 
                    A_out <= "00000001";
                    B_out <= "00000011";                           
                    if(displayStatus = '1') then
                        --reset
                        A_out <= "00000000";
                        B_out <= "00000000"; 
                    end if;                     
                    --b
                    SSEG7 <= "00011";
                    SSEG8 <= "00000";
                    
                    --a
                    SSEG5 <= "00001";
                    SSEG6 <= "00000";        
                    
                    --the rest 
                    SSEG2 <= "00000";
                    SSEG3 <= "00000";
                    SSEG4 <= "00000";            
             end if; 
       
        end if; 
        

    end process;

end Behavioral;























