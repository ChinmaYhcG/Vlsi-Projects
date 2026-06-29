`timescale 1ns / 1ps

module mealy_fsm_tb;

  reg clk;
  reg rst_n;
  reg go;
  reg ws;
  
  wire ds;
  wire rd;

  mealy_fsm uut (
    .ds(ds), 
    .rd(rd), 
    .go(go), 
    .ws(ws), 
    .clk(clk), 
    .rst_n(rst_n)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("mealy_fsm_tb.vcd");
    $dumpvars(0, mealy_fsm_tb);
  end

  initial begin
    clk = 0;
    rst_n = 0;
    go = 0;
    ws = 0;

    #15 rst_n = 1; 
    
    @(negedge clk);
    
    $display("Test Case 1: Basic Path");
    go = 1; 
    
    @(negedge clk);
    go = 0;  
    
    @(negedge clk); 
    
    @(negedge clk); 
    
    #10;
    
    $display("Test Case 2: Wait State Path");
    @(negedge clk);
    go = 1;
    
    @(negedge clk);
    go = 0;
    
    @(negedge clk);
    ws = 1;
    
    @(negedge clk);
    ws = 0;
    
    @(negedge clk);
    
    @(negedge clk);
    
    #20;
    $display("Simulation complete.");
    $finish;
  end

  initial begin
    $monitor("Time=%0t | clk=%b | rst_n=%b | go=%b | ws=%b || OUTPUTS: rd=%b | ds=%b", 
             $time, clk, rst_n, go, ws, rd, ds);
  end

endmodule