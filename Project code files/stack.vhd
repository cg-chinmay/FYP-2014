----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:08 03/23/2014 
-- Design Name: 
-- Module Name:    data_stack - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.All;
 use IEEE.std_logic_arith.all;
 USE ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_stack is
port(   Clk : in std_logic;  --Clock for the stack.
        Ram_Stack : in std_logic;--enable to disable RAM
        MemRead : in std_logic;  --enable to read data from data memory,enable for load
		  MemWrite : in std_logic;-- enable to write data into data mem,enable for store 
        Data_In : in std_logic_vector(15 downto 0);  --Data to be pushed/write to mem
        Data_Out : out std_logic_vector(15 downto 0);  --Data to be popped/read from the mem.
        PUSH : in std_logic; 
		  POP : in std_logic;
        Stack_Full : out std_logic;  --Goes high when the stack is full.
        Stack_Empty : out std_logic;  --Goes high when the stack is empty.
		  stack_ptr :out std_logic_vector(6 downto 0);
		  addr:in STD_LOGIC_VECTOR(15 downto 0);
		  sel:in STD_LOGIC_VECTOR(3 downto 0);
--	  mr128:out std_logic_vector(15 downto 0);
--	  mr129:out std_logic_vector(15 downto 0);
--	  mr130:out std_logic_vector(15 downto 0);
--	  mr131:out std_logic_vector(15 downto 0);
		  st_data:in std_logic_vector(15 downto 0)
--		  stack_0:out std_logic_vector(15 downto 0);
--		  stack_3:out std_logic_vector(15 downto 0);
--		  stack_7:out std_logic_vector(15 downto 0)
        );
end data_stack;

architecture Behavioral of data_stack is

type mem_type is array (255 downto 0) of std_logic_vector(15 downto 0);
signal data_mem : mem_type;
signal full,empty : std_logic;
shared variable S : integer range 0 to 255:=127;
--shared variable R : integer range 0 to 255;
shared variable temp_addr:std_logic_vector(6 downto 0);

--shared variable curr_pos :std_logic_vector(6 downto 0);

begin

Stack_Full <= full; 
Stack_Empty <= empty;
--mr128<=data_mem(128);
--mr129<=data_mem(129);
--mr130<=data_mem(130);
--mr131<=data_mem(131);
--mr132<=data_mem(132);
--mr133<=data_mem(133);
--stack_0<=data_mem(120);
--stack_3<=data_mem(123);
--stack_7<=data_mem(127);
--PUSH and POP process for the stack.
PUSHnPOP : process(Clk,PUSH,POP,Ram_Stack)
begin
   if(rising_edge(Clk)) then
      --temp_addr:=addr(6 downto 0);
		if(Ram_Stack='1') then --diable RAM
		if(sel="1101" and MemWrite='1') then
		   S:=conv_integer(addr(6 downto 0));
		end if; 
		  
		  --PUSH section.
        if (PUSH = '1' and full = '0' and POP ='0') then
             --Data pushed to the current address.
            data_mem(S) <= Data_In; 
            if(S /= 0) then
                S := S - 1;
            end if; 
            --setting full and empty flags
            if(S=0) then
                full <= '1';
                empty <= '0';
            elsif(S=127) then
                full <= '0';
                empty <= '1';
            else
                full <= '0';
                empty <= '0';
            end if;
            
        --end if;
        --POP section.
        elsif (POP = '1' and empty = '0' and PUSH ='0') then
        --Data has to be taken from the next highest address(empty descending type stack).
            if(S /= 127 and S /=0) then  
				    S:=S + 1;
                Data_Out <= data_mem(S); 
            end if; 
            --setting full and empty flags
            if(S = 0) then
				    Data_Out<=data_mem(S);
                full <= '1';
                empty <= '0';
            elsif(S = 127) then
                full <= '0';
                empty <= '1';
            else
                full <= '0';
                empty <= '0';
            end if; 
        end if;
		  stack_ptr<=std_logic_vector(to_unsigned(S,7));
		   elsif( Ram_Stack='0') then ---Disable Stack and enable RAM
			    if(MemWrite='1') then
                data_mem(128 + conv_integer(addr(6 downto 0))) <= st_data;
             end if;
				 if(MemRead='1') then
             Data_Out <= data_mem(128 + conv_integer(addr(6 downto 0)));
				 end if;
          elsif(Ram_Stack='Z' ) then
			  Data_Out<=addr;
			 end if;		
        end if;
 end process;
    
end Behavioral;

