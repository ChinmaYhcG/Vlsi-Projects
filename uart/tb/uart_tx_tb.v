module uart_tx_tb;
    reg clk = 0;
    reg rst_n = 0;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'h41;
    wire tx_busy;
    wire tx;

    always #5 clk = ~clk;

    initial begin
        #20 rst_n = 1;
        #50 tx_start = 1;
        tx_data = 8'h5A;
        #10 tx_start = 0;
        #200000 $finish;
    end

    initial begin
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);
    end

    uart_tx uut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_busy(tx_busy),
        .tx(tx)
    );
endmodule
