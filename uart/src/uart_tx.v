module uart_tx #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
) (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx_busy,
    output reg        tx
);

    localparam COUNTER_MAX = CLK_FREQ / BAUD_RATE;
    localparam COUNTER_WIDTH = $clog2(COUNTER_MAX + 1);

    reg [COUNTER_WIDTH-1:0] baud_counter;
    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg sending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            sending <= 1'b0;
            baud_counter <= 0;
            bit_index <= 0;
            shift_reg <= 10'b1111111111;
        end else if (tx_start && !tx_busy) begin
            shift_reg <= {1'b1, tx_data, 1'b0};
            bit_index <= 0;
            baud_counter <= 0;
            sending <= 1'b1;
            tx_busy <= 1'b1;
            tx <= 1'b1;
        end else if (sending) begin
            if (baud_counter == COUNTER_MAX - 1) begin
                baud_counter <= 0;
                if (bit_index == 9) begin
                    sending <= 1'b0;
                    tx_busy <= 1'b0;
                    tx <= 1'b1;
                end else begin
                    bit_index <= bit_index + 1;
                    tx <= shift_reg[bit_index];
                end
            end else begin
                baud_counter <= baud_counter + 1;
            end
        end
    end
endmodule
