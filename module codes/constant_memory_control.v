`timescale 1ns / 1ps
module constant_memory_control(
input clk,reset,
input b0_fetch,w0_fetch,b1_fetch,w1_fetch,
input [9:0]pixel_no,
input [5:0]l1_no,
output reg b0_complete,w0_complete,b1_complete,w1_complete,
output reg  [0:895]weight_reg,
output reg  [0:895]l1_reg,
output reg  [0:159]output_reg);

wire [15:0]douta,doutb;
reg  [15:0]addra,addrb;

constants mem_inst(
            .clka(clk),
            .addra(addra),
            .dina(16'h0000),
            .douta(douta),
            .wea(1'b0),
            .addrb(addrb),
            .clkb(clk),
            .dinb(16'h0000),
            .doutb(doutb),
            .web(1'b0));


wire [3:0]tasks;
assign tasks={b0_fetch,w0_fetch,b1_fetch,w1_fetch};
reg [1:0]state;
parameter s0=0,//assign initial addr
          s1=1,//ideal
          s2=2,  //assign reg and add to addr
          s3=3;
          
          reg [3:0]old_task;
reg [5:0]test;
always@(posedge clk)
begin
if(reset)
begin
b0_complete<=0;
w0_complete<=0;
b1_complete<=0;
w1_complete<=0;
weight_reg<=0;
l1_reg<=0;
output_reg<=0;
addra<=0;
addrb<=0;
old_task<=0;
end
else if (tasks!=old_task)
begin
old_task<=tasks;
state<=0;
case(tasks)
4'b1000:begin
        addra<=16'd0;
        addrb<=16'd55;
//        addra<=16'd43904;
//        addrb<=16'd43959;
        state<=0;
        end
4'b0100:begin
        addra<=pixel_no*56;
        addrb<=pixel_no*56+55;
        state<=0;
        end
4'b0010:begin
        addra<=16'd44520;
        addrb<=16'd44529;
        state<=0;
       end
4'b0001:begin
        addra<=43960+l1_no*10;
        addrb<=43960+l1_no*10+9;
        state<=0;
        end
endcase
end
else
begin
case(state)
s0:state<=s2;
//s1:state<=s2;
s2:begin
    if(addra==addrb || addra-1==addrb)
        begin
        state<=s3;
        addra<=0;
        addrb<=0;
        case(tasks)
                    4'b1000:begin
                            b0_complete<=1;
                            end
                    4'b0100:begin
                            w0_complete<=1;
                            end
                    4'b0010:begin
                            b1_complete<=1;
                            end
                    4'b0001:begin
                            w1_complete<=1;
                            end
                    endcase
        end
    else
        begin
        case(tasks)
            4'b1000:begin
//                    l1_reg[((addra-43904)-1)*16 +:16]<=douta;
//                    l1_reg[((addrb-43904)-1)*16 +:16]<=doutb;
                    l1_reg[(addra-1)*16 +:16]<=douta;
                    l1_reg[(addrb)*16 +:16]<=doutb;
                    addra<=addra+1;
                    addrb<=addrb-1;
                                end
            4'b0100:begin
                    weight_reg[((addra-1)-pixel_no*56)*16 +:16]<=douta;
                    weight_reg[((addrb)-pixel_no*56)*16 +:16]<=doutb;
                    addra<=addra+1;
                    addrb<=addrb-1;
                    end
            4'b0010:begin
                    output_reg[((addra-1)-44520)*16 +:16]<=douta;
                    output_reg[((addrb)-44520)*16 +:16]<=doutb;
                    addra<=addra+1;
                    addrb<=addrb-1;
                    end
            4'b0001:begin
                    l1_reg[((addra-1)-43960)*16 +:16]<=douta;
                    l1_reg[((addrb)-43960)*16 +:16]<=doutb;
                    addra<=addra+1;
                    addrb<=addrb-1;
                    end
            endcase
            end
     end
s3:begin
            b0_complete<=0;
            w1_complete<=0;
            b1_complete<=0;
            w0_complete<=0;
end
endcase
end
end
endmodule