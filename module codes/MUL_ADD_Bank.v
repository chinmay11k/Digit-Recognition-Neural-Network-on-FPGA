`timescale 1ns / 1ps
module MUL_ADD_Bank(
input mul_0,mul_1,add_0,add_1,
input [0:895] weight_reg,
input [0:159] output_reg,
input [0:895] l1_reg,
input [15:0] gray_scale,
input [15:0]  l1_value,
output [0:895] next_l1_reg,
output [0:159] next_output_reg);

wire [0:895]mul_wire;
wire [0:895]add_wire;
wire [0:895]out_wire;
wire [15:0]A;

assign A=mul_0?gray_scale:(mul_1?l1_value:0);

genvar m;

generate for(m=0;m<56;m=m+1)
    begin:MUL
        MUL16 mul(.A(A),
                  .B(weight_reg[m*16:m*16+15]),
                  .mul0(mul_0),
                  .mul1(mul_1),
                  .out(mul_wire[m*16:m*16+15]));
        end
endgenerate

assign add_wire=add_0?l1_reg:(add_1?output_reg:0);

genvar a;
generate for(a=0;a<56;a=a+1)
    begin:ADD
       ADD16 add(.a(mul_wire[a*16:a*16+15]),
                 .b(add_wire[a*16:a*16+15]),
                 .sum(out_wire[a*16:a*16+15]));
        end
endgenerate

//always@(add_0,add_1)
//begin
//if(add_0==1)
//begin

assign next_l1_reg=add_0?out_wire:l1_reg;
assign next_output_reg=add_1?out_wire:output_reg;


endmodule
