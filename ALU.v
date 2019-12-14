/*********************************************ALU Module************************************************/

/*THE ALU MODULE TAKES ITS INPUT FROM THE ALU CONTROL, shamt (ori support), INPUT ONE FROM READ DATA ONE AND INPUT 2 CAN VARRYAS WE WILL SEE,

 THE ALU IS ALSO A SYNCRONOUS MODULE SO THE CLK PLAYS AN IMPORTANT ROLE IN THE DESIGN, WHERE THE INPUT IS CHANGED EACH CLK CYCLE

A ZERO FLAG IS PRESENT TO AID IN THE IMPLEMENTATION OF BEQ,...*/

module ALU(shamt,input1,input2, Aluctl, Aluout, zflag);
input [31:0] input1,input2; //input 1 is the result of read data 1 //input 2 comes from a mux where two inputs are read data 2 and sign extention result and selection phase from control unit ALUsrc
input [3:0] Aluctl;//this input from alu ctl is to tell the alu what operation shall be performed
input [4:0] shamt; //shift amount 


output reg [31:0] Aluout; //output of alu operation
output zflag; //output aids in beq implementation

assign zflag = (Aluout == 0); // ZFLAG IS INITIALLY ASSIGNED ZERO AND IF THE 2 REGS ARE NOT EQUAL, ALUOUT WILLBE ASSIGNED TO 1

always @ (input1 or input2 or Aluctl or shamt)
begin
case(Aluctl) //WHEN ALUCTL SIGNAL CHANGES THE ALUOUT IS ASSIGNED BY THE OPERATION DONE
0: Aluout <= input1 & input2 ;
1: Aluout <= input1 | input2 ;
2: Aluout <= input1 + input2 ;
3: Aluout <= input1 << shamt;
6: Aluout <= input1 - input2 ; //SUBTRACTION
7: Aluout <= input1 < input2 ? 1:0 ; //in case of stl
12: Aluout <= ~(input1 | input2) ; // nor
// Default operation 
default: Aluout <= 0 ;
endcase
end
endmodule