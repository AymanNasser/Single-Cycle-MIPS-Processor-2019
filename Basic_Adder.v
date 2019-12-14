/* This module is specific for branch equal instruction (Beq) to set the next address of PC 
   by (Current PC Address + 4) + (SIGN_EXTENSION_OUTPUT Shift lefted by 2) 
 */
 
module Adder(output [12:0] result,input [12:0] in1,input [12:0] in2);
assign result = in1 + in2;
endmodule
