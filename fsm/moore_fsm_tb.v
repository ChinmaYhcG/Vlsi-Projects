module moore_fsm_tb;
 reg clk;
 reg rst_n;
 reg go;
 reg ws;

 wire ds;
 wire rd;

 moore_fsm uut(.ds(ds), .rd(rd), .go(go), .ws(ws), .clk(clk), .rst_n(rst_n));
 always #5 clk = ~clk;
 initial begin 
     $dumpfile("moore_fsm.vcd");
    $dumpvars(0, moore_fsm_tb);
 clk =0;
 rst_n = 0;
 go = 0;
 ws = 0;

 #15 rst_n =1;
 #10;
 $display("Starting Test Case 1: Basic Path (ws=0)");
 go = 1;
 #10 go =0;
 #40;
 $display("Starting Test Case 2: Wait State Path (ws=1 then ws=0)");
 go =1;
 #10 go = 0;
 #10;
 ws = 1;
 #10;
 ws = 0;
 #40;
 $display("Simulation complete.");
 $finish;
 end
 initial begin 
 $monitor("Time=%0t | rst_n=%b | go=%b | ws=%b || OUTPUTS: rd=%b |ds=%b",$time, rst_n, go, ws, rd, ds);
 end 
 endmodule