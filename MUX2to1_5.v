/*A mux that handles 5 bits input to 5 bits output*/

module MUX2to1_5(cntrl,in1,in2,out);
input cntrl;
input [4:0] in1,in2;
output [4:0] out;
assign out = (cntrl == 1) ? in2 : in1;
endmodule
