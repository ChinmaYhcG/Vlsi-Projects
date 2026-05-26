module wave_test;
 reg a, b;
 wire y;
 assign y = a & b;
 initial begin 
 $dumpfile("wave.vcd");
 $dumpvars(0, wave_test);

 a = 0; b =0; #10;
 a = 0; b =1; #10;
 a = 1; b =0; #10;
 a = 1; b =1; #10;

 $finish;

 end
 endmodule