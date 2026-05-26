module XOR_cmos(a, b, y);
    input a, b;
    output y;
    wire nand_out, nand_a, nand_b;
    
    NAND_cmos n1(.a(a), .b(b), .y(nand_out));
    NAND_cmos n2(.a(a), .b(nand_out), .y(nand_a));
    NAND_cmos n3(.a(b), .b(nand_out), .y(nand_b));
    NAND_cmos n4(.a(nand_a), .b(nand_b), .y(y));
endmodule