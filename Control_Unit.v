/*****************************CONTROL UNIT MODULE**************************************/

/*The control unit module is responsible for generating various signals to almost all modules of the mips processor,

the control unit takes the opcode and funcfield as inputs , outputs REGDST, memread, memtoreg, ALUOP, memwrite, ALUSRC,

 regwrite, branch, jump, jump_r, jal, all these signals are vital for the mips processor and the execution overall

REGDST -> it is responsible for controlling a mux to either write in rt or rd registers

memread -> determine whether to read from memory or not to display it

memtoreg -> read mem data or alu result

ALUOP ->signals sent to the alu ctl to detremine the op

memwrite ->write in memory or not

ALUSRC -> controls mux to choses bet read data 2 or sign extension result

regwrite ->write in registers or not

branch -> to be anded with zero flag to aid in implementation of branch instruction

jump -> to  handle jump instruction

jump_r -> to handle jump register instruction

jal -> to control two additional muxes one after memtoreg mux and the other one is after the regdest mux to implement jal
*/

module CONTROL_unit(opcode,func,REGDST, memread, memtoreg, ALUOP, memwrite, ALUSRC, regwrite, branch, jump, jump_r, jal);

input [5:0] opcode;
input [5:0] func;

output reg REGDST, memread, memtoreg, memwrite, ALUSRC, regwrite, branch, jump, jump_r, jal;
output reg [1:0] ALUOP;

always @ (opcode or func)
	begin
	
	//reseting all signals

	REGDST <= 1'b0;
	memread <= 1'b0;
	memtoreg <= 1'b0;
	memwrite <= 1'b0;
	regwrite <= 1'b0;
	branch <= 1'b0;
	ALUSRC <= 1'b0;
	ALUOP <= 2'b00;
	jump <= 1'b0;
	jump_r <= 1'b0;
	jal <= 1'b0;
	
	begin

	//the r-type instructions implementation
	if(opcode == 6'b000000) 
		begin
		/* Jump register instruction*/
		if(func== 6'b001000)
			begin
			jal <= 1'b0;
			jump_r <= 1'b1;
			end
		/* Add,And,Or,SLT,SLL Instructions*/
		else
			begin
			jal <= 1'b0;
			REGDST <= 1'b1;
			ALUOP <= 2'b10;
			regwrite <= 1'b1;
			end
		end
	//addi instruction implemntation
	else if(opcode == 6'b001000) 
		begin
		jal <= 1'b0;
		REGDST <= 1'b0;
		memread <= 1'b0;
		memtoreg <= 1'b0;
		regwrite <= 1'b1;
		ALUSRC <= 1'b1;
		ALUOP <= 2'b00;
		end
	
	//ori instruction implementation
	else if(opcode == 6'b001101) 
		begin
		jal <= 1'b0;
		REGDST <= 1'b0;
		memread <= 1'b0;
		memwrite <= 1'b0;
		memtoreg <= 1'b0;
		regwrite <= 1'b1;
		ALUSRC <= 1'b1;
		ALUOP <= 2'b11;
		end

	//lw instruction implementation
	else if(opcode == 6'b100011) 
		begin
		jal <= 1'b0;
		REGDST <= 1'b0;
		memread <= 1'b1;
		memtoreg <= 1'b1;
		memwrite <= 1'b0;
		regwrite <= 1'b1;
		branch <= 1'b0;
		ALUSRC <= 1'b1;
		ALUOP <= 2'b00;
		end

	//sw instruction implementation
	else if(opcode == 6'b101011) 
		begin
		jal <= 1'b0;
		memread <= 1'b0;
		memwrite <= 1'b1;
		regwrite <= 1'b0;
		branch <= 1'b0;
		ALUSRC <= 1'b1;
		ALUOP <= 2'b00;
		end

	//beq instruction implementation
	else if(opcode == 6'b000100) 
		begin
		jal <= 1'b0;
		memread <= 1'b0;
		memwrite <= 1'b0;
		regwrite <= 1'b0;
		branch <= 1'b1;
		ALUSRC <= 1'b0;
		ALUOP <= 2'b01;
		end
	


	// jump implementation
	else if(opcode == 6'b000010) 
		begin
		jal = 1'b0;
		memread = 1'b0;
		memwrite = 1'b0;
		regwrite = 1'b0;
		branch = 1'b0;
		ALUSRC = 1'b0;
		ALUOP = 2'b01;
		jump = 1'b1;
		end

	//JAL implementation
	else if(opcode == 6'b000011)
		begin
		jal <= 1'b1;		
		jump <= 1'b1; 		
		memread <= 1'b0;
		memwrite <= 1'b0;
		memtoreg <= 1'b0;
		regwrite <= 1'b1;
		end	


	end
	end
endmodule