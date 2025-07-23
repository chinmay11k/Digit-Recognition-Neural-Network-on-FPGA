module max_find (
    input  wire        en,            // Enable signal
    input  wire [0:159] in,           // 10 signed 16-bit values packed
    output reg  [3:0]  max_index      // Index of the max value
);
    integer i;
    reg signed [15:0] current_val;
    reg signed [15:0] max_val;

    always @(*) begin
        if (en) begin
            max_val = in[159 -: 16];
            max_index = 0;

            for (i = 1; i < 10; i = i + 1) begin
                current_val = in[i+:16];
                if (current_val > max_val) begin
                    max_val = current_val;
                    max_index = i[3:0];
                end
            end
        end
    end
endmodule
