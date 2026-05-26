module XNOR_cmos(a, b, y);
    input a, b;
    output y;
    wire xor_out;
    
    XOR_cmos  x1(.a(a), .b(b), .y(xor_out));
    NOT_cmos  n1(.a(xor_out), .y(y));
endmodule