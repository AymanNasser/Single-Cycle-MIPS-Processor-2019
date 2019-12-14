/*Jump instruction handling module*/

module jump_handle(input [6:0] instruction,input [12:0] current_pc,output [12:0] jump_address);
assign jump_address =  {current_pc[12:8],instruction,2'b00}; //jump address is result of concatenation with current pc bits from 12 to 8 , instruction, and adding 2 zeros from the right
endmodule
