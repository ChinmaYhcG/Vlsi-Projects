module NOT_cmos_tb;
    reg a;
    wire y;
    NOT_cmos uut(.a(a), .y(y));
    initial begin
        $dumpfile("NOT_cmos_wave.vcd");
        $dumpvars(0, NOT_cmos_tb);
        $monitor("t=%0t | a=%b | y=%b", $time, a, y);
        a=0; #10;
        a=1; #10;
        $finish;
    end
endmodule