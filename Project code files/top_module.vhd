----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:59 04/01/2014 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
    Port ( t_clk : in  STD_LOGIC;
        t_inst_in:in std_logic_vector(15 downto 0);
			  t_wr:out std_logic;
    		  t_flag:out std_logic_vector(3 downto 0);
			  result:out std_logic_vector(15 downto 0);
			  t_pc_out:out std_logic_vector(15 downto 0);
--			  t_stack_ptr:out std_logic_vector(6 downto 0);
--    		t_inst_ptr:out std_logic_vector(3 downto 0);
			  --t_inst_rd:out std_logic;
			  t_reg1_addr:out std_logic_vector(3 downto 0);
			  t_reg2_addr:out std_logic_vector(3 downto 0);
			  t_inst_out:out std_logic_vector(15 downto 0);
			  t_alu_sel:out std_logic_vector(3 downto 0);
			  t_imm:out std_logic;
--			  t_wdata:out std_logic_vector(15 downto 0); --uncomment for testbench
			  t_waddr:out std_logic_vector(3 downto 0);
--			  t_rm:out std_logic_vector(15 downto 0); --uncomment for testbench
--			  t_rn:out std_logic_vector(15 downto 0);
			  t_reg_reset:in std_logic;
			  t_wr_reg:out std_logic;
			  t_r0:out std_logic_vector(15 downto 0);
			  t_r1:out std_logic_vector(15 downto 0);
			  t_r2:out std_logic_vector(15 downto 0);
			  t_r3:out std_logic_vector(15 downto 0);
--			  t_r4:out std_logic_vector(15 downto 0);
--			  t_r5:out std_logic_vector(15 downto 0);
--			  top_st_0:out std_logic_vector(15 downto 0);
--			  top_st_3:out std_logic_vector(15 downto 0);
--			  top_st_7:out std_logic_vector(15 downto 0);
			  t_ready:out std_logic;
			  t_pc_en:out std_logic;
			  --ram controller
			  t_addr:out STD_LOGIC_VECTOR(22 downto 0):=(OTHERS=>'0'); -- ram 
	        t_CE_L:out STD_LOGIC; --signals to ram
	        t_UB_L:out STD_LOGIC;
	        t_LB_L:out STD_LOGIC;
	        t_OE_L:out STD_LOGIC;
	        t_WE_L:out STD_LOGIC;
	        t_FlashCE_L:out STD_LOGIC;
	        t_RAMCLK:out STD_LOGIC;
	        t_RAMADV_L:out STD_LOGIC;
	        t_RAMCRE:out STD_LOGIC;
			  ---input output
			  t_sw:in STD_LOGIC_VECTOR(3 downto 0):="0000";
			  t_anode:out STD_LOGIC_VECTOR(3 downto 0);
			  t_cathode:out STD_LOGIC_VECTOR(6 downto 0)
--			  t_mr128:out std_logic_vector(15 downto 0);
--			  t_mr129:out std_logic_vector(15 downto 0);
--			  t_mr130:out std_logic_vector(15 downto 0);
--			  t_mr131:out std_logic_vector(15 downto 0)

);
end top_module;


architecture Behavioral of top_module is
--regFile
Component regbank
port(
clk,reset: in  std_logic; 
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

);
end component; 


--cpsr
component cpsr
port(
clk:in std_logic;
n:in std_logic;
z:in std_logic;
c:in std_logic;
v:in std_logic;
cpsr_en:in std_logic;
cpsr_out:out std_logic_vector(15 downto 0):=(OTHERS=>'0')
);
end component;

--prog counter
component pc
port(
en:in STD_LOGIC;
pcout:out STD_LOGIC_VECTOR(15 downto 0);
clk:in STD_LOGIC;
pcin:in std_logic_vector(15 downto 0);
wr_en:in std_logic;
sel:in std_logic_vector(3 downto 0)
);
end component;

--alu
component alu
port
(
rn:in std_logic_vector(15 downto 0);
rd:out std_logic_vector(15 downto 0);
psr:out std_logic_vector(3 downto 0);-- four flag bits (NZCV)
alu_sel:in std_logic_vector(3 downto 0);
alu_cy:in std_logic;
rm_reg:in std_logic_vector(15 downto 0);
rm_mem:in std_logic_vector(15 downto 0);
rm_wb:in std_logic_vector(15 downto 0);
write_address:  in std_logic_vector(3 downto 0);  -- connect wr_addr of control
mem_address:  in std_logic_vector(3 downto 0);   -- connect to wr_addr_mem.. of control
input1: in std_logic_vector(3 downto 0)
);
end component;

