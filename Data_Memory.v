/*****************************************Data Memory Module******************************************/

/* Data_memory module takes multiple inputs (address, data, control unit signals and CLOCK), 1-output
   18-bit address field which results from ALU_OUTPUT to specifiy which place in memory to 
   read/write from/in as the program memory is 32K-Byte 

   32-bit data field which results from Register file direct to the program memory if we want to write

   1-bit CLOCK signal to synchronize the program memory

   2 1-bit control unit singals to control reading/writting from/to memory

   32-bit Data_output 
*/

module DATA_memory(Read_data,Address,MemWrite,MemRead,Write_data,Clk);
input Clk,MemWrite,MemRead;
input [12:0] Address;
input [31:0] Write_data;
output [31:0] Read_data;
reg [31:0] RF[0:8191];
integer i;
initial
begin
for(i=0;i<8191;i=i+1)
	RF[i] = 0;
end
assign Read_data = (MemRead == 1) ? RF[Address] : 32'h00000000;
always @(posedge Clk)
begin
if(MemWrite)
	RF[Address] <= Write_data;
end
endmodule
