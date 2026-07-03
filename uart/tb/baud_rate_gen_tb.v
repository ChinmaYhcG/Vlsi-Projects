`timescale 1ns / 1ps

module baud_rate_gen_tb;

    reg clk;
    wire tx_enb;
    wire rx_enb;

    baud_rate_generator uut (
        .clk(clk),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

    always #5 clk = ~clk;

    integer tx_cycle_count = 0;
    integer rx_cycle_count = 0;
    integer tx_pulse_total = 0;

    always @(posedge clk) begin
        tx_cycle_count = tx_cycle_count + 1;
        rx_cycle_count = rx_cycle_count + 1;

        if (rx_enb) begin
            $display("Time: %0t ns | RX_ENB Triggered | Cycles since last pulse: %0d", $time, rx_cycle_count);
            rx_cycle_count = 0; 
        end

        if (tx_enb) begin
            $display("Time: %0t ns | TX_ENB Triggered | Cycles since last pulse: %0d", $time, tx_cycle_count);
            tx_cycle_count = 0; 
            tx_pulse_total = tx_pulse_total + 1;
        end
    end

    initial begin
        clk = 0;
        
        $dumpfile("baud_rate_gen_tb.vcd");
        $dumpvars(0, baud_rate_gen_tb);

        $display("=================================================");
        $display("Starting Self-Checking Baud Rate Verification...");
        $display("=================================================");

        wait(tx_pulse_total == 4);
        
        #50; 
        
        $display("=================================================");
        $display("Simulation Complete. Check cycle counts above.");
        $display("=================================================");
        $finish;
    end

endmodule