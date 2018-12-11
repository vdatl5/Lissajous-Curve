--generated by V2 synthesiser
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ssegDriver is port (
	clk : in std_logic;
	rst : in std_logic;
	cathode_p : out std_logic_vector(7 downto 0);
	digit1_p : in std_logic_vector(4 downto 0);
	anode_p : out std_logic_vector(7 downto 0);
	digit2_p : in std_logic_vector(4 downto 0);
	digit3_p : in std_logic_vector(4 downto 0);
	digit4_p : in std_logic_vector(4 downto 0);
	digit5_p : in std_logic_vector(4 downto 0);
	digit6_p : in std_logic_vector(4 downto 0);
	digit7_p : in std_logic_vector(4 downto 0);
	digit8_p : in std_logic_vector(4 downto 0)
); end ssegDriver;

------------------------------------------------

architecture behavioural of ssegDriver is

	signal digit_reg : std_logic_vector(39 downto 0);
	signal anode_reg : std_logic_vector(7 downto 0);
	signal digitout_reg : std_logic_vector(4 downto 0);
	signal digit_sel : std_logic_vector(2 downto 0);
	signal next_sel : std_logic_vector(2 downto 0);
	
	begin
		
		--Clock and set state machine
		process (clk, rst) 
			begin
				if (rst = '1') then
					digit_reg <= "0000000000000000000000000000000000000000";
					digit_sel <= "000";
					next_sel <= "000";
					digitout_reg <= "00000";
					anode_reg <= "11111111";

				elsif (clk'event and clk = '1') then
					
					--latch digits into register on clock edge
					digit_reg(4 downto 0) <= digit1_p;
					digit_reg(9 downto 5) <= digit2_p;
					digit_reg(14 downto 10) <= digit3_p;
					digit_reg(19 downto 15) <= digit4_p;
					digit_reg(24 downto 20) <= digit5_p;
					digit_reg(29 downto 25) <= digit6_p;
					digit_reg(34 downto 30) <= digit7_p;
					digit_reg(39 downto 35) <= digit8_p;
					
					digit_sel <= next_sel;
			
					case digit_sel is
					
						when "000" =>
							anode_reg <= "11111110";	
							digitout_reg <= digit_reg(4 downto 0);
							next_sel <= "001";
							
						when "001" =>
							anode_reg <= "11111101";	
							digitout_reg <= digit_reg(9 downto 5);
							next_sel <= "010";
							
						when "010" =>
							anode_reg <= "11111011";	
							digitout_reg <= digit_reg(14 downto 10);
							next_sel <= "011";
							
						when "011" =>
							anode_reg <= "11110111";	
							digitout_reg <= digit_reg(19 downto 15);
							next_sel <= "100";
							
						when "100" =>
							anode_reg <= "11101111";	
							digitout_reg <= digit_reg(24 downto 20);
							next_sel <= "101";
							
						when "101" =>
							anode_reg <= "11011111";	
							digitout_reg <= digit_reg(29 downto 25);
							next_sel <= "110";
							
						when "110" =>
							anode_reg <= "10111111";	
							digitout_reg <= digit_reg(34 downto 30);
							next_sel <= "111";
							
						when "111" =>
							anode_reg <= "01111111";	
							digitout_reg <= digit_reg(39 downto 35);
							next_sel <= "000";
							
						when others =>
							anode_reg <= "11111111";	
							digitout_reg <= "0000";
							next_sel <= "000";

						
					end case;
				end if;
			end process;
				
			--Connect the Cathode values
			with digitout_reg select
			cathode_p <= "11000000"when "00000", 	-- 0 
							"11111001" when "00001",	-- 1
							"10100100" when "00010",		-- 2
							"10110000" when "00011",		-- 3
							"10011001" when "00100",		-- 4
							"10010010" when "00101",		-- 5
							"10000010" when "00110",		-- 6
							"11111000" when "00111",		-- 7
							"10000000" when "01000",		-- 8
							"10011000" when "01001",		-- 9
							"10001000" when "01010",		-- A
							"10000011" when "01011",		-- B
							"11000110" when "01100",		-- C
							"10100001" when "01101",		-- D
							"10000110" when "01110",		-- E
							"10001110" when "01111",		-- F
							"01000000"when "10000", 	-- -0 
							"01111001" when "10001",	-- -1
                            "00100100" when "10010",        -- -2
                            "00110000" when "10011",        -- -3
                            "00011001" when "10100",        -- -4
                            "00010010" when "10101",        -- -5
                            "00000010" when "10110",        -- -6
                            "01111000" when "10111",        -- -7
                            "00000000" when "11000",        -- -8
                            "00011000" when "11001",        -- -9
                            "00001000" when "11010",        -- -A
                            "00000011" when "11011",        -- -B
                            "01000110" when "11100",        -- -C
                            "00100001" when "11101",        -- -D
                            "00000110" when "11110",        -- -E
                            "00001110" when "11111",        -- -F
							"00000000" when others;
		 
		 --Connect the Anode values
		 anode_p <= anode_reg;

end behavioural;