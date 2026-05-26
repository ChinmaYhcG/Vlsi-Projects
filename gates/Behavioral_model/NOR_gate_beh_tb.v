module NOR_gate_beh_tb;
    reg a, b;
    wire y;
    
    NOR_gate_beh uut(.a(a), .b(b), .y(y));
    
    initial begin
        $dumpfile("NOR_beh_wave.vcd");
        $dumpvars(0, NOR_gate_beh_tb);
        
        a=0; b=0; #10;
        a=0; b=1; #10;
        a=1; b=0; #10;
        a=1; b=1; #10;
        
        $finish;
    end
    
    initial begin
        $monitor("t=%0t | a=%b b=%b | y=%b", $time, a, b, y);
    end
endmodule