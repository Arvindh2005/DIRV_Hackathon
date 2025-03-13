`timescale 1ns/1ps

module testbench;
    reg clk;
    reg reset;
    reg [7:0] activation_stream [0:8]; // 3x3 input
    reg [7:0] weight_stream [0:3];    // 2x2 kernel
    wire [31:0] result [0:3];         // 2x2 output

    
    systolic_array dut (
        .clk(clk),
        .reset(reset),
        .activation_stream(activation_stream),
        .weight_stream(weight_stream),
        .result(result)
    );

    // Generate a 12 MHz clock ....Period = 83.33 ns .... Half-cycle = 41.67 ns)
    always #41.67 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;


        #100;
        reset = 0;

       
        activation_stream[0] = 8'd1;
        activation_stream[1] = 8'd2;
        activation_stream[2] = 8'd3;
        activation_stream[3] = 8'd4;
        activation_stream[4] = 8'd5;
        activation_stream[5] = 8'd6;
        activation_stream[6] = 8'd7;
        activation_stream[7] = 8'd8;
        activation_stream[8] = 8'd9;

        weight_stream[0] = 8'd1;
        weight_stream[1] = 8'd1;
        weight_stream[2] = 8'd1;
        weight_stream[3] = 8'd1;

        #500;
        $finish;
    end
endmodule