--decoder
component decoder
port(
	carry:in std_logic;
	zero: in std_logic;
	negative: in std_logic;
	overflow:in std_logic;
	inst_in:in STD_LOGIC_VECTOR(15 downto 0); -- instruction from queue
	clk:in STD_LOGIC;   -- 50 Mhz
	alu_select:out STD_LOGIC_VECTOR(3 downto 0):="ZZZZ"; -- what operation alu has to do during execution cycle
	inp1_addr:out STD_LOGIC_VECTOR(3 downto 0):="ZZZZ";    -- 4 bit input to register bank RM
	inp2_addr:out STD_LOGIC_VECTOR(3 downto 0):="ZZZZ";    -- RN 
	inp3_addr:out std_logic_vector(3 downto 0);
	wr_addr:out STD_LOGIC_VECTOR(3 downto 0):="ZZZZ"; -- write register no during write cycle
	wr:out STD_LOGIC:='0';  --write signal to register bank
	mux_imm:out STD_LOGIC:='0';  -- 2nd operand for alu select signal(reg bank vs immediate data)
	pc_sign:out STD_LOGIC_VECTOR(1 downto 0):="00"; -- To distinguish between 3,5,8 and 11 bit offset
	stck_ram:out STD_LOGIC:='0'; -- activate stack/ram, make high for stack else low for ram
	push:out STD_LOGIC:='0'; 
	pop:out STD_LOGIC:='0';
	barrel_shift:out STD_LOGIC_VECTOR(3 downto 0):="ZZZZ"; -- amount of shift sent to barrel shifter 
	barr_sel:out STD_LOGIC_VECTOR(1 downto 0):="ZZ"; --to select what direction of rotate
	imm_data:out STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');-- immediate data being sent
	mem_rd: out STD_LOGIC:='0'; --Make high for LOAD
   mem_wr: out STD_LOGIC:='0' ;--Make high for Store
	cpsr_en:out std_logic;
	clk_out:out std_logic:='0';
	pc_en:out std_logic;
	ready:in std_logic
	--inst_enable:out std_logic:='0'
	); 
end component;

--Control Unit
component control
port(
   --inputs
	clk:in STD_LOGIC;   -- 50 Mhz
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
	--outputs
	alu_select:out STD_LOGIC_VECTOR(3 downto 0); -- what operation alu has to do during execution cycle
	inp1_addr:out STD_LOGIC_VECTOR(3 downto 0);    -- 4 bit input to register bank RM
	inp2_addr:out STD_LOGIC_VECTOR(3 downto 0);    -- RN
   inp3_addr:out std_logic_vector(3 downto 0);	
	wr_addr:out STD_LOGIC_VECTOR(3 downto 0); -- write register no during write cycle
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
	cpsr_en_in:in std_logic;
   cpsr_en_out:out std_logic;
	add_fwd:out std_logic_vector(3 downto 0);--addr to be forwarded
	clk_out:out std_logic
	); 
end component;
--

--data memory
component data_stack
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
--		  mr128:out std_logic_vector(15 downto 0);
--		  mr129:out std_logic_vector(15 downto 0);
--		  mr130:out std_logic_vector(15 downto 0);
--		  mr131:out std_logic_vector(15 downto 0);
--        stack_0:out std_logic_vector(15 downto 0);
--		  stack_3:out std_logic_vector(15 downto 0);
--		  stack_7:out std_logic_vector(15 downto 0);
	  st_data:in std_logic_vector(15 downto 0)
        );
end component;

--Instruction cache
component Inst_Q 
    Port ( inst_wr:in STD_LOGIC; 
           Inst_In : in  STD_LOGIC_VECTOR (15 downto 0);
           Inst_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Inst_ptr : in  STD_LOGIC_VECTOR (15 downto 0);
			  clk:in std_logic;
			  wr_inst_ptr:in std_logic_vector(3 downto 0)
			  --inst_rd:in std_logic
			);
end component;

