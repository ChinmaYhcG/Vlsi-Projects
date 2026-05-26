module OR_gate_beh_tb;
    reg a, b;
    wire y;
    
    OR_gate_beh uut(.a(a), .b(b), .y(y));
    
    initial begin
        $dumpfile("OR_wave.vcd");
        $dumpvars(0, OR_gate_beh_tb);
        
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
