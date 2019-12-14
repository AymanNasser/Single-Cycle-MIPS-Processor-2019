/*A mux that handles 13 bits input to 13 bits output*/

module MUX2to1_13(cntrl,in1,in2,out);
input cntrl;
input [12:0] in1,in2;
output [12:0] out;
assign out = (cntrl == 1) ? in2 : in1;
endmodule
