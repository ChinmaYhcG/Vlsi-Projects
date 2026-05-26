module AND_gate_tb;
    reg a, b;
    wire out;
    
    AND_gate uut(.a(a), .b(b), .out(out));
    
    initial begin
        $dumpfile("AND_wave.vcd");
        $dumpvars(0, AND_gate_tb);
        
        a=0; b=0; #10;
        a=0; b=1; #10;
        a=1; b=0; #10;
        a=1; b=1; #10;
        
        $finish;
    end
    
    initial begin
        $monitor("t=%0t | a=%b b=%b | out=%b", $time, a, b, out);
    end
endmodule