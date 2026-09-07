`timescale 1ns / 1ps
module receiver_edge_tb;

    reg clk;
    reg rst_n;
    reg rx;

    wire rx_enb;
    wire tx_enb;      // unused output of baud_gen, just needs a wire
    wire rx_reset_w;
    wire [7:0] data_out;
    wire data_valid;
    wire frame_err;
    wire busy;

    baud_rate_generator baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .rx_reset(rx_reset_w),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

    receiver rx_mod (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .rx_enb(rx_enb),
        .rx_reset(rx_reset_w),
        .data_out(data_out),
        .data_valid(data_valid),
        .frame_err(frame_err),
        .busy(busy)
    );

    always #5 clk = ~clk;

    integer errors;
    integer i;

    // Bit period in clk cycles = 16 (oversample) * 326 (rx_count period) clk ticks
    // per rx_enb pulse, so one full UART bit = 16 rx_enb pulses.
    // Easiest to just drive rx and wait for a fixed number of clk cycles per bit,
    // matching what the real baud_gen actually produces: 326 clk cycles per rx_enb.
    localparam integer CLKS_PER_ENB = 326;
    localparam integer BIT_CLKS     = CLKS_PER_ENB * 16;

    task drive_bit(input bit_val);
        begin
            rx = bit_val;
            repeat (BIT_CLKS) @(posedge clk);
        end
    endtask

    // Sends a full 10-bit UART frame (start + 8 data bits LSB-first + stop),
    // but lets the caller override the stop bit to force a framing error.
    task send_frame(input [7:0] byte_val, input stop_bit_val);
        integer b;
        begin
            drive_bit(1'b0);                 // start bit
            for (b = 0; b < 8; b = b + 1)
                drive_bit(byte_val[b]);       // data bits, LSB first
            drive_bit(stop_bit_val);          // stop bit (1 = valid, 0 = forced error)
        end
    endtask

    initial begin
        clk   = 0;
        rst_n = 0;
        rx    = 1'b1;   // idle high
        errors = 0;

        $dumpfile("receiver_edge_tb.vcd");
        $dumpvars(0, receiver_edge_tb);

        #100;
        rst_n = 1'b1;
        #100;

        // ---- Test 1: valid frame, confirm no false frame_err ----
        fork
            send_frame(8'hA5, 1'b1);
            begin
                @(posedge data_valid);
                if (frame_err) begin
                    $display("FAIL | Test 1: frame_err asserted on a VALID frame");
                    errors = errors + 1;
                end else if (data_out !== 8'hA5) begin
                    $display("FAIL | Test 1: expected a5, got %h", data_out);
                    errors = errors + 1;
                end else begin
                    $display("PASS | Test 1: valid frame received correctly, no false frame_err");
                end
            end
        join

        repeat(5) @(posedge rx_enb);

        // ---- Test 2: deliberately bad stop bit, confirm frame_err DOES fire ----
        fork
            send_frame(8'h3C, 1'b0);   // stop bit forced low = invalid
            begin
                @(posedge frame_err);
                $display("PASS | Test 2: frame_err correctly asserted on a corrupted stop bit");
            end
        join_any
        disable fork;

        if (!frame_err) begin
            $display("FAIL | Test 2: frame_err never asserted on a corrupted stop bit");
            errors = errors + 1;
        end

        repeat(5) @(posedge rx_enb);

        $display("========================================");
        if (errors == 0)
            $display("ALL EDGE-CASE TESTS PASSED (frame_err coverage only - see receiver_backtoback_tb.v for stress test)");
        else
            $display("%0d EDGE-CASE TEST(S) FAILED", errors);
        $display("========================================");
        $finish;
    end

endmodule

