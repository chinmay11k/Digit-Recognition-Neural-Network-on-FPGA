`timescale 1ns / 1ps
module Neural_network(
input clk,start,reset,load_complete,
output [3:0]digit);

//wire load_complete;
wire grayscale_fetched;
wire l1_fetched;
wire b0_complete;
wire w0_complete;
wire b1_complete;
wire w1_complete;
wire [15:0] gray_scale;
reg [15:0] l1_value;
wire mul_0,mul_1;
wire add_0,add_1;
wire load;
wire grayscale_fetch;
wire b0_fetch;
wire w0_fetch;
wire b1_fetch;
wire w1_fetch;
wire l1_fetch;
wire compare;
wire [9:0] pixel_no;
wire [5:0] l1_no;
wire new_l1,new_out;
reg [0:895] l1_reg;

control_unit  cu_inst(
    .clk(clk),
    .start(start),
    .reset(reset),
    .load_complete(load_complete),
    .grayscale_fetched(grayscale_fetched),
    .l1_fetched(l1_fetched),
    .b0_complete(b0_complete),
    .w0_complete(w0_complete),
    .b1_complete(b1_complete),
    .w1_complete(w1_complete),
    .gray_scale(gray_scale),
    .l1_value(l1_value),
    .mul_0(mul_0),
    .add_1(add_1),
    .mul_1(mul_1),
    .add_0(add_0),
    .load(load),
    .grayscale_fetch(grayscale_fetch),
    .b0_fetch(b0_fetch),
    .w0_fetch(w0_fetch),
    .b1_fetch(b1_fetch),
    .w1_fetch(w1_fetch),
    .l1_fetch(l1_fetch),
    .compare(compare),
    .new_out(new_out),
    .new_l1(new_l1),
    .pixel_no(pixel_no),
    .l1_no(l1_no)
);
wire [0:15]l1_value_wire;
l1_reg_control l1_reg_control (
    .clk(clk),
    .l1_reg(l1_reg),
    .l1_fetch(l1_fetch),
    .l1_no(l1_no),
    .l1_fetched(l1_fetched),
    .l1_value_wire(l1_value_wire)
);

// Instantiate image_memory_control
image_memory_control image_memory_control (
    .clk(clk),
    .pixel_no(pixel_no),
    .grayscale_fetch(grayscale_fetch),
    .grayscale_fetched(grayscale_fetched),
    .gray_scale(gray_scale)
);
wire [0:895] weight_reg;
wire [0:159]first_output_reg;
wire [0:159]next_output_reg;
wire [0:895]first_l1_reg;
wire [0:895]next_l1_reg;
reg [0:159] output_reg;
// Instantiate constant_memory_control
constant_memory_control constant_memory_control (
    .clk(clk),
    .reset(reset),
    .b0_fetch(b0_fetch),
    .w0_fetch(w0_fetch),
    .b1_fetch(b1_fetch),
    .w1_fetch(w1_fetch),
    .pixel_no(pixel_no),
    .l1_no(l1_no),
    .b0_complete(b0_complete),
    .w0_complete(w0_complete),
    .b1_complete(b1_complete),
    .w1_complete(w1_complete),
    .weight_reg(weight_reg),
    .l1_reg(first_l1_reg),
    .output_reg(first_output_reg)
);

// Instantiate max_find
max_find max_find (
    .en(compare),
    .in(output_reg),
    .max_index(digit)
);
//adder multiplier bank
MUL_ADD_Bank MUL_ADD_Bank (
    .mul_0(mul_0),
    .mul_1(mul_1),
    .add_0(add_0),
    .add_1(add_1),
    .weight_reg(weight_reg),
    .output_reg(output_reg),
    .l1_reg(l1_reg),
    .gray_scale(gray_scale),
    .l1_value(l1_value),
    .next_l1_reg(next_l1_reg),
    .next_output_reg(next_output_reg)
);
always@(new_l1,new_out,b1_complete,b0_complete)
begin
case({new_l1,new_out,b0_complete,b1_complete})
4'b1000:l1_reg<=next_l1_reg;
4'b0100:output_reg<=next_output_reg;
4'b0010:l1_reg<=first_l1_reg;
4'b0001:output_reg<=first_output_reg;
endcase
end
always@(posedge l1_fetched)
l1_value<=l1_value_wire;
endmodule 