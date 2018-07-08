library ieee;
use ieee.std_logic_1164.all;
 
package types_pkg is
 
  -- ws281x Types
	type ws281xDataType is Record
		addres: std_logic_vector(7 downto 0);
		data: std_logic_vector(23 downto 0);
		writeEnable: std_logic;
	end Record;

	
	type ws281xDataBus is array (15 downto 0) of ws281xDataType;

	
	--ws281x constants
	constant zeroHighTimeNs: integer := 500;
	constant zeroLowTimeNs: integer := 2000;
	constant oneHighTimeNs: integer := 1200;
	constant oneLowTimeNs: integer := 1300;
	constant resetTimeNs: integer := 50000;
 
	--state machine states
	type ws281xStates is (ws281x_initial, ws281x_zerobit_low, ws281x_zerobit_high, ws281x_onebit_low, ws281x_onebit_high , ws281x_reset);
	type w5500States is (W5500_init, W5500_acquire, W5500_reset);
   
end package types_pkg;