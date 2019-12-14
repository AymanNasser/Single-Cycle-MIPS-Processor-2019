/********************************************ALU_Control Module****************************************/

/* The ALU CONTROL module is reponsiple for generating the aluctl as an output, which is directed to the alu to tell 

it which ooperation must be done, the alu control takes the fucfield(from the instructon) and the aluop(from control unit) as inputs 
*/

module ALU_control(funcField, Aluop, Aluctl);

input [5:0] funcField; // first  6 bits of any instruction
input [1:0] Aluop; //control unit signal, we assigned only 2 bits as they are enough to support basic operation

output reg [3:0] Aluctl; // alu ctl is 4 bits to support the instructions


always @ (funcField or Aluop) //enters loop if any of funcfield or aluop is changed
begin
if( Aluop == 2'b00) //add operation
begin
Aluctl <= 4'b0010;
end
else if ( Aluop == 2'b01 ) //subtract operation
begin
Aluctl <= 4'b0110;
end
else if ( Aluop == 2'b10 ) // determined by the operation encoded in the functionn field
begin
case(funcField)
/*SLL Inst*/
0:  Aluctl <= 4'b0011;
/*AND Inst*/
36: Aluctl <= 4'b0000;
/*OR Inst*/
37: Aluctl <= 4'b0001;
/*ADD Inst*/
32: Aluctl <= 4'b0010;
/*SUB Inst*/
34: Aluctl <= 4'b0110;
/*SLT Inst*/
42: Aluctl <= 4'b0111;
/*NOR Inst*/
39: Aluctl <= 4'b1100;
default : Aluctl <= 4'b0000;
endcase
end
/* ORI instruction*/
else if (Aluop == 2'b11)
begin
Aluctl <= 4'b0100;
end
end

endmodule