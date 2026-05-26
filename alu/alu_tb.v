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

        a=4'd5; b=4'd5; op=4'b1000; #10;
        $display("EQ:   %0d == %0d = %0d", a, b, result);

        a=4'd3; b=4'd5; op=4'b1001; #10;
        $display("LT:   %0d < %0d = %0d", a, b, result);

        $finish;
    end
endmodule
