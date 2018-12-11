----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2018 11:55:37 AM
-- Design Name: 
-- Module Name: block_ram_module - Behavioral
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
use IEEE.Numeric_Std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bram_module is
  Port (
  clock : in std_logic; 
  data_in: in std_logic_vector(15 downto 0);
  read_address: in std_logic_vector(5 downto 0);
  data_out: out std_logic_vector(15 downto 0);
  write_address: in std_logic_vector(5 downto 0);
  write_request: in std_logic;
  read_allow: out std_logic
 );
end bram_module;

architecture Behavioral of bram_module is

    type bram_size is array (0 to 63) of std_logic_vector(15 downto 0);
    signal bram: bram_size; 
    signal data: std_logic_vector(15 downto 0);
    
  
begin

    process(clock) is 
    begin
        data_out <= data; 
        if(clock'event and clock = '1') then 
            read_allow <= write_request; --syncronize beween the read and the write
            if(write_request = '1') then 
                --write to the bram module
                bram(to_integer(unsigned(write_address))) <= data_in; 
            end if; 
            -- read from the bram module
            data <= bram(to_integer(unsigned(read_address))) ; 
        end if; 
    end process; 
    

end Behavioral;