----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: MDS
-- 
-- Create Date:    25/07/2014 
-- Design Name: 
-- Module Name:    boardTop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity boardTop is
    Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
		   clk100mhz : in STD_LOGIC;
			logic_analyzer : out STD_LOGIC_VECTOR (3 downto 0);
			 JB: inout STD_LOGIC_VECTOR(7 downto 0);
			 JC: inout STD_LOGIC_VECTOR(7 downto 0);
             JD: inout STD_LOGIC_VECTOR(7 downto 0)
			);
			
end boardTop;

architecture Behavioral of boardTop is

component User_Interface is
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
end component;

component Keypad_top is
    Port (
        Rows: in std_logic_vector(3 downto 0);
        Columns: inout std_logic_vector(3 downto 0) := "0000";       
        clock: in std_logic; 
        A_0 : out std_logic_vector(3 downto 0) := x"1";
        A_1 : out std_logic_vector(3 downto 0) := x"0";
        B_0 : out std_logic_vector(3 downto 0) := x"1";
        B_1 : out std_logic_vector(3 downto 0) := x"0"  
    
     );
end component;

    component ssegDriver is port (
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
    ); end component;

    component clock_prescaller_1khz is
     Port (   
     clk_100Mhz : in  std_logic;
     rst       : in  std_logic;
     clk_div   : out std_logic );
    end component;
    
    
component datapath_curve is
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
    end component;
    
    component controller_curve is
      Port ( 
      calculationDone: in std_logic; 
      cordic_0_tready: in std_logic; 
      cordic_1_tready: in std_logic; 
      clock: in std_logic; 
      controlSignal: out std_logic_vector(1 downto 0)
      );
    end component;
    
    component clockScaler is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clkdiv : out STD_LOGIC);
    end component;
    
    component bram_module is
      Port (
      clock : in std_logic; 
      data_in: in std_logic_vector(15 downto 0);
      read_address: in std_logic_vector(5 downto 0);
      data_out: out std_logic_vector(15 downto 0);
      write_address: in std_logic_vector(5 downto 0);
      write_request: in std_logic;
      read_allow: out std_logic
     );
    end component;
    
    component R2R_Module is
      Port ( 
        clock: std_logic; 
        x_out: out std_logic_vector(7 downto 0);
        y_out: out std_logic_vector(7 downto 0);
        syncronization: in std_logic; 
        read_address: out std_logic_vector(5 downto 0);
        data_in: in std_logic_vector(15 downto 0)
      );
    end component;
    
signal clock, read_allow, twopi_done_B, twopi_done_A, cordic_out0_valid, cordic_out1_valid, calculationDone: std_logic; 
signal phase_B, phase_A, A_input, B_input, x_value, y_value: std_logic_vector(7 downto 0);
signal controlSignal: std_logic_vector(1 downto 0);
signal data_out_cordic, data_out_bram : std_logic_vector(15 downto 0);
signal writeAddress, readAddress: std_logic_vector(5 downto 0);

signal clk_1khz: std_logic := '0';
signal displayStatus: std_logic := '0'; 
signal keypad_A_1, keypad_A_2, keypad_B_1, keypad_B_2: std_logic_vector(3 downto 0);
signal v_offset, h_offset: std_logic_vector(6 downto 0);
signal v_sign, h_sign: std_logic; 
signal A_out, B_out: std_logic_vector(7 downto 0);

signal digit1, digit2, digit3, digit4, digit5, digit6, digit7, digit8: std_logic_vector(4 downto 0);
signal rows, columns: std_logic_vector(3 downto 0) := "0000";

   
begin

i1: User_Interface
  Port MAP (
    clock => clock,
    mode_switches => slideSwitches(1 downto 0),
    display_button => pushButtons(4),
    up_button => pushButtons(2),
    down_button => pushButtons(1),
    left_button => pushButtons(3),
    right_button => pushButtons(0),
    keypad_A_1 => keypad_A_1, 
    keypad_A_2 => keypad_A_2,
    keypad_B_1 => keypad_B_1, 
    keypad_B_2 => keypad_B_2,
    v_offset => v_offset, 
    v_sign => v_sign,
    h_offset => h_offset,
    h_sign => h_sign,
    displayStatus => displayStatus,
    A_out => A_out, 
    B_out => B_out,
    SSEG1 => digit1,
    SSEG2 => digit2,
    SSEG3 => digit3,
    SSEG4 => digit4,
    SSEG5 => digit5,
    SSEG6 => digit6,
    SSEG7 => digit7,
    SSEG8 => digit8
   );

  --u4: clock_prescaller_1khz port map (
  --   clk_100Mhz => clk100mhz,
  --   rst  => '0',
  --   clk_div => clock
  --);

 u3: ssegDriver port map (
         clk => clock, 
         rst => displayStatus,
         digit1_p =>  digit1, 
         digit2_p => digit2,
         digit3_p => digit3,
         digit4_p => digit4,
         digit5_p => digit5,
         digit6_p => digit6,
         digit7_p => digit7,
         digit8_p => digit8,
         cathode_p => ssegCathode,
         anode_p => ssegAnode
 );
 
 
 u5: Keypad_top Port Map (
         Rows(0) => JB(7),
         Rows(1) => JB(6),
         Rows(2) => JB(5),
         Rows(3) => JB(4),
         Columns(0) => JB(3),
         COlumns(1) => JB(2),
         Columns(2) => JB(1),
         Columns(3) => JB(0),
         clock =>  clock, 
         A_0 => keypad_A_1,
         A_1 => keypad_A_2,
         B_0 => keypad_B_1,
         B_1 => keypad_B_2  
      );
 
 
 LEDs(0) <= not displayStatus;
 
 cd: datapath_curve Port MAP (
     clock => clock,
     A_input => A_out, 
     B_input => B_out, 
     v_offset => v_offset, 
     v_sign => v_sign, 
     h_offset => h_offset, 
     h_sign => h_sign,
     calculationDone => calculationDone,
     cordic_out0_valid => cordic_out0_valid,
     cordic_out1_valid => cordic_out1_valid,
     controlSignal => controlSignal,
     data_out => data_out_cordic,
     writeAddress => writeAddress,
     phase_A => phase_A,
     twopi_done_B => twopi_done_B,
     twopi_done_A => twopi_done_A,
     phase_B => phase_B
    );
 
 cc: controller_curve Port MAP ( 
   calculationDone => calculationDone,
   cordic_0_tready => cordic_out0_valid,
   cordic_1_tready => cordic_out1_valid,
   clock => clock,
   controlSignal => controlSignal
   );
 
 u1: bram_module Port Map (
   clock => clock,
   data_in => data_out_cordic, 
   read_address => readAddress,
   data_out => data_out_bram,
   write_address => writeAddress, 
   write_request => calculationDone,
   read_allow => read_allow
  );
 
 d3: R2R_Module Port Map ( 
     clock => clock, 
     x_out => JC,
     y_out => JD,
     syncronization => read_allow, 
     read_address => readAddress,
     data_in => data_out_bram
   );
   
 d4: clockScaler port map (
       clk => clk100mhz,
       rst  => '0',
       clkdiv => clock
    );

end Behavioral;

