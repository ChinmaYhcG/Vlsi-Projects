module NOT_gate_tb;
 reg a;
 wire y;

 NOT_gate uut (.a(a), .y(y));

 initial begin 
  $dumpfile("NOT_wave.vcd");
  $dumpvars(0, NOT_gate_tb);

  a = 0;#10;
  a = 1;#10;
  $finish;
  end

  initial begin 
    $monitor("t=%0t | a=%b | y=%b", $time, a, y);
    end
    endmodule