library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use  ieee. numeric_std. all  ;
use  ieee. numeric_std. all  ;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity regbank is
port ( 
clk, reset: in  std_logic; 
wr_en: in  std_logic; 
w_addr,  r_addr1, r_addr2  :  in  std_logic_vector  (3 downto 0) ;
w_data:  in  std_logic_vector  (15  downto  0) ; 
r_data1,r_data2:  out std_logic_vector  (15  downto  0) ; 
pcin:in std_logic_vector(15 downto 0);
stack_in:in std_logic_vector(6 downto 0);
link_in : in std_logic_vector(15 downto 0);
r0:out std_logic_vector(15 downto 0);
r1:out std_logic_vector(15 downto 0);
r2:out std_logic_vector(15 downto 0);
r3:out std_logic_vector(15 downto 0);
--r4:out std_logic_vector(15 downto 0);
--r5:out std_logic_vector(15 downto 0);
r_addr3:in std_logic_vector(3 downto 0);
r_data3:out std_logic_vector(15 downto 0)
--r6:out std_logic_vector(15 downto 0);
--r7:out std_logic_vector(15 downto 0);
--r8:out std_logic_vector(15 downto 0);
--r9:out std_logic_vector(15 downto 0);
--r10:out std_logic_vector(15 downto 0);
--r11:out std_logic_vector(15 downto 0);
--r12:out std_logic_vector(15 downto 0);
--r13:out std_logic_vector(15 downto 0);
--r14:out std_logic_vector(15 downto 0);
--r15:out std_logic_vector(15 downto 0)
);
end regbank;


architecture Behavioral of regbank is
type  reg_file_type is  array  (15  downto  0)  of
 std_logic_vector (15  downto  0);
signal  array_reg :  reg_file_type;
shared variable temp1,temp2 : integer range 0 to 15;
begin
		write_file:process (clk ,  reset) 
		variable temp:integer range 0 to 15;
		begin 
		temp:=to_integer(unsigned(w_addr));
			if  (reset = '1' ) then 
				array_reg(15 downto 0) <=  (others=>(others=>'0')) ; 
			elsif (clk'event and clk='1')  then 
				if  (wr_en= '1' and temp < 13) then 
				array_reg(temp)  <=  w_data;				
				end  if ; 
			end  if ; 
end  process; 
r0<=array_reg(0);
r1<=array_reg(1);
r2<=array_reg(2);
r3<=array_reg(3);
--r4<=array_reg(4);
--r5<=array_reg(5);
--r6<=array_reg(6);
--r7<=array_reg(7);
--r8<=array_reg(8);
--r9<=array_reg(9);
--r10<=array_reg(10);
--r11<=array_reg(11);
--r12<=array_reg(12);
--r13<=array_reg(13);
--r14<=array_reg(14);
--r15<=array_reg(15);
-- read  port 1

read_file:process(r_addr1,r_addr2,r_addr3)
begin
if(r_addr1/="UUUU" and r_addr1/="ZZZZ") then
temp1:=to_integer(unsigned(r_addr1));
if(temp1<13) then
r_data1 <=  array_reg(temp1);
elsif(temp1=15) then
r_data1<=pcin;
elsif(temp1=13) then
r_data1 <= "000000000" & stack_in;
elsif(temp1=14) then
r_data1 <=  link_in;
else
r_data1<=array_reg(temp1);
end if;
else
r_data1<=array_reg(temp1);
end if; 

-- read  port 2
if(r_addr2/="UUUU" and r_addr2/="ZZZZ") then
temp2:=to_integer(unsigned(r_addr2));
if(temp2<13) then
r_data2 <=  array_reg(temp2);
elsif(temp2=15) then
r_data2<=pcin;
elsif(temp2=13) then
r_data2 <= "000000000" & stack_in;
elsif(temp2=14) then
r_data2 <=  link_in;
else
r_data2<=array_reg(temp2);
end if;
else
r_data2<=array_reg(temp2);
end if; 

--read store addr
r_data3<=array_reg(to_integer(unsigned(r_addr3)));

end process;

end Behavioral;