--Component barrel shift
Component barrelshifter 
port
( 	
	inp_addr_register2:in std_logic_vector(3 downto 0):=(others=>'0');--  connect this to control and timings inp2_addr
	data_writeback_cycle:in std_logic_vector(15 downto 0):=(others=>'0'); -- connect this to memory access's data o/p
	data_memory_cycle:in std_logic_vector(15 downto 0):=(others=>'0');  -- connect this to alu's o/p
	address_writeback: in std_logic_vector(3 downto 0):=(others=>'0');  -- conenct this to wr_addr of control and timing
	address_memaccess: in std_logic_vector(3 downto 0):=(others=>'0'); -- connect this to control and timing's wr_addr_forward_mem
	datain: in std_logic_vector(31 downto 0):=(others=>'0');
	direction: in std_logic;
	rotation : in std_logic;
	count: in std_logic_vector(3 downto 0);
	dataout: out std_logic_vector(15 downto 0);
	mux_imm:in std_logic);
end component;

--Component sign extnsion
Component sign_ext 
port(
datain:in std_logic_vector(15 downto 0);
imm:in std_logic_vector(1 downto 0); --00 for 3bit,01 for 5 bit,10 for 8 bit,11 for 11 bit
dataout:out std_logic_vector(15 downto 0)
);
end component;
--Component extRam
Component extRam
port
(
addr:out STD_LOGIC_VECTOR(22 downto 0):=(OTHERS=>'0'); -- ram 
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
ready:inout std_logic:='0'; --signal to decoder 
wr_cache:out std_logic:='1';
pointer:out std_logic_vector(3 downto 0):=(others=>'0')
);
end component;
--inp_ouput
component inp_op
port
(
clk:in std_logic;
sw:in STD_LOGIC_VECTOR(3 downto 0):="0000";
anode:out STD_LOGIC_VECTOR(3 downto 0);
cathode:out STD_LOGIC_VECTOR(6 downto 0);
reg0:in STD_LOGIC_VECTOR(15 downto 0);
reg1:in STD_LOGIC_VECTOR(15 downto 0);
reg2:in STD_LOGIC_VECTOR(15 downto 0);
reg3:in STD_LOGIC_VECTOR(15 downto 0);
inst_out:in std_logic_vector(15 downto 0);
--reg4:in STD_LOGIC_VECTOR(15 downto 0);
--reg5:in STD_LOGIC_VECTOR(15 downto 0);
progcount:in STD_LOGIC_VECTOR(15 downto 0)
--stackpoint:in STD_LOGIC_VECTOR(6 downto 0);
--mem0:in STD_LOGIC_VECTOR(15 downto 0);
--mem1:in STD_LOGIC_VECTOR(15 downto 0);
--mem2:in STD_LOGIC_VECTOR(15 downto 0);
--mem3:in STD_LOGIC_VECTOR(15 downto 0);
--stack0:in STD_LOGIC_VECTOR(15 downto 0);
--stack1:in STD_LOGIC_VECTOR(15 downto 0);
--stack2:in STD_LOGIC_VECTOR(15 downto 0);
--stack3:in STD_LOGIC_VECTOR(15 downto 0)

);
end component;
---Decoder output signals
signal dcarry:std_logic;
signal dzero: std_logic;
signal dnegative: std_logic;
signal doverflow:std_logic;
signal	dalu_select: STD_LOGIC_VECTOR(3 downto 0); -- what operation alu has to do during execution cycle
signal	dinp1_addr: STD_LOGIC_VECTOR(3 downto 0);    -- 4 bit input to register bank RM
signal	dinp2_addr: STD_LOGIC_VECTOR(3 downto 0);    -- RN 
signal   dinp3_addr:std_logic_vector(3 downto 0); -- for data store addr
signal	dwr_addr: STD_LOGIC_VECTOR(3 downto 0); -- write register no during write cycle
signal	dwr: STD_LOGIC;  --write signal to register bank
signal	dmux_imm: STD_LOGIC;  -- 2nd operand for alu select signal(reg bank vs immediate data)
signal	dpc_sign: STD_LOGIC_VECTOR(1 downto 0); -- To distinguish between 3,5,8 and 11 bit offset
signal	dstck_ram: STD_LOGIC; -- activate stack/ram, make high for stack else low for ram
signal	dpush: STD_LOGIC; 
signal	dpop: STD_LOGIC;
signal	dbarrel_shift: STD_LOGIC_VECTOR(3 downto 0); -- amount of shift sent to barrel shifter 
signal	dbarr_sel: STD_LOGIC_VECTOR(1 downto 0); --to select what direction of rotate
signal	dimm_data: STD_LOGIC_VECTOR(15 downto 0);-- immediate data being sent
signal   dpc_en:std_logic;
signal	dmem_rd:  STD_LOGIC; --Make high for LOAD
signal  dmem_wr:  STD_LOGIC;--Make high for Store
signal	dcpsr_en: std_logic;
signal	dclk_out:std_logic;
signal   dinst_en:std_logic;
--Control Unit Output signals
--top module
signal   top_wr:std_logic;
signal   top_inst_ptr:std_logic_vector(3 downto 0);
signal top_ready:std_logic;

