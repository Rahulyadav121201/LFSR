`timescale 1ns / 1ps
//Dflipflop
module Dflipflop(
input Vdd,D,gnd,sel,sel1,clc,
output Q
);
wire Z,X;

multiplex Mux1st(.I0(gnd) , .I1(Vdd) , .S0(sel1) , .O(Z));
multiplex Mux2nd(.I1(D) ,.I0(Z) ,.S0(sel) ,.O(X));
dflop dflip(.L(X) , .clk(clc) , .e(Q));
endmodule

//mux code 
module multiplex(
input I0,I1,
input S0,
output O
);
assign O=S0?I1:I0;
endmodule

//dflipflop
module dflop(
input L,clk,
output reg e);
always @(posedge clk)
begin
e<=L;
end
endmodule

//Final instantiated code
module connecteddflipflops (Vdd,gnd,sel,sel1,clock,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,Final);
input Vdd,gnd,sel,sel1,clock;
output q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14;
output [13:0]Final;
wire p,s,D;
Dflipflop A1(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(D),.clc(clock), .Q(q1));
Dflipflop A2(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q1),.clc(clock), .Q(q2));
Dflipflop A3(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q2),.clc(clock), .Q(q3));
Dflipflop A4(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q3),.clc(clock), .Q(q4));
Dflipflop A5(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q4),.clc(clock), .Q(q5));
Dflipflop A6(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q5),.clc(clock), .Q(q6));
Dflipflop A7(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q6),.clc(clock), .Q(q7));
Dflipflop A8(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q7),.clc(clock), .Q(q8));
Dflipflop A9(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q8),.clc(clock), .Q(q9));
Dflipflop A10(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q9),.clc(clock), .Q(q10));
Dflipflop A11(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q10),.clc(clock), .Q(q11));
Dflipflop A12(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q11),.clc(clock), .Q(q12));
Dflipflop A13(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q12),.clc(clock), .Q(q13));
Dflipflop A14(.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.D(q13),.clc(clock), .Q(q14));
assign p = q13^q14;
assign s = p^q12;
assign D = q2^s;
wire [13:0]Dflop_input;
assign Dflop_input= {q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14};
wire [13:0] N;
comparison_unit c1(.q14(q14),.q13(q13),.q12(q12),.q11(q11),.q10(q10),.q9(q9),.q8(q8),.q7(q7),.q6(q6),.q5(q5),.q4(q4),.q3(q3),.q2(q2),.q1(q1),.Dflop_input(Dflop_input),.N(N),.interlieved_address(Final));
endmodule

//Comparison Unit
module comparison_unit(q14,q13,q12,q11,q10,q9,q8,q7,q6,q5,q4,q3,q2,q1,Dflop_input,N,interlieved_address);
input q14,q13,q12,q11,q10,q9,q8,q7,q6,q5,q4,q3,q2,q1;
input [13:0]Dflop_input,N;
output reg [13:0]interlieved_address;
assign Dflop_input= {q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14};
assign N=14'b 10111111111010;
always @(*)
begin
if(Dflop_input>N)
begin
interlieved_address<=14'b10111111111011;
end
else
interlieved_address<=Dflop_input;
end
endmodule



module lfsr_interleaver(
st,clk,incoming_data,interlieved_data,Vdd,gnd,sel,sel1);
input Vdd,gnd,sel,sel1;
input st,clk;
input [31:0]incoming_data;
output reg [31:0] interlieved_data;
//reg [13:0]Add;
//memory
wire [13:0]Final;
reg [31:0] RAM [12283:0];
reg [13:0]count;
//reg rst;
connecteddflipflops agu_connection(.Final(Final),.Vdd(Vdd),.gnd(gnd),.sel(sel),.sel1(sel1),.clock(clk));
always @(posedge clk)
begin
if(st==1)
if(count<=12283)
begin
count<=count+1'b1;
RAM[count]<=incoming_data;
end
else
begin
interlieved_data<=RAM[Final];
end
else
count = 1'b0;
end
//connecteddflipflops agu_connection(.Final(Final));
endmodule



