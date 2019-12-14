/*********************************************PC_Module********************************************/

/* The pc module is responsible for assigning next pc to current pc eac pposedge clock as its synchronous*/

module PC(input [12:0] next_pc,input clk,output reg[12:0] current_pc);

initial
begin
current_pc <= 0;
end
always @ ( posedge clk)
begin
current_pc <=  next_pc;
end
endmodule
