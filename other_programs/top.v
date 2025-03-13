module top (
    input wire clk,        
    input wire reset,        
    input wire uart_rx,      
    output wire uart_tx,     
    output reg led_red,     
    output reg led_blue,    
    output reg led_green     
);

    
    wire [7:0] uart_rx_data;
    wire uart_rx_ready;
    reg [7:0] uart_tx_data;
    reg uart_tx_start;
    
    
    reg [1:0] input_phase; 
    reg [31:0] activation_stream;
    reg [31:0] weight_stream;    
    wire [15:0] final_result_0, final_result_1;

    
    uart_rx uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(uart_rx),
        .data(uart_rx_data),
        .ready(uart_rx_ready)
    );

   
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .data(uart_tx_data),
        .start(uart_tx_start),
        .tx(uart_tx)
    );

    
    systolic_array systolic_array_inst (
        .clk(clk),
        .reset(reset),
        .activation_stream(activation_stream),
        .weight_stream(weight_stream),
        .final_result_0(final_result_0),
        .final_result_1(final_result_1)
    );

    always @(posedge clk) begin
        if (reset) begin
            input_phase <= 0;
            activation_stream <= 0;
            weight_stream <= 0;
            led_red <= 0;
            led_blue <= 0;
            led_green <= 0;
        end else if (uart_rx_ready) begin
            case (input_phase)
                0: begin 
                    activation_stream <= {activation_stream[23:0], uart_rx_data};
                    led_red <= 1;
                    led_blue <= 0;
                    led_green <= 0;
                    if (&activation_stream[31:8]) input_phase <= 1;
                end
                1: begin 
                    weight_stream <= {weight_stream[23:0], uart_rx_data};
                    led_red <= 0;
                    led_blue <= 1;
                    led_green <= 0;
                    if (&weight_stream[31:8]) input_phase <= 2;
                end
                2: begin 
                    led_red <= 0;
                    led_blue <= 0;
                    led_green <= 1;
                    uart_tx_data <= final_result_0[7:0]; 
                    uart_tx_start <= 1;
                    input_phase <= 0;
                end
            endcase
        end
    end
endmodule

