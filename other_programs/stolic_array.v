module systolic_array (
    input wire clk,
    input wire reset,
    input wire [31:0] activation_stream,
    input wire [31:0] weight_stream,    
    output reg [15:0] final_result_0,
    output reg [15:0] final_result_1
);

    reg [7:0] activations [0:1][0:1];
    reg [7:0] weights [0:1][0:1];
    reg [15:0] partial_sum [0:1][0:1];

    integer i, j, k;

    
    function [15:0] shift_add_mult;
        input [7:0] a, b;
        integer i;
        begin
            shift_add_mult = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (b[i]) shift_add_mult = shift_add_mult + (a << i);
            end
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 2; i = i + 1)
                for (j = 0; j < 2; j = j + 1)
                    partial_sum[i][j] <= 0;
        end else begin
           
            for (i = 0; i < 2; i = i + 1)
                for (j = 0; j < 2; j = j + 1) begin
                    activations[i][j] <= activation_stream[(i*2 + j) * 8 +: 8];
                    weights[i][j] <= weight_stream[(i*2 + j) * 8 +: 8];
                end

            
            for (i = 0; i < 2; i = i + 1)
                for (j = 0; j < 2; j = j + 1) begin
                    partial_sum[i][j] <= 0;
                    for (k = 0; k < 2; k = k + 1)
                        partial_sum[i][j] <= partial_sum[i][j] + shift_add_mult(activations[i][k], weights[k][j]);
                end

           
            final_result_0 <= partial_sum[0][0] + partial_sum[0][1];
            final_result_1 <= partial_sum[1][0] + partial_sum[1][1];
        end
    end
endmodule

