----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:25:56 02/19/2014 
-- Design Name: 
-- Module Name:    extRam - Behavioral 
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
 USE ieee.numeric_std.ALL;
 use IEEE.STD_LOGIC_unsigned.All;
 --use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity extRam is
port(
	addr:out STD_LOGIC_VECTOR(22 downto 0):=(OTHERS=>'0'); -- ram 
	--data1:in STD_LOGIC_VECTOR(15 downto 0);  data of ram is connected to instruction cache directly
	--data2:out STD_LOGIC_VECTOR(15 downto 0);
	clk:in std_logic;
	CE_L:out STD_LOGIC; --signals to ram
	UB_L:out STD_LOGIC;
	LB_L:out STD_LOGIC;
	OE_L:out STD_LOGIC;
	WE_L:out STD_LOGIC;
	FlashCE_L:out STD_LOGIC;
	RAMCLK:out STD_LOGIC;
	RAMADV_L:out STD_LOGIC;
	RAMCRE:out STD_LOGIC;
	--led:inout STD_LOGIC_VECTOR(3 downto 0):=(OTHERS=>'0');
	--sw:in STD_LOGIC_VECTOR(3 downto 0):="0000";
	--anode:out STD_LOGIC_VECTOR(3 downto 0);
	--cathode:out STD_LOGIC_VECTOR(6 downto 0);
	ready:inout std_logic:='0'; --signal to decoder and inst cache mux for index
	wr_cache:out std_logic:='1';
	pointer:out std_logic_vector(3 downto 0):=(others=>'0')
	);
end extRam;

architecture Behavioral of extRam is

	--signal read_data:STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
	--signal led_clk:STD_LOGIC:='0';
	--signal led_count:STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
	--signal switch:STD_LOGIC_VECTOR(1 downto 0):="00";
	--signal digit:STD_LOGIC_VECTOR(3 downto 0);
	signal q:std_logic_vector(4 downto 0):="00000";
	signal	clk625: STD_LOGIC;
   signal ptr:std_logic_vector(4 downto 0):=(OTHERS=>'0');

begin
--init read
	FlashCE_L<='1'; -- disable flash
	CE_L<='0';
	UB_L<='0';
	LB_L<='0';
	CE_L<='0';
	RAMCLK<='0';
	RAMADV_L<='0';
	RAMCRE<='0';
	OE_L<='0';
	WE_L<='1';
	clk625<=q(3);
	

input:process(clk625)
	begin
	if(clk625'event and clk625='1') then
		if(ptr < 3) then
		
			--cache( conv_integer(pointer(3 downto 0))) <= data1;
			ptr <= std_logic_vector(unsigned(ptr)+1);
		elsif(ptr=3) then
		
			ready <= '1';
			wr_cache <= '0';
			--led(0)<='1';
		end if;

	end if;
end process;
pointer<=ptr(3 downto 0);

sysclk: process(clk)
begin
	if(clk'event and clk='1') then
		q<=q+1;
	end if;
end process;


addr<="000000000000000000"& ptr;
end Behavioral; 

