`timescale 1ns / 1ps
module receiver_backtoback_tb;

    reg clk;
    reg wr_enb;
    reg rst_n;
    reg [7:0] data_in;

    wire tx_enb;
    wire rx_enb;
    wire tx;
    wire busy;

    wire rx_reset_w;
    wire [7:0] data_out;
    wire data_valid;
    wire frame_err;
    wire rx_busy;

    baud_rate_generator baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .rx_reset(rx_reset_w),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

    transmitter tx_mod (
        .clk(clk),
        .rst_n(rst_n),
        .wr_enb(wr_enb),
        .tx_enb(tx_enb),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    receiver rx_mod (
        .clk(clk),
        .rst_n(rst_n),
        .rx(tx),
        .rx_enb(rx_enb),
        .rx_reset(rx_reset_w),
        .data_out(data_out),
        .data_valid(data_valid),
        .frame_err(frame_err),
        .busy(rx_busy)
    );

    always #5 clk = ~clk;

    reg [7:0] expected_queue [0:7];
    integer expected_head, expected_tail;
    integer pass_count, fail_count;

    always @(posedge clk) begin
        if (data_valid) begin
            if (data_out == expected_queue[expected_head]) begin
                $display("PASS | Time: %0t ns | Expected: %h, Received: %h",
                          $time, expected_queue[expected_head], data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Time: %0t ns | Expected: %h, Received: %h",
                          $time, expected_queue[expected_head], data_out);
                fail_count = fail_count + 1;
            end
            expected_head = expected_head + 1;
        end
        if (frame_err) begin
            $display("FAIL | Time: %0t ns | Unexpected framing error, data_out was: %h", $time, data_out);
            fail_count = fail_count + 1;
        end
    end

    // Fires wr_enb the INSTANT busy drops, i.e. as soon as the transmitter
    // is free again - no repeat(N) @(posedge tx_enb) gap like the original
    // loopback testbench. This is the actual back-to-back stress case.
    task send_immediately(input [7:0] byte_val);
        begin
            @(posedge clk);
            data_in = byte_val;
            expected_queue[expected_tail] = byte_val;
            expected_tail = expected_tail + 1;
            wr_enb = 1;
            @(posedge clk);
            wr_enb = 0;
            wait (busy == 1'b1);
            wait (busy == 1'b0);
            // no gap here - immediately queue the next byte
        end
    endtask

    initial begin
        clk = 0;
        wr_enb = 0;
        rst_n = 0;
        data_in = 8'h00;
        expected_head = 0;
        expected_tail = 0;
        pass_count = 0;
        fail_count = 0;

        $dumpfile("receiver_backtoback_tb.vcd");
        $dumpvars(0, receiver_backtoback_tb);

        #100;
        rst_n = 1;
        #100;

        // Five bytes back-to-back, zero idle gap between any of them.
        send_immediately(8'h11);
        send_immediately(8'h22);
        send_immediately(8'h33);
        send_immediately(8'h44);
        send_immediately(8'h55);

        // give the receiver time to finish the last frame's stop bit
        repeat(20) @(posedge rx_enb);

        $display("========================================");
        $display("Back-to-back Stress Test Complete. Pass: %0d Fail: %0d", pass_count, fail_count);
        $display("========================================");
        $finish;
    end

endmodule
