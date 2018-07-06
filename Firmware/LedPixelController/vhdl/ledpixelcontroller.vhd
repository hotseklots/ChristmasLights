library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.types_pkg.all;

entity ledPixelController is

port ( 
   --general settings
	clk: std_logic;
	rst_n: std_logic;

	-- spi ENET
	sclk_ENET : out std_logic;
	mosi_ENET : out std_logic;
	miso_ENET : in std_logic;
	SS_n_ENET : out std_logic;
	
	-- spi EEPROM
	sclk_EEPROM : out std_logic;
	mosi_EEPROM : out std_logic;
	miso_EEPROM : in std_logic;
   SS_n_EEPROM : out std_logic;
	
	--dummy signals
	pixelsConnected: in natural;
	
	-- output signals led
   dout: out std_logic_vector(15 downto 0)
);

end ledPixelController;




architecture RTL of ledPixelController is 
		
component nios is
	port (
		clk_clk                  : in  std_logic                     := 'X'; -- clk
		reset_reset_n            : in  std_logic                     := 'X'; -- reset_n
		gpio_export              : out std_logic_vector(31 downto 0);        -- export
		spi_enet_external_MISO   : in  std_logic                     := 'X'; -- MISO
		spi_enet_external_MOSI   : out std_logic;                            -- MOSI
		spi_enet_external_SCLK   : out std_logic;                            -- SCLK
		spi_enet_external_SS_n   : out std_logic;                            -- SS_n
		spi_eeprom_external_MISO : in  std_logic                     := 'X'; -- MISO
		spi_eeprom_external_MOSI : out std_logic;                            -- MOSI
		spi_eeprom_external_SCLK : out std_logic;                            -- SCLK
		spi_eeprom_external_SS_n : out std_logic                             -- SS_n
	);
end component nios;
		
component pll
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
end component;		
		
signal ws281xData: ws281xDataBus;
signal gpio : std_logic_vector(31 downto 0);
signal locked: std_logic;
signal locked_n: std_logic;
signal clk_200MHz: std_logic;
begin

locked_n <= not locked;


pll_inst : pll PORT MAP (
		areset	 => rst_n,
		inclk0	 => clk,
		c0	 => clk_200MHz,
		locked	 => locked
	);


u0 : component nios
	port map (
		clk_clk       => clk_200MHz,       			-- clk.clk
		reset_reset_n => locked_n, 					-- reset.reset_n
		gpio_export   => gpio,    						-- gpio.export
		spi_enet_external_MISO   => miso_ENET,   	-- spi_enet_external.MISO
		spi_enet_external_MOSI   => mosi_ENET,   	--                  .MOSI
		spi_enet_external_SCLK   => sclk_ENET,   	--                  .SCLK
		spi_enet_external_SS_n   => SS_n_ENET,		--                  .SS_n
		spi_eeprom_external_MISO => miso_EEPROM,	-- spi_eeprom_external.MISO
		spi_eeprom_external_MOSI => mosi_EEPROM, 	--                    .MOSI
		spi_eeprom_external_SCLK => sclk_EEPROM, 	--                    .SCLK
		spi_eeprom_external_SS_n => SS_n_EEPROM	--                    .SS_n
	);


controller: for I in 0 to 15 generate 

ws281xData(I).addres <= gpio(31 downto 24);
ws281xData(I).data <= gpio(23 downto 0);

ws281x: entity work.ws281xController port map (
	clk,
	rst_n,
	pixelsConnected,
	ws281xData(I),
   dout(I)	
);

end generate controller;



end RTL;
