/************************************REGISTER_file Module********************************************/

/* The register file module is responsible for reading data from registers and sending it to to other modules in mips,

or writing data in registers, register module is synchronous element that depends on posedge of clock to change outputs

inputs of regfile are:

read reg 1 -> read from rs register

read reg 2 -> result of mux either read from rt or rd

write data -> data to be written in register (32 bits),result of mux that is selected by control unit memtoreg signal (alu result)

write reg -> which will be the register destination

outputs are: read data 1 and read data 2 to be entered in alu
*/

module REGISTER_file(CLK, reg_write_sig , read_reg1, read_reg2, write_reg, write_data, read_data1, read_data2);

input [31:0] write_data ; 
input [4:0] read_reg1, read_reg2, write_reg;
input reg_write_sig, CLK;

output [31:0] read_data1, read_data2;
reg [31:0]  RF[0:31]; 

integer i;

initial
begin
for(i=0;i<32;i=i+1)
	RF[i] = 0;
end

assign read_data1 = RF[read_reg1];
assign read_data2 = RF[read_reg2];

always  @ (posedge CLK )
begin
if(reg_write_sig) // if reg write signal is on , assign write data signal, put this data in the destination register either rt or rd
	RF[write_reg] <= write_data;
end
endmodule
