library IEEE;
use IEEE.std_logic_1164.all;

use work.types_pkg.all;

entity ledPixelController is

port ( 
   --general settings
	clk: std_logic;
	rst_n: std_logic;

	-- spi
	sclk : out std_logic;
	mosi : out std_logic;
	miso : in std_logic;
	
	--dummy signals
	pixelsConnected: in natural;
	
	-- output signals led
   dout: out std_logic_vector(31 downto 0)
);

end ledPixelController;


architecture RTL of ledPixelController is 
			 
signal ws281xData: ws281xDataBus;

begin



w5500_inst: work.w5500 port map (
	clk,
	rst_n,
	sclk,
	mosi,
	miso,
	ws281xData
);

controller: for I in 0 to 31 generate 
ws281x: work.ws281xController port map (
	clk,
	rst_n,
	pixelsConnected,
	ws281xData(I),
   dout(I)	
);

end generate controller;



end RTL;
