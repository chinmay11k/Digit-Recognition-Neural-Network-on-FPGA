`timescale 1ns / 1ps
module control_unit(
input clk,start,reset,
input load_complete,grayscale_fetched,l1_fetched,
input b0_complete,w0_complete,b1_complete,w1_complete,
input [15:0]gray_scale,
input [15:0]l1_value,
output reg mul_0,mul_1,add_0,add_1,load,grayscale_fetch,b0_fetch,w0_fetch,b1_fetch,w1_fetch,l1_fetch,compare,new_l1,new_out,
output reg [9:0]pixel_no,
output reg [5:0]l1_no);

reg [4:0]state;
parameter si=17,//ideal
          s0=0,//load img
          s1=1,//load biases L0 and 
          s2=2,//get grayscale
          s3=3,//fetch weights grayscale cheak
          s4=4,//mul0
          s5=5,//add
          s6=6,//get baises L1  
          s7=7,//get L1 value 
          s8=8,//cheak value and load weights
          s9=9,//mul1
          s10=10,//add  a
          s11=11,//compaire  b
          s12=12,//output    c
          MUL0=13,//multiplication can take time   d
          ADD0=14,//addition time   e
          MUL1=15,//multiplication can take time f
          ADD1=16;//addition time  10

always@(posedge clk)
begin
if(reset)
    begin
        state=si;
        pixel_no=0;
        l1_no=0;
        mul_0=0;
        mul_1=0;
        add_0=0;
        add_1=0;
        load=0;
        grayscale_fetch=0;
        b0_fetch=0;
        w0_fetch=0;
        b1_fetch=0;
        w1_fetch=0;
        l1_fetch=0;
        compare=0;
        new_l1=0;
        new_out=0;
    end
 else
 begin
    case(state)//next state logic
    si:begin
        if(start==1)
        state=s0;
            end 
    s0:begin
        if(load_complete==1)
        state=s1;
            end
    s1:begin
        if(b0_complete==1)
        state=s2;
            end
    s2:begin
        if(grayscale_fetched==1)
        begin
            pixel_no=pixel_no+1;
            if(pixel_no<=784)
                if(gray_scale==0)
                state=s2;
                else 
                state=s3;
             else
                state=s6;
        end
       end
    s3:begin
        if(w0_complete==1)
            state=4;
            end
    s4:begin
        state=MUL0;
            end
    MUL0:begin
            state=s5;
         end
    s5:begin
            state=ADD0;
            end
    ADD0:begin
         state=s2;
         end          
    s6:begin
            if(b1_complete==1)
            state=s7;
            end
    s7:begin
            if(l1_fetched==1)
                begin
                l1_no=l1_no+1;
                    if(l1_no<=56)
                       if(l1_value>0)
                        state=s8;
                       else
                        state=s7;
                    else
                    state=s11;
        end
        end 
    s8:begin
           if(w1_complete==1)
            state=s9;
       end
    s9:begin
         state=MUL1;
                end
    MUL1:begin
            state=s10;
        end
    s10:begin
            state=ADD1;
            end
    ADD1:begin
                   state=s7;
                    end
    endcase
    
    case(state)//output in each states
    s0:begin
        load=1;
            end
    s1:begin
        load=0;
        b0_fetch=1;
            end
    s2:begin
        b0_fetch=0;
        grayscale_fetch=1;
        add_0=0;
             mul_0=0;      
             new_l1=0;
           end
    s3:begin
            grayscale_fetch=0;
            w0_fetch=1;
            end
    s4:begin
                w0_fetch=0;
                mul_0=1;
                            add_0=1;

            end
    s5:begin
//            mul_0=0;
//            add_0=1;
             new_l1=1;
           end
    s6:begin
            b1_fetch=1;
            add_0=0;
                       mul_0=0;
            new_l1=0;
            end
    s7:begin
            b1_fetch=0;
            l1_fetch=1;
            add_1=0;
            mul_1=0;
               new_out=0;
       
        end
    s8:begin
            l1_fetch=0;
            w1_fetch=1;
            end
    s9:begin
                w1_fetch=0;
                mul_1=1;
                add_1=1;

            end
    s10:begin
//            mul_1=0;
//            add_1=1;
              new_out=1;
            end
    s11:begin
            add_1=0;
            mul_1=0;
                          new_out=0;

            compare=1;
            end      
            
    endcase
    end
    end
    
endmodule