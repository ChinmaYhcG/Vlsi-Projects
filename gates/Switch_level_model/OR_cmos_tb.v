module OR_cmos_tb;
    reg a, b;
    wire y;
    OR_cmos uut(.a(a), .b(b), .y(y));
    initial begin
        $dumpfile("OR_cmos_wave.vcd");
        $dumpvars(0, OR_cmos_tb);
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