signal calu_sel: STD_LOGIC_VECTOR(3 downto 0); -- what operation alu has to do during execution cycle
signal cinp1_addr: STD_LOGIC_VECTOR(3 downto 0);    -- 4 bit input to register bank RM
signal cinp2_addr: STD_LOGIC_VECTOR(3 downto 0);    -- RN 
signal cinp3_addr:std_logic_vector(3 downto 0);
signal cwr_addr: STD_LOGIC_VECTOR(3 downto 0); -- write register no during write cycle
signal cwr: STD_LOGIC;  --write signal to register bank
signal cmux_imm: STD_LOGIC;  -- 2nd operand for alu select signal(reg bank vs immediate data)
signal cpc_sign: STD_LOGIC_VECTOR(1 downto 0); -- To distinguish between 3,5,8 and 11 bit offset
signal cstck_ram: STD_LOGIC; -- activate stack/ram, make high for stack else low for ram
signal cpush: STD_LOGIC; 
signal cpop: STD_LOGIC;
signal cbarrel_shift: STD_LOGIC_VECTOR(3 downto 0); -- amount of shift sent to barrel shifter 
signal cbarr_sel: STD_LOGIC_VECTOR(1 downto 0); --to select what direction of rotate
signal cimm_data: STD_LOGIC_VECTOR(15 downto 0);-- immediate data being sent
signal cmem_rd:  STD_LOGIC; --Make high for LOAD
signal cmem_wr:  STD_LOGIC;--Make high for Store
signal ccpsr_en_out: std_logic;
signal cclk_out:std_logic;
signal cadd_fwd:std_logic_vector(3 downto 0);
-----
--ALU output signals
signal apsr:std_logic_vector(3 downto 0);
signal ard:std_logic_vector(15 downto 0);
--
--ALU input signals
signal ainput2:std_logic_vector(15 downto 0);


--DataMemory output signals --Ram/Stack
signal memstack_in:std_logic_vector(6 downto 0);
signal memw_data:std_logic_vector(15 downto 0);
signal memStack_Full:std_logic;
signal memStack_Empty:std_logic;
--signal m_mr128:std_logic_vector(15 downto 0);
--signal m_mr129:std_logic_vector(15 downto 0);
--signal m_mr130:std_logic_vector(15 downto 0);
--signal m_mr131:std_logic_vector(15 downto 0);		 

--signal t_stack_0:std_logic_vector(15 downto 0);
--signal t_stack_3:std_logic_vector(15 downto 0);
--signal t_stack_7:std_logic_vector(15 downto 0);
--
signal top_r0:std_logic_vector(15 downto 0);
signal top_r1:std_logic_vector(15 downto 0);
signal top_r2:std_logic_vector(15 downto 0);
signal top_r3:std_logic_vector(15 downto 0);
--signal top_r4:std_logic_vector(15 downto 0);
--signal top_r5:std_logic_vector(15 downto 0);

--RegFile output
signal reg_r_data1: std_logic_vector  (15  downto  0) ; 
signal reg_r_data2: std_logic_vector  (15  downto  0) ;
signal reg_r_data3: std_logic_vector (15 downto 0);

--Inst_Q inputs
signal q_inst_ptr:std_logic_vector(15 downto 0);
--signal q_inst_rd:std_logic;

--Inst_Q output
signal q_inst_Out : STD_LOGIC_VECTOR (15 downto 0);

--Sign extension Output
signal sgn_data_out : STD_LOGIC_VECTOR (15 downto 0);

signal zero:std_logic_vector(11 downto 0);--to make cpsr unconnected pins 0
--alumux signals
signal alumux_data:std_logic_vector(15 downto 0);
--stack temp signal
--signal temp_st:std_logic_vector(15 downto 0):=(OTHERS=>'0');

begin

