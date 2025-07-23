//`timescale 1ns / 1ps
//module l1_reg_control(
//input clk,
//input [0:895]l1_reg,
//input l1_fetch,
//input [5:0]l1_no,
//output reg l1_fetched,
//output reg [0:15]l1_value);
//reg [5:0] n;
//always@(posedge clk)
//begin
//if(l1_fetch==1)
//begin
//n=l1_no;
//l1_value=l1_reg[(n*16):(n*16+15)];
//l1_fetched=1;
//end
//else
//l1_fetched=0;
//end
//endmodule
`timescale 1ns / 1ps
module l1_reg_control(
    input wire clk,                  // Add clock input
    input wire [0:895] l1_reg,       // 896 bits => 56 x 16-bit values
    input wire l1_fetch,
    input wire [5:0] l1_no,          // To select 0 to 55
    output reg l1_fetched,
    output reg [15:0] l1_value_wire       // Use [15:0] instead of [0:15] for consistency
);

always @(posedge clk) begin
    if (l1_fetch) begin
       case(l1_no)
        0:l1_value_wire<=l1_reg[0:15];
       1:l1_value_wire<=l1_reg[16:31];
       2:l1_value_wire<=l1_reg[32:47];
       3:l1_value_wire<=l1_reg[48:63];
       4:l1_value_wire<=l1_reg[64:79];
       5:l1_value_wire<=l1_reg[80:95];
       6:l1_value_wire<=l1_reg[96:111];
       7:l1_value_wire<=l1_reg[112:127];
       8:l1_value_wire<=l1_reg[128:143];
       9:l1_value_wire<=l1_reg[144:159];
       10:l1_value_wire<=l1_reg[160:175];
       11:l1_value_wire<=l1_reg[176:191];
       12:l1_value_wire<=l1_reg[192:207];
       13:l1_value_wire<=l1_reg[208:223];
       14:l1_value_wire<=l1_reg[224:239];
       15:l1_value_wire<=l1_reg[240:255];
       16:l1_value_wire<=l1_reg[256:271];
       17:l1_value_wire<=l1_reg[272:287];
       18:l1_value_wire<=l1_reg[288:303];
       19:l1_value_wire<=l1_reg[304:319];
       20:l1_value_wire<=l1_reg[320:335];
       21:l1_value_wire<=l1_reg[336:351];
       22:l1_value_wire<=l1_reg[352:367];
       23:l1_value_wire<=l1_reg[368:383];
       24:l1_value_wire<=l1_reg[384:399];
       25:l1_value_wire<=l1_reg[400:415];
       26:l1_value_wire<=l1_reg[416:431];
       27:l1_value_wire<=l1_reg[432:447];
       28:l1_value_wire<=l1_reg[448:463];
       29:l1_value_wire<=l1_reg[464:479];
       30:l1_value_wire<=l1_reg[480:495];
       31:l1_value_wire<=l1_reg[496:511];
       32:l1_value_wire<=l1_reg[512:527];
       33:l1_value_wire<=l1_reg[528:543];
       34:l1_value_wire<=l1_reg[544:559];
       35:l1_value_wire<=l1_reg[560:575];
       36:l1_value_wire<=l1_reg[576:591];
       37:l1_value_wire<=l1_reg[592:607];
       38:l1_value_wire<=l1_reg[608:623];
       39:l1_value_wire<=l1_reg[624:639];
       40:l1_value_wire<=l1_reg[640:655];
       41:l1_value_wire<=l1_reg[656:671];
       42:l1_value_wire<=l1_reg[672:687];
       43:l1_value_wire<=l1_reg[688:703];
       44:l1_value_wire<=l1_reg[704:719];
       45:l1_value_wire<=l1_reg[720:735];
       46:l1_value_wire<=l1_reg[736:751];
       47:l1_value_wire<=l1_reg[752:767];
       48:l1_value_wire<=l1_reg[768:783];
       49:l1_value_wire<=l1_reg[784:799];
       50:l1_value_wire<=l1_reg[800:815];
       51:l1_value_wire<=l1_reg[816:831];
       52:l1_value_wire<=l1_reg[832:847];
       53:l1_value_wire<=l1_reg[848:863];
       54:l1_value_wire<=l1_reg[864:879];
       55:l1_value_wire<=l1_reg[880:895];
       endcase
       l1_fetched<=1;
    end
    else
    l1_fetched<=0;
end

endmodule
