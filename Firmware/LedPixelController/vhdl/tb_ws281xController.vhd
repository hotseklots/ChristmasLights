library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.all;

use work.types_pkg.all;

entity tb_ws281xController is			 
end tb_ws281xController;

architecture testbench of tb_ws281xController is
constant clockPeriod: time:= 20 ns;
constant clockPeriodNs: natural:= 20;
constant pixels: natural:= 1000;

signal clk: std_logic:= '0';
signal rst_n: std_logic:= '0';

signal pixelsConnected: natural:= 2;
signal inputData: ws281xDataType;
signal outputData: std_logic;
signal start_check: std_logic:='0';
signal dataBuffer: std_logic_vector(239 downto 0);

begin

DUT: entity work.ws281xController(RTL) 
		generic map( 
			clockPeriodNs=> clockPeriodNs,
			maxPixels => pixels)					 
		port map( 		
			clk => clk,
			rst_n => rst_n,
			pixelsConnected => pixelsConnected,
			inputData => inputData,
			dout => outputData);


clk <= not clk after clockPeriod/2;
rst_n <= '1' after clockPeriod*10;		

sim:process
begin
	inputData.addres <= (others => '0');
	inputData.data <= (others => '0');
	inputData.writeEnable <= '0';
	dataBuffer <= (others=>'0');
	wait for clockPeriod*10;
	for I in 0 to (pixelsConnected-1) loop
		inputData.addres <= std_logic_vector(to_unsigned(I,inputData.addres'length));
		inputData.data <= std_logic_vector(to_unsigned(I,inputData.data'length));
		inputData.writeEnable <= '1';
		wait for clockPeriod;	
		
		inputData.writeEnable <= '0';
		wait for clockPeriod;		
	end loop;
	
	wait for (pixelsConnected*24*2500 ns);
	start_check <='1';
	
	for I in 0 to ((pixelsConnected*24)-1) loop
		wait until rising_edge(outputData);
		wait for (zeroHighTimeNs* 1 ns)+1 ns;
		dataBuffer<= databuffer(238 downto 0) & outputData;
	end loop;
	
	wait;
	
end process;
		

end testbench;

