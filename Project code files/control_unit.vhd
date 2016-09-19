----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:31:14 04/05/2014 
-- Design Name: 
-- Module Name:    control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is

port(

	clk:in STD_LOGIC;   -- 50 Mhz
	--inputs from decoder
	mem_rd1: in STD_LOGIC; 
   mem_wr1: in STD_LOGIC;
	alu_in:in STD_LOGIC_VECTOR(3 downto 0); -- what operation alu has to do during execution cycle
	inp1:in STD_LOGIC_VECTOR(3 downto 0);    -- 4 bit input to register bank RM
	inp2:in STD_LOGIC_VECTOR(3 downto 0);    -- RN 
	inp3:in std_logic_vector(3 downto 0);
	wr_address:in STD_LOGIC_VECTOR(3 downto 0); -- write register no during write cycle
	write_enable:in STD_LOGIC;  --write signal to register bank
	mux_imm_sel:in STD_LOGIC;  -- 2nd operand for alu select signal(reg bank vs immediate data)
	pc_signed:in STD_LOGIC_VECTOR(1 downto 0); 
	stck_ram_input:in STD_LOGIC; -- activate stack/ram, make high for stack else low for ram
	push_sig:in STD_LOGIC; 
	pop_sig:in STD_LOGIC;
	barrelshift_input:in STD_LOGIC_VECTOR(3 downto 0); -- amount of shift sent to barrel shifter 
	barrel_in:in STD_LOGIC_VECTOR(1 downto 0); --to select what direction of rotate
	imm_input:in STD_LOGIC_VECTOR(15 downto 0);
	cpsr_en_in:in std_logic;
	--index_input:in STD_LOGIC_VECTOR(2 downto 0):="000"; -- for queue
	
	--outputs
	alu_select:out STD_LOGIC_VECTOR(3 downto 0); -- what operation alu has to do during execution cycle
	inp1_addr:out STD_LOGIC_VECTOR(3 downto 0);    -- 4 bit input to register bank RM
	inp2_addr:out STD_LOGIC_VECTOR(3 downto 0);    -- RN 
	inp3_addr:out std_logic_vector(3 downto 0);-- for data store address
	wr_addr:out STD_LOGIC_VECTOR(3 downto 0); -- write register no during write cycle
	add_fwd:out std_logic_vector(3 downto 0);--addr to be forwarded
	wr:out STD_LOGIC;  --write signal to register bank
	mux_imm:out STD_LOGIC;  -- 2nd operand for alu select signal(reg bank vs immediate data)
	pc_sign:out STD_LOGIC_VECTOR(1 downto 0); -- To distinguish between 8 and 11 bit offset
	stck_ram:out STD_LOGIC; -- activate stack/ram, make high for stack else low for ram
	push:out STD_LOGIC; 
	pop:out STD_LOGIC;
	barrel_shift:out STD_LOGIC_VECTOR(3 downto 0); -- amount of shift sent to barrel shifter 
	barr_sel:out STD_LOGIC_VECTOR(1 downto 0); --to select what direction of rotate
	imm_data:out STD_LOGIC_VECTOR(15 downto 0);-- immediate data being sent
	mem_rd: out STD_LOGIC; --Make high for LOAD
   mem_wr: out STD_LOGIC; --Make high for Store
   cpsr_en_out:out std_logic;
	clk_out:out std_logic
	--index:out STD_LOGIC_VECTOR(2 downto 0):="000"; -- for queue
	--sgn_ext:out STD_LOGIC:='0'; -- For sign extension during branching
	--sign_data:out STD_LOGIC_VECTOR(7 downto 0):=(OTHERS=>'Z'); -- 8 bit signed data during branching
	--sign_data11:out STD_LOGIC_VECTOR(10 downto 0):=(OTHERS=>'Z');-- 11 bit signed data during branching 
	--set:out STD_LOGIC:='0'; --for burst mode set up
	--burst_sgn:out STD_LOGIC:='0'; --for burst mode
	--ready: in STD_LOGIC:='0'; --for burst mode
	); 

