`timescale 1ns / 1ps
module receiver_tb;

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
        .rx_reset(rx_reset_w),   // driven by receiver, not floating
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
        .rx(tx),                 // loopback: transmitter's line feeds the receiver
        .rx_enb(rx_enb),
        .rx_reset(rx_reset_w),
        .data_out(data_out),
        .data_valid(data_valid),
        .frame_err(frame_err),
        .busy(rx_busy)
    );

    always #5 clk = ~clk;

    reg [7:0] expected_data;
    integer pass_count;
    integer fail_count;

    // Poll every clock rather than blocking-wait on data_valid, since it's
    // a single-cycle reg pulse and a wait() here would be racy against it.
    always @(posedge clk) begin
        if (data_valid) begin
            if (data_out == expected_data) begin
                $display("PASS | Time: %0t ns | Expected: %h, Received: %h", $time, expected_data, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Time: %0t ns | Expected: %h, Received: %h", $time, expected_data, data_out);
                fail_count = fail_count + 1;
            end
        end
        if (frame_err) begin
            $display("FAIL | Time: %0t ns | Framing error (bad stop bit), data_out was: %h", $time, data_out);
            fail_count = fail_count + 1;
        end
    end

    task send_byte(input [7:0] byte_val);
        begin
            @(posedge clk);
            data_in = byte_val;
            expected_data = byte_val;
            wr_enb = 1;
            @(posedge clk);
            wr_enb = 0;

            wait(busy == 1'b1);
            wait(busy == 1'b0);

            // let the receiver finish sampling stop bit + return to idle
            // before the next byte's start edge arrives
            repeat(5) @(posedge tx_enb);
        end
    endtask

    initial begin
        clk = 0;
        wr_enb = 0;
        rst_n = 0;
        data_in = 8'h00;
        expected_data = 8'h00;
        pass_count = 0;
        fail_count = 0;

        $dumpfile("receiver_tb.vcd");
        $dumpvars(0, receiver_tb);

        #100;
        rst_n = 1;
        #100;

        send_byte(8'hA5);
        send_byte(8'h3C);
        send_byte(8'h00);
        send_byte(8'hFF);
        send_byte(8'h55); // alternating bits, worst case for edge/timing bugs

        #200;

        $display("========================================");
        $display("Receiver Test Complete. Pass: %0d Fail: %0d", pass_count, fail_count);
        $display("========================================");
        $finish;
    end

endmodule