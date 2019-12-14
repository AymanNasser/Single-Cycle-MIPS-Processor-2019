/*A mux that handles 32 bits inputs to 32 bits output*/

module MUX2to1_32(cntrl,in1,in2,out);
input cntrl;
input [31:0] in1,in2;
output [31:0] out;
assign out = (cntrl == 1) ? in2 : in1;
endmodule
