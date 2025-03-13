module uart_rx (
    input wire clk,          
    input wire reset,        
    input wire rx,           
    output reg [7:0] data,   
    output reg ready        
);

    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 12_000_000; 
    parameter SAMPLE_COUNT = CLOCK_FREQ / BAUD_RATE;

    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg [15:0] counter;
    reg sampling;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ready <= 0;
            sampling <= 0;
            bit_count <= 0;
            counter <= 0;
        end else begin
            if (!sampling && !rx) begin
                sampling <= 1;
                counter <= SAMPLE_COUNT / 2; 
                bit_count <= 0;
            end else if (sampling) begin
                counter <= counter - 1;
                if (counter == 0) begin
                    counter <= SAMPLE_COUNT;
                    if (bit_count < 8) begin
                        shift_reg[bit_count] <= rx;
                        bit_count <= bit_count + 1;
                    end else if (bit_count == 8) begin
                        ready <= 1;
                        data <= shift_reg;
                        sampling <= 0;
                    end
                end
            end else begin
                ready <= 0;
            end
        end
    end
endmodule

