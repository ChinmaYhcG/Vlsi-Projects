module OR_cmos(a, b, y);
    input a, b;
    output y;
    wire nor_out;
    
    NOR_cmos  n1(.a(a), .b(b), .y(nor_out));
    NOT_cmos  n2(.a(nor_out), .y(y));
endmodule