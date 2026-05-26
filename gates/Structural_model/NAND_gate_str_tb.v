module NAND_gate_str_tb;
    reg a, b;
    wire y;
    NAND_gate_str uut(.a(a), .b(b), .y(y));
    initial begin
        $dumpfile("NAND_str_wave.vcd");
        $dumpvars(0, NAND_gate_str_tb);
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