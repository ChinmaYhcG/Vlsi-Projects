`timescale 1ns / 1ps

module top_integration_tb;
    reg clk;
    reg wr_enb;
    reg rst_n;
    reg [7:0] data_in;
    
    wire tx_enb;
    wire rx_enb;
    wire tx;
    wire busy;
    
    baud_rate_generator baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .rx_reset(1'b0),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );
    
    transmitter tx_mod (
        .clk(clk),
        .wr_enb(wr_enb),
        .rst_n(rst_n),
        .tx_enb(tx_enb),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );
    
    always #5 clk = ~clk;
    
    reg [7:0] expected_data;
    reg [7:0] rx_shift_reg;
    reg rx_active;
    integer bit_idx;
    integer err_count;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            rx_active <= 0;
            bit_idx <= 0;
            err_count <= 0;
        end else if (tx_enb) begin
            if (!rx_active && tx == 1'b0) begin
                rx_active <= 1;
                bit_idx <= 0;
            end else if (rx_active) begin
                if (bit_idx < 8) begin
                    rx_shift_reg[bit_idx] <= tx;
                    bit_idx <= bit_idx + 1;
                end else begin
                    if (tx == 1'b1) begin
                        if (rx_shift_reg == expected_data)
                            $display("PASS | Time: %0t ns | Expected: %h, Received: %h", $time, expected_data, rx_shift_reg);
                        else begin
                            $display("FAIL | Time: %0t ns | Expected: %h, Received: %h", $time, expected_data, rx_shift_reg);
                            err_count <= err_count + 1;
                        end
                    end else begin
                        $display("FAIL | Time: %0t ns | Missing Stop Bit! Received data: %h", $time, rx_shift_reg);
                        err_count <= err_count + 1;
                    end
                    rx_active <= 0;
                end
            end
        end
    end
    
    initial begin
        clk = 0;
        wr_enb = 0;
        rst_n = 0;
        data_in = 8'h00;
        expected_data = 8'h00;
        
        $dumpfile("integration_tb.vcd");
        $dumpvars(0, top_integration_tb);
        
        #100;
        rst_n = 1;
        #100;
        
        @(posedge clk);
        data_in = 8'hA5;
        expected_data = 8'hA5;
        wr_enb = 1;
        @(posedge clk);
        wr_enb = 0;
        
        wait(busy == 1'b1);
        wait(busy == 1'b0);
        
        repeat(5) @(posedge tx_enb);
        
        @(posedge clk);
        data_in = 8'h3C;
        expected_data = 8'h3C;
        wr_enb = 1;
        @(posedge clk);
        wr_enb = 0;
        
        wait(busy == 1'b1);
        wait(busy == 1'b0);
        
        repeat(5) @(posedge tx_enb);
        
        @(posedge clk);
        data_in = 8'h00;
        expected_data = 8'h00;
        wr_enb = 1;
        @(posedge clk);
        wr_enb = 0;
        
        wait(busy == 1'b1);
        wait(busy == 1'b0);
        
        repeat(5) @(posedge tx_enb);
        
        @(posedge clk);
        data_in = 8'hFF;
        expected_data = 8'hFF;
        wr_enb = 1;
        @(posedge clk);
        wr_enb = 0;
        
        wait(busy == 1'b1);
        wait(busy == 1'b0);
        
        repeat(5) @(posedge tx_enb);
        
        $display("========================================");
        $display("Integration Test Complete. Errors: %0d", err_count);
        $display("========================================");
        $finish;
    end
endmodule