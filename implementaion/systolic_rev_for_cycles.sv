`timescale 1ns/1ps

module systolic_array (
    input wire clk,
    input wire reset,
    input wire [7:0] activation_stream [0:8], // 3x3 image 
    input wire [7:0] weight_stream [0:3],    // 2x2 kernel
    output reg [31:0] result [0:3]           // 2x2 output
);

    
    reg [7:0] activation [0:2][0:2]; 
    reg [7:0] weight [0:1][0:1];  
    reg [31:0] partial_sum [0:1][0:1]; 

    integer i, j;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 0; j < 2; j = j + 1) begin
                    partial_sum[i][j] <= 0;
                end
            end
        end else begin
            
            activation[0][0] <= activation_stream[0];
            activation[0][1] <= activation_stream[1];
            activation[0][2] <= activation_stream[2];
            activation[1][0] <= activation_stream[3];
            activation[1][1] <= activation_stream[4];
            activation[1][2] <= activation_stream[5];
            activation[2][0] <= activation_stream[6];
            activation[2][1] <= activation_stream[7];
            activation[2][2] <= activation_stream[8];

           
            weight[0][0] <= weight_stream[0];
            weight[0][1] <= weight_stream[1];
            weight[1][0] <= weight_stream[2];
            weight[1][1] <= weight_stream[3];
        end
    end

   
    always @(posedge clk) begin
        if (!reset) begin
            
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 0; j < 2; j = j + 1) begin
                    partial_sum[i][j] <= 
                        (activation[i][j]   * weight[0][0]) +
                        (activation[i][j+1] * weight[0][1]) +
                        (activation[i+1][j] * weight[1][0]) +
                        (activation[i+1][j+1] * weight[1][1]);
                end
            end

            
            result[0] <= partial_sum[0][0];
            result[1] <= partial_sum[0][1];
            result[2] <= partial_sum[1][0];
            result[3] <= partial_sum[1][1];
        end
    end

endmodule
