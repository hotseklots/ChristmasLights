
module nios (
	clk_clk,
	gpio_export,
	reset_reset_n,
	spi_eeprom_external_MISO,
	spi_eeprom_external_MOSI,
	spi_eeprom_external_SCLK,
	spi_eeprom_external_SS_n,
	spi_enet_external_MISO,
	spi_enet_external_MOSI,
	spi_enet_external_SCLK,
	spi_enet_external_SS_n);	

	input		clk_clk;
	output	[31:0]	gpio_export;
	input		reset_reset_n;
	input		spi_eeprom_external_MISO;
	output		spi_eeprom_external_MOSI;
	output		spi_eeprom_external_SCLK;
	output		spi_eeprom_external_SS_n;
	input		spi_enet_external_MISO;
	output		spi_enet_external_MOSI;
	output		spi_enet_external_SCLK;
	output		spi_enet_external_SS_n;
endmodule
