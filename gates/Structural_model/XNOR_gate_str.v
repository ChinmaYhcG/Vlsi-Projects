module XNOR_gate_str(a, b, y);
    input a, b;
    output y;
    xnor g1(y, a, b);
endmodule