decode_unit:decoder port map
(  
   carry=>dcarry,
	zero=>dzero,
	negative=>dnegative,
	overflow=>doverflow,
	inst_in=>q_inst_out,
	alu_select=>dalu_select,
	inp1_addr=>dinp1_addr,
	inp2_addr=>dinp2_addr,
	inp3_addr=>dinp3_addr,
	clk=>t_clk,
	wr_addr=>dwr_addr,
	wr=>dwr,
	mux_imm=>dmux_imm,
	pc_sign=>dpc_sign,
	stck_ram=>dstck_ram,
	push=>dpush,
	pop=>dpop,
	barrel_shift=>dbarrel_shift,
	barr_sel=>dbarr_sel,
	imm_data=>dimm_data,
	mem_rd=>dmem_rd,
   mem_wr=>dmem_wr,
	cpsr_en=>dcpsr_en,
	clk_out=>dclk_out,
	pc_en=>dpc_en,
	ready=>top_ready
	--inst_enable=>dinst_en
);
--
ct:control port map
(
--inputs from decoder
	clk=>dclk_out,
	mem_rd1=>dmem_rd,
   mem_wr1=>dmem_wr,
	alu_in=>dalu_select,
	inp1=>dinp1_addr,
	inp2=>dinp2_addr,
	inp3=>dinp3_addr,
	wr_address=>dwr_addr,
	write_enable=>dwr,
	mux_imm_sel=>dmux_imm,
	pc_signed=>dpc_sign,
	stck_ram_input=>dstck_ram,
	push_sig=>dpush,
	pop_sig=>dpop,
	barrelshift_input=>dbarrel_shift,
	barrel_in=>dbarr_sel,
	imm_input=>dimm_data,
	cpsr_en_in=>dcpsr_en,
	---
	--Outputs
	alu_select=>calu_sel,
	inp1_addr=>cinp1_addr,
	inp2_addr=>cinp2_addr,
	inp3_addr=>cinp3_addr,
	wr_addr=>cwr_addr,
	wr=>cwr,
	mux_imm=>cmux_imm,
	pc_sign=>cpc_sign,
	stck_ram=>cstck_ram,
	push=> cpush,
	pop=> cpop,
	barrel_shift=>cbarrel_shift,
	barr_sel=>cbarr_sel,
	imm_data=>cimm_data,
	mem_rd=>cmem_rd,
   mem_wr=>cmem_wr,
   cpsr_en_out=>ccpsr_en_out,
	clk_out=>cclk_out,
	add_fwd=>cadd_fwd
	---
);

cpsr_unit:cpsr port map
(
clk=>cclk_out,
c=>apsr(1),
z=>apsr(2),
n=>apsr(3),
v=>apsr(0),
cpsr_en=>ccpsr_en_out,
cpsr_out(15)=>dnegative,
cpsr_out(14)=>dzero,
cpsr_out(13)=>dcarry,
cpsr_out(12)=>doverflow,
cpsr_out(11 downto 0)=>zero
);
--
datamem:data_stack port map
(
Clk =>cclk_out,
Ram_Stack=>cstck_ram,
MemRead=>cmem_rd,
MemWrite=>cmem_wr,
Data_In=>reg_r_data2,
st_data=>reg_r_data3,
Data_Out=>memw_data,
PUSH =>cpush,
POP=>cpop,
Stack_Full=>memStack_Full,
Stack_Empty=>memStack_Empty,
stack_ptr=>memstack_in,
addr=>ard,
sel=>cwr_addr
--stack_0=>t_stack_0,
--stack_3=>t_stack_3,
--stack_7=>t_stack_7
--mr128=>m_mr128,
--mr129=>m_mr129,
--mr130=>m_mr130,
--mr131=>m_mr131

);
--
inst_unit:Inst_Q port map
(
inst_wr=>top_wr,
Inst_In =>t_inst_in,
Inst_Out=>q_inst_Out,
Inst_ptr =>q_inst_ptr,
wr_inst_ptr=>top_inst_ptr,
clk=>t_clk 
--inst_rd=>dinst_en
);
--
ram:extRam port map
(
addr=>t_addr,    
clk=>t_clk,
CE_L=>t_CE_L,
UB_L=>t_UB_L,
LB_L=>t_LB_L,
OE_L=>t_OE_L,
WE_L=>t_WE_L,
FlashCE_L=>t_FlashCE_L,
RAMCLK=>t_RAMCLK,
RAMADV_L=>t_RAMADV_L,
RAMCRE=>t_RAMCRE,
ready=>top_ready,
wr_cache=>top_wr,
pointer=>top_inst_ptr
);
--input output
i_o:inp_op port map
(
clk=>cclk_out,
sw=>t_sw,
anode=>t_anode,
cathode=>t_cathode,
reg0=>top_r0,
reg1=>top_r1,
reg2=>top_r2,
reg3=>top_r3,
--reg4=>top_r4,
--reg5=>top_r5,
progcount=>q_inst_ptr,
inst_out=>q_inst_out
--stackpoint=>memstack_in,
--mem0=>m_mr128,
--mem1=>m_mr129,
--mem2=>m_mr130,
--mem3=>m_mr131,
--stack0=>t_stack_0,
--stack1=>t_stack_3,
--stack2=>t_stack_7,
--stack3=>temp_st
);

