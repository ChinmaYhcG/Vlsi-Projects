module NAND_gate_str(a, b, y);
    input a, b;
    output y;
    nand g1(y, a, b);
endmodule