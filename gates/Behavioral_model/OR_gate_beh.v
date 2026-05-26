module OR_gate_beh(a,b,y);
 input a,b;
 output reg y;

always @(a,b) begin
 if(a == 1 || b == 1)
  y = 1;
  else
   y = 0;
   end
endmodule 