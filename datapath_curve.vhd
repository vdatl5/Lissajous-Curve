----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2018 08:03:12 PM
-- Design Name: 
-- Module Name: datapath_curve - Behavioral
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

entity datapath_curve is
  Port (
    clock: in std_logic; 
    A_input: in std_logic_vector(7 downto 0);
    B_input: in std_logic_vector(7 downto 0);
    v_offset: in std_logic_vector(6 downto 0);
    v_sign: in std_logic;
    h_offset: in std_logic_vector(6 downto 0);
    h_sign: in std_logic;
    calculationDone: out std_logic:='0'; 
    cordic_out0_valid: out std_logic; 
    cordic_out1_valid: out std_logic; 
    data_out: out std_logic_vector(15 downto 0) := x"0000";
    writeAddress: out std_logic_vector(5 downto 0);
    controlSignal: in std_logic_vector(1 downto 0);
    phase_B: out std_logic_vector(7 downto 0) := "10011011";
    twopi_done_A: out std_logic := '0';
    twopi_done_B: out std_logic := '0';
    phase_A: out std_logic_vector(7 downto 0):= "10011011"
   );
end datapath_curve;

architecture Behavioral of datapath_curve is

component cordic_0 IS
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END component;


signal phase_ready_0, phase_ready_1: std_logic; 
signal phase_data_0, phase_data_1: std_logic_vector(7 downto 0);
signal cordic_out_0, cordic_out_1: std_logic_vector(15 downto 0);
signal out_valid_0, out_valid_1: std_logic;
signal x_value : std_logic_vector(7 downto 0) := x"00";
signal y_value : std_logic_vector(7 downto 0) := x"00";

begin

--inilialize the two cordic modules


--A module 
c0: cordic_0 PORT MAP (
    aclk => clock,
    s_axis_phase_tvalid  => phase_ready_0,
    s_axis_phase_tdata  => phase_data_0,
    m_axis_dout_tvalid => out_valid_0,
    m_axis_dout_tdata => cordic_out_0
  );

--B module
c1: cordic_0 PORT MAP (
    aclk => clock,
    s_axis_phase_tvalid  => phase_ready_1,
    s_axis_phase_tdata  => phase_data_1,
    m_axis_dout_tvalid => out_valid_1,
    m_axis_dout_tdata => cordic_out_1
  );


process(clock)
        variable Aphase: std_logic_vector(7 downto 0) := "10011011"; --start at negative pi
        variable Bphase: std_logic_vector(7 downto 0) := "10011011"; --start at negative pi
        variable write_address: std_logic_vector(5 downto 0) := "000000";
        variable A_last, B_last : std_logic_vector(7 downto 0);
        
    begin
        if(clock'event and clock = '1') then 
            --send the signal to the controller
            cordic_out0_valid <= out_valid_0;
            cordic_out1_valid <= out_valid_1;
            
            if(controlSignal = "00") then
                --set the input to ready
                phase_ready_0 <= '1';
                phase_ready_1 <= '1';
                
                if(A_input /= A_last or B_input /= B_last) then
                    -- reset the angles to the starting value
                    Aphase := "10011011";
                    Bphase := "10011011";
                end if; 
                A_last := A_input; 
                B_last := B_input; 
                --calculate the phase values
                Aphase := (Aphase) + (A_input);
                if( Aphase(6 downto 0) > "1100100" and Aphase(7) = '0') then 
                   twopi_done_A <= '1';
                  Aphase := "10011011" - ("01100100" - Aphase); --transition to negative pi
                else
                    twopi_done_A <= '0';
                end if;
                
                Bphase := Bphase + B_input; 
                if( Bphase(6 downto 0) > "1100100" and Bphase(7) = '0') then 
                  twopi_done_B <= '1';
                  Bphase := "10011011" - ("01100100" - Bphase); --transition to negative pi
                else 
                  twopi_done_B <= '0';  
                end if; 
                
                --set the phase values           
                phase_data_0 <= Aphase;
                phase_data_1 <= Bphase;
                
                --for debugging
                phase_A <= Aphase; 
                phase_B <= Bphase;
                calculationDone <= '0';
                
            elsif(controlSignal = "01") then 
                --waiting for the cordic modules output to be ready
                phase_ready_0 <= '1';
                phase_ready_1 <= '1';
                
            elsif(controlSignal = "10") then 
                --codic output is valid 
                
                --input is no longer valid
                phase_ready_0 <= '0';
                phase_ready_1 <= '0';
                
                --get the values corresponding to the x and y values and flip the first bits
                --x_value(7) <= not(cordic_out_0(7));
                
                if(h_sign = '0') then 
                    x_value(7 downto 0) <= (not(cordic_out_0(7)) & cordic_out_0(6 downto 0)) + ('0' & h_offset);
                else
                    x_value(7 downto 0) <= (not(cordic_out_0(7)) & cordic_out_0(6 downto 0)) - ('0' & h_offset);
                end if; 
                
                 if(v_sign = '0') then 
                    y_value(7 downto 0) <= (not(cordic_out_1(15)) & cordic_out_1(14 downto 8)) + ('0' & v_offset);
                else
                    y_value(7 downto 0) <= (not(cordic_out_1(15)) & cordic_out_1(14 downto 8)) - ('0' & v_offset);
                end if; 
                               
                -- only programmed for h shift
                --y_value(7) <= not cordic_out_1(15);
                --y_value(6 downto 0) <= cordic_out_1(14 downto 8);
                
                
                
                write_address := write_address + "000001";
                writeAddress <= write_address; 
                data_out <= x_value & y_value; 
                --combined value
                --output calculations are done
                calculationDone <= '1'; 
            
            end if; 
        end if; 
   end process; 
end Behavioral;
