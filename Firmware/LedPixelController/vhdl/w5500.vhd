library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

use work.types_pkg.all;

entity w5500 is	 
port ( 
   --general settings
	clk: std_logic;
	rst_n: std_logic;

	-- spi
	sclk : out std_logic;
	mosi : out std_logic;
	miso : in std_logic;	
	
	--output signals
	outputData : out ws281xDataBus
);

end w5500;

architecture RTL of w5500 is
--spi
signal inputData: std_logic_vector(39 downto 0);

--output generator
signal state: w5500States;
signal counter: natural;
signal sclk_i: std_logic;

begin
sclk <=sclk_i;


p_sclk: process(clk, rst_n)
begin
	if(rst_n = '0') then
		sclk_i <= '0';	
	elsif(rising_edge(clk)) then	
		sclk_i <= not sclk_i;
	end if;
end process;

p_getData: process (sclk_i, rst_n) 
begin
--	if(rst_n = '0') then
--		counter <= 0;
--		state <= W5500_init;
--	
--	elsif(rising_edge(sclk_i)) then	
--		case state is
--		when W5500_init =>		
--			state <= W5500_acquire;
--			outputData(to_integer(unsigned(inputdata(39 downto 32)))).addres <= inputData(31 downto 24);
--			outputData(to_integer(unsigned(inputdata(39 downto 32)))).data <= inputData(23 downto 0);
--			outputData(to_integer(unsigned(inputdata(39 downto 32)))).writeEnable <= inputData(34);
--		when w5500_setMAC =>
--
--
--when w5500_setIP =>
--when w5500_setGateWay =>
--when w5500_setMask =>		
--		when W5500_acquire =>
--			if(counter<40) then
--				counter <= counter +1;
--				state <= W5500_acquire;
--			else
--				counter <=0;
--				state <= W5500_init;
--			end if;
--			inputData(0) <= miso;
--			inputData(39 downto 1) <= inputdata(38 downto 0);
--		
--		when W5500_reset => state <= W5500_init;		
--
--	   when others => state <= W5500_init;		
--		end case;	
--	end if;
end process;


end RTL;

