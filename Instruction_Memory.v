/********************************INSTRUCTION_memory Module**************************************/

/* Inst_memory module is a 32K Byte memory, takes the program counter (PC) as an input to determine which 
   instruction is going to be fetched and then outputs the instruction machine code on a 32-bit register

   Inst_memory is synchronized by a 1-bit CLOCK signal
*/

module INSTRUCTION_memory (PC , instruction);
input [12:0] PC ; 
output [31:0] instruction ; // word in instruction is 32 bit 
/*
 * We have 32KB instruction memory 
 * and 4 byte for each instruction 
 * So We will have (2^13) instruction == 8192  [8191:0]
*/
reg [31:0] instruction_array [0:8191]; 
/*
 * When the PC changes 
 * Then We will Fetch the Next Instruction from The INSTRUCTION_Memory
*/
assign instruction = instruction_array [PC >> 2];

initial
begin
$readmemb("F:/test.txt",instruction_array); // first arguement file txt path of machine code
//$display("%h %h %h",instruction_array[0],instruction_array[1],instruction_array[2]);
end

endmodule
