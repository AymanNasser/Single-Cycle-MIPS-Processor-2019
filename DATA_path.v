`timescale 10ns/10ps //REACH 10ns WITH A STEP OF 10ps
/**************************************Data_Path Module***************************************/

/* This module represents MIPS single cycle processor data path which includes all modules external wires, 
   registers, MUXes & modules instances
*/

module MIPS_cpu();
/* Register file wires*/
wire [4:0] write_reg, write_reg2;
wire [31:0] write_data_reg, read_data1, read_data2;

/* ALU & ALU_Control wires*/
wire [3:0] Aluctl;
wire [31:0] ALU_in2, ALU_result;

wire [31:0] memtoreg_output1, SIGN_extended, Mem_Read_data; 

/* Jump instruction related wires*/
wire [12:0] Jump_out, Jump_address, jump_branch_select;

/* Program counter wires*/
wire [12:0] current_pc, next_pc, Adder_result;

/*Instruction register wire */
wire [31:0] IR;

/* Outputs of control Unit */
wire CLK;
wire RegDst;
wire Branch;
wire jal;
wire MemRead;
wire MemtoReg;
wire MemWrite;
wire ALUSrc;
wire RegWrite;
wire Jump;
wire Jump_r;
wire [1:0] ALUop;

/* assign wire pc + 4 in 13-bit to avoid data over flow and warnings */
wire [12:0] current_pc_plus_4 = current_pc + 4; 

//reg [31:0] RF [0:31];

/* Modules Instances are arranged according to data_flow paths*/

CLOCK_generation c(CLK);

PC program_counter(next_pc,CLK,current_pc);

INSTRUCTION_memory I_memory(current_pc, IR);

REGISTER_file R_file(CLK, RegWrite, IR[25:21], IR[20:16], write_reg2, write_data_reg, read_data1, read_data2);

CONTROL_unit control_u(IR[31:26],IR[5:0],RegDst, MemRead, MemtoReg, ALUop, MemWrite, ALUSrc, RegWrite, Branch, Jump,Jump_r,jal);

SIGN_extension ext(IR[15:0],SIGN_extended);

Adder add(Adder_result,IR[12:0] << 2,current_pc_plus_4);

ALU_control alu_c(IR[5:0], ALUop, Aluctl);

ALU alu(IR[10:6],read_data1,ALU_in2, Aluctl, ALU_result, zflag);

DATA_memory mem(Mem_Read_data,ALU_result[12:0],MemWrite,MemRead,read_data2,CLK);

jump_handle jump_h(IR[6:0],current_pc,Jump_address);

and beq(PCSrc,Branch,zflag);

/* MUXes Instances for data_path controlling */

MUX2to1_5 REG_dst_mux(RegDst,IR[20:16],IR[15:11],write_reg);
MUX2to1_5 REG_dst_mux2(jal,write_reg, 5'b11111, write_reg2);

MUX2to1_32 ALU_result_mux(ALUSrc,read_data2,SIGN_extended,ALU_in2);

MUX2to1_13 beq_mux(PCSrc,current_pc_plus_4,Adder_result,jump_branch_select);

MUX2to1_32 MemtoReg_mux(MemtoReg,ALU_result,Mem_Read_data,memtoreg_output1);
MUX2to1_32 MemtoReg_mux2(jal,memtoreg_output1, {19'b0000000000000000000,current_pc_plus_4},write_data_reg);

MUX2to1_13 jump_mux(Jump,jump_branch_select,Jump_address,Jump_out);

MUX2to1_13 next_instruction_mux(Jump_r,Jump_out,read_data1[12:0],next_pc);


/* handling output of the code */

/*integer i,file;
always @ (posedge CLK)
begin
if(IR == 32'h0000_0000)
file = $fopen("F:/out.txt");
$fmonitor(file,"%h // %d\n",RF[i],RF[i]);
for(i=0;i<31;i=i+1)
begin
#1
i=i;
end
end */

endmodule 