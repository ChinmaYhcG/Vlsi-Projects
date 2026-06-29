module mealy_fsm (ds, rd, go, ws, clk, rst_n);
  output reg ds, rd;
  input go, ws;
  input clk, rst_n;
  
  parameter [1:0] IDLE = 2'b00,
                  READ = 2'b01,
                  DLY  = 2'b10;
                  
  reg [1:0] state, next;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= IDLE;
    else state <= next;
  end
  
  always @(state or go or ws) begin
    next = 2'bx;
    rd = 1'b0;
    ds = 1'b0;
    
    case (state)
      IDLE: begin
        if (go) begin
          next = READ;
          rd = 1'b1;   
        end else begin
          next = IDLE;
        end
      end
      
      READ: begin
        next = DLY;
        rd = 1'b1;     
      end
      
      DLY: begin
        if (ws) begin
          next = READ;
          rd = 1'b1;   
        end else begin
          next = IDLE;
          ds = 1'b1;   
        end
      end
      
      default: next = IDLE;
    endcase
  end

endmodule