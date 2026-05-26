module NAND_cmos(a, b, y);
    input a, b;
    output y;
    supply1 vdd;
    supply0 gnd;
    wire mid;
    
    pmos p1(y, vdd, a);
    pmos p2(y, vdd, b);
    nmos n1(mid, gnd, b);
    nmos n2(y, mid, a);
endmodule