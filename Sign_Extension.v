/*The sign extension module is responsible for handling negative nnumbers or positive ones 
entered as 16 bits to 32 bits, where the 16th bit is repeated 16 more bits to get 32 bits*/

module SIGN_extension(input [15:0] in,output reg [31:0] out);
always @(in)
begin
if(in[15] == 1'b0)
	out <= 32'b00000000000000001111111111111111 & in;
else if(in[15] == 1'b1)
	out <= 32'b11111111111111110000000000000000 | in;
end
endmodule