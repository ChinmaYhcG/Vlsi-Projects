module NAND_gate_beh_tb;
    reg a, b;
    wire y;
    
    NAND_gate_beh uut(.a(a), .b(b), .y(y));
    
    initial begin
        $dumpfile("NAND_wave.vcd");
        $dumpvars(0, NAND_gate_beh_tb);
        
        a=0; b=0; #10;
        a=0; b=1; #10;
        a=1; b=0; #10;
        a=1; b=1; #10;
        
        $finish;
    end
    
    initial begin
        $monitor("t=%0t | a=%b b=%b | out=%b", $time, a, b, y);
    end
endmodule
