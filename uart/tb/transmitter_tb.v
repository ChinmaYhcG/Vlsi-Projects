`timescale 1ns / 1ps
module transmitter_tb;
    reg clk;
    reg wr_enb;
    reg rst_n;
    reg tx_enb;
    reg [7:0] data_in;
    wire tx;
    wire busy;

    transmitter uut (
        .clk(clk),
        .wr_enb(wr_enb),
        .rst_n(rst_n),
        .tx_enb(tx_enb),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    always #5 clk = ~clk;

    // Stub baud enable - fires every 10 clk cycles, standing in for the
    // real baud_rate_generator until full-system integration.
    reg [3:0] baud_counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            baud_counter <= 0;
            tx_enb <= 0;
        end else begin
            if (baud_counter == 9) begin
                baud_counter <= 0;
                tx_enb <= 1'b1;
            end else begin
                baud_counter <= baud_counter + 1;
                tx_enb <= 1'b0;
            end
        end
    end

    // ---- Self-checking machinery ----
    reg [7:0] expected_data;
    reg [7:0] captured_data;
    integer errors;

    task send_and_check(input [7:0] test_byte);
        integer i;
        begin
            expected_data = test_byte;
            captured_data = 8'h00;

            @(posedge clk);
            data_in = test_byte;
            wr_enb  = 1;
            @(posedge clk);
            wr_enb  = 0;

            // Wait until the FSM has entered data_state.
            wait (uut.state == uut.data_state);

            // The very next tx_enb pulse still shows the START bit on tx
            @(posedge clk);
            while (!tx_enb) @(posedge clk);

            // Now capture exactly 8 tx_enb pulses
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                while (!tx_enb) @(posedge clk);
                captured_data[i] = tx;
            end

            wait (busy == 1'b0);

            if (captured_data !== expected_data) begin
                $display("FAIL: sent %h, transmitter shifted out %h", expected_data, captured_data);
                errors = errors + 1;
            end else begin
                $display("PASS: %h transmitted and reconstructed correctly", expected_data);
            end

            #50;
        end
    endtask

    initial begin
        clk = 0;
        wr_enb = 0;
        rst_n = 0;
        data_in = 8'h00;
        errors = 0;

        $dumpfile("transmitter_tb.vcd");
        $dumpvars(0, transmitter_tb);

        #20;
        rst_n = 1;
        #20;

        send_and_check(8'hA5);
        send_and_check(8'h3C);
        send_and_check(8'h00);
        send_and_check(8'hFF);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end
endmodule
