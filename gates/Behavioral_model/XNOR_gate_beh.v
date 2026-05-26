module XNOR_gate_beh(a, b, y);
    input a, b;
    output reg y;
    
    always @(a, b) begin
        if (a == b)
            y = 1;
        else
            y = 0;
    end
endmodule