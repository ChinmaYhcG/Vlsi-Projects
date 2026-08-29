`timescale 1ns / 1ps
module receiver(
    input  clk,
    input  rst_n,
    input  rx,              // serial line, idles high (matches transmitter's tx)
    input  rx_enb,           // 16x oversample tick from baud_rate_generator
    output reg rx_reset,     // drive into baud_rate_generator.rx_reset to resync on start bit
    output reg [7:0] data_out,
    output reg data_valid,   // 1-cycle pulse when a byte is ready
    output reg frame_err,    // stop bit was not 1 -> framing error
    output busy
);

    parameter idle_state  = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state  = 2'b10;
    parameter stop_state  = 2'b11;

    localparam SAMPLE_HALF = 4'd8;   // half bit period: verify start bit at its midpoint
    localparam SAMPLE_FULL = 4'd15;  // full bit period: sample each subsequent bit at its midpoint

    reg [1:0] state;
    reg [3:0] os_cnt;     // counts rx_enb pulses within the current bit window
    reg [2:0] bit_idx;
    reg [7:0] shift_reg;

    // 2-flop synchronizer + edge detect on the async rx pin
    reg rx_meta, rx_sync, rx_sync_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_meta   <= 1'b1;
            rx_sync   <= 1'b1;
            rx_sync_d <= 1'b1;
        end else begin
            rx_meta   <= rx;
            rx_sync   <= rx_meta;
            rx_sync_d <= rx_sync;
        end
    end
    wire start_edge = rx_sync_d & ~rx_sync; // falling edge: idle(1) -> start(0)

    assign busy = (state != idle_state);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= idle_state;
            os_cnt    <= 4'h0;
            bit_idx   <= 3'h0;
            shift_reg <= 8'h00;
            data_out  <= 8'h00;
            data_valid<= 1'b0;
            frame_err <= 1'b0;
            rx_reset  <= 1'b0;
        end else begin
            // defaults, overridden below where needed
            data_valid <= 1'b0;
            rx_reset   <= 1'b0;

            case (state)
                idle_state: begin
                    if (start_edge) begin
                        state    <= start_state;
                        rx_reset <= 1'b1;   // resync baud_rate_generator's rx_count to this edge
                        os_cnt   <= 4'h0;
                    end
                end

                start_state: begin
                    if (rx_enb) begin
                        if (os_cnt == SAMPLE_HALF) begin
                            if (rx_sync == 1'b0) begin
                                // still low at the midpoint -> genuine start bit
                                state   <= data_state;
                                os_cnt  <= 4'h0;
                                bit_idx <= 3'h0;
                            end else begin
                                // glitch, not a real start bit
                                state <= idle_state;
                            end
                        end else begin
                            os_cnt <= os_cnt + 4'h1;
                        end
                    end
                end

                data_state: begin
                    if (rx_enb) begin
                        if (os_cnt == SAMPLE_FULL) begin
                            shift_reg[bit_idx] <= rx_sync; // LSB first, matches transmitter
                            os_cnt <= 4'h0;
                            if (bit_idx == 3'h7)
                                state <= stop_state;
                            else
                                bit_idx <= bit_idx + 3'h1;
                        end else begin
                            os_cnt <= os_cnt + 4'h1;
                        end
                    end
                end

                stop_state: begin
                    if (rx_enb) begin
                        if (os_cnt == SAMPLE_FULL) begin
                            if (rx_sync == 1'b1) begin
                                data_out   <= shift_reg;
                                data_valid <= 1'b1;
                                frame_err  <= 1'b0;
                            end else begin
                                frame_err <= 1'b1; // stop bit missing
                            end
                            state <= idle_state;
                        end else begin
                            os_cnt <= os_cnt + 4'h1;
                        end
                    end
                end

                default: begin
                    state <= idle_state;
                end
            endcase
        end
    end

endmodule