module conv2d_systolic (
    input clk,
    input reset,
    output reg [7:0] output_data, 
    output reg LED_RED,    // Red LED for image 
    output reg LED_BLUE,   // Blue LED for kernel 
    output reg LED_GREEN   // Green LED for output
);

    // parameters
    parameter NUM_ROWS = 4;
    parameter NUM_COLS = 4;
    parameter NUM_PE = NUM_ROWS * NUM_COLS;

    // Statess
    reg [1:0] state;
    parameter INPUT = 2'b00;
    parameter KERNEL = 2'b01;
    parameter OUTPUT = 2'b10;

    // predefined image and kernel
    reg [7:0] image_reg [0:NUM_ROWS-1]; 
    reg [7:0] kernel_reg [0:NUM_ROWS-1]; 
    reg [7:0] result_reg [0:NUM_ROWS-1]; 

    
    task pe_multiply_accumulate;
        input [7:0] activation_in;
        input [7:0] weight_in;
        input [31:0] partial_sum_in;
        output [31:0] output_result;
        output [7:0] activation_out_result;
        output [31:0] partial_sum_out_result;
        begin
            output_result = activation_in * weight_in + partial_sum_in;
            activation_out_result = activation_in >> 1; 
            partial_sum_out_result = output_result;
        end
    endtask

    
    integer i, j;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= INPUT;
            LED_RED <= 1;
            LED_BLUE <= 0;
            LED_GREEN <= 0;
            output_data <= 8'b0; 
           
            for (i = 0; i < NUM_ROWS; i = i + 1) begin
                image_reg[i] <= 8'b0;
                kernel_reg[i] <= 8'b0;
                result_reg[i] <= 8'b0;
            end
        end else begin
            case(state)
                INPUT: begin
                    LED_RED <= 1;   // Red LED for image input stage
                    LED_BLUE <= 0;
                    LED_GREEN <= 0;
                    
                    image_reg[0] <= 8'b00000001; 
                    image_reg[1] <= 8'b00000010;
                    image_reg[2] <= 8'b00000011;
                    image_reg[3] <= 8'b00000100;
                    state <= KERNEL; 
                end

                KERNEL: begin
                    LED_RED <= 0;
                    LED_BLUE <= 1; // now blue
                    LED_GREEN <= 0;
                    
                    kernel_reg[0] <= 8'b00000001;
                    kernel_reg[1] <= 8'b00000010;
                    kernel_reg[2] <= 8'b00000011;
                    kernel_reg[3] <= 8'b00000100;
                    state <= OUTPUT; l
                end

                OUTPUT: begin
                    LED_RED <= 0;
                    LED_BLUE <= 0;
                    LED_GREEN <= 1; 
                    
                    for (i = 0; i < NUM_ROWS; i = i + 1) begin
                       
                        if (i == 0)
                            result_reg[i] <= 8'b0;
                        else
                            result_reg[i] <= result_reg[i - 1];

                        
                        pe_multiply_accumulate(
                            image_reg[i], kernel_reg[i], result_reg[i], 
                            result_reg[i], result_reg[i], result_reg[i]
                        );
                    end
                    
                    output_data <= result_reg[0] + result_reg[1] + result_reg[2] + result_reg[3];
                    state <= INPUT; 
                end
            endcase
        end
    end
endmodule

