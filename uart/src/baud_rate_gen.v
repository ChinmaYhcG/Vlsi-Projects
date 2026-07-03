module baud_rate_generator #(
    parameter integer CLK_FREQ = 100000000,
    parameter integer BAUD_RATE = 9600
) (
    input  wire clk,
    output reg  tx_enb,
    output reg  rx_enb
);

    localparam integer DIVISOR = CLK_FREQ / BAUD_RATE;
    localparam integer COUNTER_WIDTH = $clog2(DIVISOR);
    reg [COUNTER_WIDTH-1:0] counter;

    initial begin
        counter = 0;
        tx_enb = 1'b0;
        rx_enb = 1'b0;
    end

    always @(posedge clk) begin
        if (counter == DIVISOR - 1) begin
            counter <= 0;
            tx_enb <= 1'b1;
            rx_enb <= 1'b1;
        end else begin
            counter <= counter + 1;
            tx_enb <= 1'b0;
            rx_enb <= 1'b0;
        end
    end
endmodule
