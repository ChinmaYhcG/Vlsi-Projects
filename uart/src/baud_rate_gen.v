`timescale 1ns / 1ps
module baud_rate_generator(
    input  clk,
    input  rst_n,
    input  rx_reset,
    output tx_enb,
    output rx_enb
);

    reg [12:0] tx_count;
    reg [9:0]  rx_count;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx_count <= 0;
        else if (tx_count == 5207)
            tx_count <= 0;
        else
            tx_count <= tx_count + 1'b1;
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)
            rx_count <= 0;
        else if (rx_reset)
            rx_count <= 0;
        else if (rx_count == 325)
            rx_count <= 0;
        else
            rx_count <= rx_count + 1'b1;
    end

    assign tx_enb = (tx_count == 0) ? 1'b1 : 1'b0;
    assign rx_enb = (rx_count == 0) ? 1'b1 : 1'b0;

endmodule