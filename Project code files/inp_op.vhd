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
use IEEE.STD_LOGIC_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inp_op is
port(	--addr:out STD_LOGIC_VECTOR(22 downto 0):=(OTHERS=>'0');
		--data:inout STD_LOGIC_VECTOR(15 downto 0);
		--led:inout STD_LOGIC_VECTOR(3 downto 0):=(OTHERS=>'0');
		sw:in STD_LOGIC_VECTOR(3 downto 0):="0000";
		anode:out STD_LOGIC_VECTOR(3 downto 0);
		cathode:out STD_LOGIC_VECTOR(6 downto 0);
		reg0:in STD_LOGIC_VECTOR(15 downto 0);
		reg1:in STD_LOGIC_VECTOR(15 downto 0);
		reg2:in STD_LOGIC_VECTOR(15 downto 0);
		reg3:in STD_LOGIC_VECTOR(15 downto 0);
--		reg4:in STD_LOGIC_VECTOR(15 downto 0);
--		reg5:in STD_LOGIC_VECTOR(15 downto 0);
		progcount:in STD_LOGIC_VECTOR(15 downto 0);
		inst_out:in std_logic_vector(15 downto 0);
--		stackpoint:in STD_LOGIC_VECTOR(6 downto 0);
--		mem0:in STD_LOGIC_VECTOR(15 downto 0);
--		mem1:in STD_LOGIC_VECTOR(15 downto 0);
--		mem2:in STD_LOGIC_VECTOR(15 downto 0);
--		mem3:in STD_LOGIC_VECTOR(15 downto 0);
--		stack0:in STD_LOGIC_VECTOR(15 downto 0);
--		stack1:in STD_LOGIC_VECTOR(15 downto 0);
--		stack2:in STD_LOGIC_VECTOR(15 downto 0);
--		stack3:in STD_LOGIC_VECTOR(15 downto 0);
		clk:in std_logic
		);
end inp_op;

architecture Behavioral of inp_op is
--signal count:STD_LOGIC_VECTOR(2 downto 0):="000";
--signal read_clk:STD_LOGIC:='0';
	signal read_data:STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
	signal led_clk:STD_LOGIC:='0';
	signal led_count:STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
	signal switch:STD_LOGIC_VECTOR(1 downto 0):="00";
	signal digit:STD_LOGIC_VECTOR(3 downto 0);

--signal offset:STD_LOGIC_VECTOR(2 downto 0):="000";
--signal led_digit:STD_LOGIC_VECTOR(3 downto 0);


begin


genClk:process(clk)
begin
	if(rising_edge(clk)) then
		led_count<=led_count + 1;
		if(led_count="1111111111111111") then
			led_clk<=not led_clk;
			led_count<=(OTHERS=>'0');
		end if;
	end if;
end process;

read_start:process(led_clk)
begin
	if(rising_edge(led_clk)) then
			if(sw="0000") then
				read_data<=reg0;
			
			elsif(sw="0001") then
				read_data<=reg1;
			
			elsif(sw="0010") then
				read_data<=reg2;
	
			elsif(sw="0011") then
				read_data<=reg3;	
			
--			elsif(sw="0100") then
--						read_data<=reg4;
--			
--			elsif(sw="0101") then
--				read_data<=reg5;
			
			elsif(sw="0100") then
				read_data<=progcount;
			
		elsif(sw="0111") then
				read_data<=inst_out;
--			
--			elsif(sw="1000") then
--				read_data<=mem0;
--
--			elsif(sw="1001") then
--				read_data<=mem1;
--
--			elsif(sw="1010") then
--				read_data<=mem2;	
--			
--			elsif(sw="1011") then
--				read_data<=mem3;
--
--			elsif(sw="1100") then
--				read_data<=stack0;
--
--			elsif(sw="1101") then
--				read_data<=stack1;
--
--			elsif(sw="1110") then
--				read_data<=stack2;
--	
--	
--			elsif(sw="1111") then
--				read_data<=stack3;
	
	
	end if;
	end if;
end process;



process(led_clk)
begin
	if(rising_edge(led_clk)) then
		switch<=switch + 1;
		if(switch="00") then
			anode<="1110";
			digit<=read_data(3 downto 0);
		elsif(switch="01") then
			anode<="1101";
			digit<=read_data(7 downto 4);
		elsif(switch="10") then
			anode<="1011";
			digit<=read_data(11 downto 8);
		elsif(switch="11") then
			anode<="0111";
			digit<=read_data(15 downto 12);
			switch<="00";
		else
			anode<="1111";
			switch<="00";
		end if;  
	end if;
end process;
------------
with digit select
cathode  <="1000000" when "0000",
           "1111001" when "0001",
			  "0100100" when "0010",
			"0110000" when "0011",
			"0011001" when "0100",
			"0010010" when "0101",
			"0000010" when "0110",
			"1111000" when "0111",
			"0000000" when "1000",
			"0010000" when "1001",
			"0001000" when "1010",
			"0000011" when "1011",
			"1000110" when "1100",
			"0100001" when "1101",
			"0000110" when "1110",
			"0001110" when "1111",
			"1111111" when others;
		 
end Behavioral; 