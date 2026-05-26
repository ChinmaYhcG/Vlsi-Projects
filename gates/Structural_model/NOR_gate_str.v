module NOR_gate_str(a, b, y);
    input a, b;
    output y;
    nor g1(y, a, b);
endmodule