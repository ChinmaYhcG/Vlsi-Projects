module alu_tb;
    reg  [3:0] a, b, op;
    wire [3:0] result;
    wire zero;

    alu uut (.a(a), .b(b), .op(op), .result(result), .zero(zero));

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        a=4'd5; b=4'd3; op=4'b0000; #10;
        $display("ADD:  %0d + %0d = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b0001; #10;
        $display("SUB:  %0d - %0d = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b0010; #10;
        $display("AND:  %0d & %0d = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b0011; #10;
        $display("OR:   %0d | %0d = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b0100; #10;
        $display("XOR:  %0d ^ %0d = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b0101; #10;
        $display("NOT:  ~%0d = %0d", a, result);

        a=4'd5; b=4'd3; op=4'b0110; #10;
        $display("SHL1: %0d << 1 = %0d", a, result);

        a=4'd5; b=4'd3; op=4'b0111; #10;
        $display("SHR1: %0d >> 1 = %0d", a, result);

        a=4'd5; b=4'd3; op=4'b1000; #10;
        $display("SHL2: %0d << 2 = %0d", a, result);

        a=4'd5; b=4'd3; op=4'b1001; #10;
        $display("SHR2: %0d >> 2 = %0d", a, result);

        a=4'd5; b=4'd3; op=4'b1010; #10;
        $display("NAND: ~(%0d & %0d) = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b1011; #10;
        $display("NOR:  ~(%0d | %0d) = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b1100; #10;
        $display("XNOR: ~(%0d ^ %0d) = %0d", a, b, result);

        a=4'd5; b=4'd5; op=4'b1101; #10;
        $display("EQ:   %0d == %0d = %0d", a, b, result);

        a=4'd3; b=4'd5; op=4'b1110; #10;
        $display("LT:   %0d < %0d = %0d", a, b, result);

        a=4'd5; b=4'd3; op=4'b1111; #10;
        $display("GT:   %0d > %0d = %0d", a, b, result);

        $finish;
    end
endmodule
