module alu(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] op,
    output reg [3:0] result,
    output reg zero
);
    always @(*) begin
        case(op)
            4'b0000: result = a + b;
            4'b0001: result = a - b;
            4'b0010: result = a & b;
            4'b0011: result = a | b;
            4'b0100: result = a ^ b;
            4'b0101: result = ~a;
            4'b0110: result = a << 1;
            4'b0111: result = a >> 1;
            4'b1000: result = (a == b) ? 4'b0001 : 4'b0000;
            4'b1001: result = (a < b)  ? 4'b0001 : 4'b0000;
            4'b1010: result = (a > b)  ? 4'b0001 : 4'b0000;
            default: result = 4'b0000;
        endcase
        zero = (result == 4'b0000) ? 1 : 0;
    end
endmodule
