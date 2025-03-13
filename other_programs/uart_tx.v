module uart_tx (
    input wire clk,          
    input wire reset,        
    input wire [7:0] data,   
    input wire start,       
    output reg tx            
);

    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 12_000_000;  
    parameter SAMPLE_COUNT = CLOCK_FREQ / BAUD_RATE;

    reg [9:0] shift_reg;
    reg [3:0] bit_count;
    reg [15:0] counter;
    reg sending;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sending <= 0;
            tx <= 1;  
            bit_count <= 0;
            counter <= 0;
        end else begin
            if (start && !sending) begin
                shift_reg <= {1'b1, data, 1'b0}; 
                sending <= 1;
                bit_count <= 0;
                counter <= SAMPLE_COUNT;
            end else if (sending) begin
                counter <= counter - 1;
                if (counter == 0) begin
                    counter <= SAMPLE_COUNT;
                    tx <= shift_reg[bit_count];
                    bit_count <= bit_count + 1;
                    if (bit_count == 9) begin
                        sending <= 0;
                    end
                end
            end
        end
    end
endmodule

