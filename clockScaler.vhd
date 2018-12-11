----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: NPG 
-- 
-- Create Date: 03-Sep-18 1:19:27 PM
-- Design Name: Binary Counter and boardtop example
-- Module Name: clockScaler
-- Project Name: counter_vio_debug
-- Target Devices: xc7a100tcsg324-1 on Digilent Nexys4
-- Tool versions: Vivado 2018.1
-- Description: Produces a slower clock by using the high bit output of a counter.
--
-- Dependencies: None
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

entity clockScaler is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clkdiv : out STD_LOGIC);
end clockScaler;

architecture Behavioral of clockScaler is

	constant scaleWidth : integer := 7;
	signal clockScaler : std_logic_vector(scaleWidth downto 0);

begin
	process ( clk, rst )
	begin

		if ( rst = '1' ) then

			clockScaler <= (others => '0');

		elsif ( rising_edge(clk) ) then

			clockScaler <= clockScaler + '1';

		end if;

	end process;

	clkdiv <= clockScaler(scaleWidth);


end Behavioral;