progCounter:pc port map
(
en=>dpc_en,
pcout=>q_inst_ptr,
clk=>cclk_out,
pcin=>memw_data,
wr_en=>cwr,
sel=>cwr_addr
);
--
regbank_unit:regbank port map
(
clk =>cclk_out,
reset=>t_reg_reset,
wr_en=>cwr, 
w_addr=>cwr_addr,
r_addr1=>cinp1_addr,
r_addr2=>cinp2_addr,
r_addr3=>cinp3_addr,
w_data=> memw_data,
r_data1=>reg_r_data1,
r_data2=>reg_r_data2,
r_data3=>reg_r_data3,
pcin=>memw_data,
stack_in=>memstack_in,
link_in =>memw_data,
r0=>top_r0,
r1=>top_r1,
r2=>top_r2,
r3=>top_r3
--r4=>top_r4,
--r5=>top_r5

);
---
alu_unit:alu port map
(
rm_reg=>reg_r_data1,
rm_mem=>ard,
rm_wb=>memw_data,
write_address=>cwr_addr,
mem_address=>cadd_fwd,
input1=>cinp1_addr,
rn=>ainput2,
rd=>ard,
psr=>apsr,
alu_sel=>calu_sel,
alu_cy=>dcarry
);
--
barrel_shift:barrelshifter port map
( 
inp_addr_register2=>cinp2_addr,
data_writeback_cycle=>memw_data,
data_memory_cycle=>ard,
address_writeback=>cwr_addr,
address_memaccess=>cadd_fwd,
datain(15 downto 0)=>reg_r_data2,
datain(31 downto 16)=>sgn_data_out,
direction=>cbarr_sel(1),
rotation=>cbarr_sel(0),
count=>cbarrel_shift,
dataout=>ainput2,
mux_imm=>cmux_imm
);

sgn_ext:sign_ext port map
(
datain=>cimm_data,
imm=>cpc_sign,
dataout=>sgn_data_out
);
--alu 
result<=ard;
t_alu_sel<=calu_sel;
--prog counter
t_pc_out<=q_inst_ptr;
t_pc_en<=dpc_en;
--stack pointer
--t_stack_ptr<=memstack_in;
--reg adresses
t_reg1_addr<=cinp1_addr;
t_reg2_addr<=cinp2_addr;
--instQ output
t_inst_out<=q_inst_out;

t_imm<=cmux_imm;
--t_wdata<=memw_data;
t_waddr<=cwr_addr;
t_wr_reg<=cwr;
--t_rm<=reg_r_data1;
--t_rn<=ainput2;
--stack signals
--top_st_0<=t_stack_0;
--top_st_3<=t_stack_3;
--top_st_7<=t_stack_7;

t_wr<=top_wr;
--memory
--t_mr128<=m_mr128;
--t_mr129<=m_mr129;
--t_mr130<=m_mr130;
--t_mr131<=m_mr131;
--flags
t_flag(0)<=apsr(0);
t_flag(1)<=apsr(1);
t_flag(2)<=apsr(2);
t_flag(3)<=apsr(3);
--inst_Q
--t_inst_rd<=dinst_en;
--t_inst_ptr<=top_inst_ptr;

--registers
t_r0<=top_r0;
t_r1<=top_r1;
t_r2<=top_r2;
t_r3<=top_r3;
--t_r4<=top_r4;
--t_r5<=top_r5;

t_ready<=top_ready;

end Behavioral;