end control;

architecture Behavioral of control is
--the buffers
	signal stack:std_logic;
	signal write_address:std_logic_vector(3 downto 0);
	signal write_enable_temp1:std_logic;
	signal write_address_temp1:std_logic_vector(3 downto 0);
	signal write_enable1:std_logic;
	signal mem_rd2:std_logic;
	signal mem_wr2:std_logic;
	signal alu_select_delay: STD_LOGIC_VECTOR(3 downto 0) ;
	signal inp1_addr_delay: STD_LOGIC_VECTOR(3 downto 0);
	signal inp2_addr_delay:	STD_LOGIC_VECTOR(3 downto 0);
	signal inp3_addr_delay:std_logic_vector(3 downto 0);
	signal barrel_sel_delay: STD_LOGIC_VECTOR(1 downto 0)  ;
	signal barrel_shift_delay: STD_LOGIC_VECTOR(3 downto 0);
	signal imm_data_delay: STD_LOGIC_VECTOR(15 downto 0) ;
	signal mux_imm_delay: STD_LOGIC;
	signal pc_sign_delay :STD_LOGIC_VECTOR(1 downto 0);
	signal write_address_temp1_delay: STD_LOGIC_VECTOR(3 downto 0); -- temperory begins here
	signal write_enable_temp1_delay: std_logic;
	signal stack_delay: std_logic;   -- write cycle temperory
	signal mem_rd2_delay: std_logic; 
	signal mem_wr2_delay :std_logic;
	signal cpsr_en_out_delay: std_logic;
	
	
	
begin

decode:process(clk)
begin
		if(clk'event and clk='1') then
		alu_select_delay<=alu_in;
		inp1_addr_delay<=inp1;
		inp2_addr_delay<=inp2;
		inp3_addr_delay<=inp3;
		barrel_sel_delay<=barrel_in;
		barrel_shift_delay<=barrelshift_input;
		imm_data_delay<=imm_input;
		mux_imm_delay<=mux_imm_sel;
		pc_sign_delay<=pc_signed;
		write_address_temp1_delay<=wr_address ; -- temperory begins here
		write_enable_temp1_delay<=write_enable;
		stack_delay <= stck_ram_input;   -- write cycle temperory
		mem_rd2_delay<=mem_rd1; 
		mem_wr2_delay<=mem_wr1;
		cpsr_en_out_delay<=cpsr_en_in;
		end if;
	end process;






execute:process(clk)
	begin
		if(clk'event and clk='1') then
		alu_select<=alu_select_delay;
		inp1_addr<=inp1_addr_delay;
		inp2_addr<=inp2_addr_delay;
		inp3_addr<=inp3_addr_delay;
		barr_sel<=barrel_sel_delay;
		barrel_shift<=barrel_shift_delay;
		imm_data<=imm_data_delay;
		mux_imm<=mux_imm_delay;
		pc_sign<=pc_sign_delay;
		write_address_temp1<=	write_address_temp1_delay; -- temperory begins here
		write_enable_temp1<=write_enable_temp1_delay;
		stack <= stack_delay ;   -- write cycle temperory
		mem_rd2<=	mem_rd2_delay; 
		mem_wr2<=	mem_wr2_delay;
		cpsr_en_out<=cpsr_en_out_delay;
		end if;
	end process;

memory:process(clk)
	begin
	if(clk'event and clk='1') then
		stck_ram<=stack;
		mem_rd <= mem_rd2	;
		mem_wr <= mem_wr2;
		write_address<=write_address_temp1 ; -- temperory begins here for write cycle
		add_fwd<=write_address_temp1;
		write_enable1<=write_enable_temp1;
		push<=push_sig; --changes made earlier signal was absent 
		pop<=pop_sig;  --changes made earlier signal was absent
		end if;
	end process;


write_cycle:process(clk)
	begin
	if(clk'event and clk='1') then
		wr_addr<=write_address;
		wr<= write_enable1;
	end if;
	end process;
clk_out<=clk;
end Behavioral;

