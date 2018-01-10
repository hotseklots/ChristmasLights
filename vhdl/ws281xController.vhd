library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.all;

use work.types_pkg.all;

entity ws281xController is

generic ( clockPeriodNs: integer := 20; --50Mhz
			 maxPixels: integer:= 1000 );
			 
port ( 
   --general settings
	clk: std_logic;
	rst_n: std_logic;

	-- settings
	pixelsConnected: in natural;
	
	--input signals
	inputData: in ws281xDataType;

	-- output signals
   dout: out std_logic
);

end ws281xController;

architecture RTL of ws281xController is
--RAM related
signal pixelData_i: std_logic_vector(23 downto 0);
signal writeAddress_i: std_logic_vector(7 downto 0);
signal readAddress_i: natural;
signal readAddress_conv_i: std_logic_vector(7 downto 0);
signal readData_i: std_logic_vector(23 downto 0);
signal wren_i: std_logic;

--output generator
signal state: ws281xStates;
signal counter: natural;
signal bitcounter: natural;
signal ledBufRegister: std_logic_vector(23 downto 0);
signal dout_i: std_logic;


begin

dataBuffer: work.dualPortedRam port map (
		clk,
	   pixelData_i,
		readAddress_conv_i,
		writeAddress_i,
		wren_i,
		readData_i			
);


writeAddress_i <= inputData.addres;
wren_i <= inputData.writeEnable;
pixelData_i <= inputData.data;
dout <= dout_i;
readAddress_conv_i <= std_logic_vector(to_unsigned(readAddress_i,8));
p_createOutput: process (clk, rst_n) 
begin
	if(rst_n = '0') then
		dout_i <= '0';
		counter <= 0;
		state <= ws281x_initial;
	
	elsif(rising_edge(clk)) then	
		case state is
		when ws281x_initial =>
			if(bitcounter < 24) then
				 bitcounter <= bitcounter +1;
				 ledBufRegister(22 downto 0) <= ledBufRegister(23 downto 1);
				 if(ledBufRegister(0) = '0') then
					state <= ws281x_zerobit_high;
				 else
					state <= ws281x_onebit_high;
				 end if;
			else
				bitcounter <= 0;
				ledBufRegister <= readData_i(23 downto 0);
				if( readAddress_i < pixelsConnected) then
					readAddress_i <= readAddress_i + 1;
					if(ledBufRegister(0) = '0') then
						state <= ws281x_zerobit_high;
					else
						state <= ws281x_onebit_high;
					end if;
				else
					state <= ws281x_reset;
					readAddress_i <= 0;
				end if;
			end if;
			
		

			counter <= 0;		
			dout_i <= '0';
		when ws281x_zerobit_high =>
			if(counter < zeroHighTimeNs/ clockPeriodNs) then
				counter <= counter +1;
				state <= ws281x_zerobit_high;
				dout_i <= '1';
			else
			  counter <= 0;
			  state <= ws281x_zerobit_low;
			  dout_i <= '0';
			end if;
		
		when ws281x_zerobit_low =>
			if(counter < zeroLowTimeNs / clockPeriodNs) then
				counter <= counter +1;
				state <= ws281x_zerobit_low;
				dout_i <= '0';
			else
			  counter <= 0;
			  state <= ws281x_initial;
			  dout_i <= '0';
			end if;
		
		when  ws281x_onebit_high =>
			if(counter < oneHighTimeNs/ clockPeriodNs) then
				counter <= counter +1;
				state <= ws281x_onebit_high;
				dout_i <= '1';
			else
			  counter <= 0;
			  state <= ws281x_onebit_low;
			  dout_i <= '0';
			end if;
		when  ws281x_onebit_low =>
			if(counter < oneLowTimeNs / clockPeriodNs) then
				counter <= counter +1;
				state <= ws281x_onebit_low;
				dout_i <= '0';
			else
			  counter <= 0;
			  state <= ws281x_initial;
			  dout_i <= '0';
			end if;
		when ws281x_reset =>
		   if(counter < resetTimeNs / clockPeriodNs) then
				counter <= counter +1;
				state <= ws281x_reset;
				dout_i <= '0';
			else
			  counter <= 0;
			  state <= ws281x_initial;
			  readAddress_i <= readAddress_i + 1;
			  ledBufRegister <= readData_i(23 downto 0);
			  dout_i <= '0';
			end if;
	   when others => state <= ws281x_initial;		
		end case;	
	end if;
end process;


end RTL;

