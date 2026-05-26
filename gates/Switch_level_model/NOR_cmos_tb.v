module NOR_cmos_tb;
    reg a, b;
    wire y;
    NOR_cmos uut(.a(a), .b(b), .y(y));
    initial begin
        $dumpfile("NOR_cmos_wave.vcd");
        $dumpvars(0, NOR_cmos_tb);
        $monitor("t=%0t | a=%b b=%b | y=%b", $time, a, b, y);
        a=0; b=0; #10;
        a=0; b=1; #10;
        a=1; b=0; #10;
        a=1; b=1; #10;
        $finish;
    end
endmodule