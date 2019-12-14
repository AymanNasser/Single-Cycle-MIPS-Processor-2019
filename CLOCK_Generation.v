`timescale 10ns/10ps //REACH 10ns WITH A STEP OF 10ps
 /********************************CLOCK_generation Module**************************************/
module CLOCK_generation(clock);
output reg clock;
initial 
begin 
clock <= 0 ; 
end 
always 
begin 
#3.125 clock = ~clock;
end 
endmodule
