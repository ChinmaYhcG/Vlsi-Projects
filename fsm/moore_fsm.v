module moore_fsm(ds, rd, go, ws, clk, rst_n);
 output ds, rd;
 input go, ws;
 input clk, rst_n;
 parameter [1:0] IDLE = 2'b00,
 READ = 2'b01,
 DLY = 2'b10,
 DONE = 2'b11;
 reg [1:0] state, next;
 always @(posedge clk or negedge rst_n)
  if (!rst_n) state <= IDLE;
  else state <= next;
 always @(state or go or ws) begin
  next = 2'bx;
  case (state)
   IDLE: if (go) next = READ;
  else next = IDLE;
   READ: next = DLY;
   DLY: if (ws) next = READ;
  else next = DONE;
   DONE: next = IDLE;
 endcase
 end
assign rd = (state==READ || state==DLY);
assign ds = (state==DONE);
endmodule