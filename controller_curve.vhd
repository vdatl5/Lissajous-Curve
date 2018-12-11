----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2018 07:48:59 PM
-- Design Name: 
-- Module Name: controller_curve - Behavioral
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

entity controller_curve is
  Port ( 
  calculationDone: in std_logic; 
  cordic_0_tready: in std_logic; 
  cordic_1_tready: in std_logic; 
  clock: in std_logic; 
  controlSignal: out std_logic_vector(1 downto 0):="00"
  );
end controller_curve;

architecture Behavioral of controller_curve is

type states is (NewInput, GetOutput, CalculateOutput);
signal current_state : states := NewInput; 


begin

    process(clock) is
    begin
        if(clock'event and clock = '1') then
            if(current_state = NewInput) then 
                --in this state, you calculate the new input 
                --and set the status as ready for tyhe cordic
                current_state <= GetOutput; 
                controlSignal <= "01";
            elsif(current_state = GetOutput) then 
                --in this state we wait for both the cordic modules to be 
                -- to return a valid output
                current_state <= GetOutput; 
                controlSignal <= "01";
                if(cordic_0_tready = '1' and cordic_1_tready = '1') then 
                    --go to the next state
                    current_state <= CalculateOutput; 
                    controlSignal <= "10";
                end if; 
                
            elsif(current_state = CalculateOutput) then
                --in this state waiting for the output calculations to be complete
                current_state <= CalculateOutput; 
                controlSignal <= "10";
                if(calculationDone = '1') then 
                    current_state <= NewInput; 
                    controlSignal <= "00";
                end if; 
                
            end if;         
        
       end if; 
    
    end process;

end Behavioral;
