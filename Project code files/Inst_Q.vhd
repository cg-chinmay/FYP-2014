----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:33:25 04/07/2014 
-- Design Name: 
-- Module Name:    Inst_Q - Behavioral 
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
 use IEEE.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Inst_Q is
    Port ( inst_wr:in STD_LOGIC; 
           Inst_In : in  STD_LOGIC_VECTOR (15 downto 0);
           Inst_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Inst_ptr : in  STD_LOGIC_VECTOR (15 downto 0);
			  clk:in std_logic;
			  --inst_rd:in std_logic;
			  wr_inst_ptr:in std_logic_vector(3 downto 0)
			);
end Inst_Q;

architecture Behavioral of Inst_Q is
type mem is array (15 downto 0) of std_logic_vector(15 downto 0);
shared variable inst_cache:mem;
--signal latch:std_logic_vector(15 downto 0);

begin

process(clk)
variable index : integer range 0 to 15;
begin
if(clk'event and clk='1') then
if(inst_wr='1') then
index:=conv_integer(wr_inst_ptr);
inst_cache(index):=Inst_in;
end if;
index:=conv_integer(Inst_ptr(3 downto 0));
Inst_Out<=inst_cache(index);
end if;
end process;

end Behavioral;