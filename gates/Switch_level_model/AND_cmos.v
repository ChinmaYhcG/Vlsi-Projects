module AND_cmos(a, b, y);
    input a, b;
    output y;
    wire nand_out;
    
    NAND_cmos n1(.a(a), .b(b), .y(nand_out));
    NOT_cmos  n2(.a(nand_out), .y(y));
endmodule