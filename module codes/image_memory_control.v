`timescale 1ns / 1ps 
module image_memory_control(
input clk,
input [9:0]pixel_no,
input grayscale_fetch,
output reg grayscale_fetched,
output reg [15:0]gray_scale);

wire [7:0]dout;
reg [1:0]count;
image_memory img( .clka(clk),
                  .addra(pixel_no),
                  .dina(8'b0),
                  .douta(dout),
                  .wea(1'b0));
                  
                   
always@(posedge clk)
begin
if(grayscale_fetch==1)
    begin
    count<=count+1;
        if(count==2)
        begin
        count<=0;
        grayscale_fetched<=1;
        gray_scale<={8'b0,dout};
        end
        else 
        grayscale_fetched<=0;
    end
    
 else
 count<=0;
end
    endmodule
