`timescale 1ns / 1ps
module MUL16 (
    input  signed [15:0] A,  // Multiplicand (Q4.12 fixed-point)
    input  signed [15:0] B,  // Multiplier   (Q4.12 fixed-point)
    input  mul0,mul1,
    output signed [15:0] out   // Product      (Q8.24 before shifting back to Q4.12)
);

    wire [31:0] partial [15:0];
    wire [31:0] mul;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : PARTIAL_PRODUCT
            assign partial[i] = B[i] ? (A <<< i) : 32'd0;
        end
    endgenerate

    // Sum all partial products
    wire [31:0] sum0  = partial[0]  + partial[1];
    wire [31:0] sum1  = partial[2]  + partial[3];
    wire [31:0] sum2  = partial[4]  + partial[5];
    wire [31:0] sum3  = partial[6]  + partial[7];
    wire [31:0] sum4  = partial[8]  + partial[9];
    wire [31:0] sum5  = partial[10] + partial[11];
    wire [31:0] sum6  = partial[12] + partial[13];
    wire [31:0] sum7  = partial[14] + partial[15];

    wire [31:0] sum8  = sum0 + sum1;
    wire [31:0] sum9  = sum2 + sum3;
    wire [31:0] sum10 = sum4 + sum5;
    wire [31:0] sum11 = sum6 + sum7;

    wire [31:0] sum12 = sum8 + sum9;
    wire [31:0] sum13 = sum10 + sum11;

    assign mul = sum12 + sum13;
 
    assign out=mul0?mul[15:0]:mul1?mul[27:12]:0;
endmodule
