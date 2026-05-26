module NOR_cmos(a, b, y);
    input a, b;
    output y;
    supply1 vdd;
    supply0 gnd;
    wire mid;
    
    pmos p1(mid, vdd, a);
    pmos p2(y, mid, b);
    nmos n1(y, gnd, a);
    nmos n2(y, gnd, b);
endmodule