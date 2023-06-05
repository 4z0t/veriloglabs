`timescale 1ns / 1ps
module fulladder32
(
    input [31:0] A,
    input [31:0] B,
    input Pin,
    output [31:0] S,
    output Pout
);


wire [30:0] Pins;



genvar i;
generate
  
      fulladder FIRST
        (
            .A(A[0]),
            .B(B[0]),
            .Pin(Pin),
            .S(S[0]),
            .Pout(Pins[0])
        );
    for (i = 1; i < 31 ;i = i + 1 ) begin: newgen
         fulladder new
        (
            .A(A[i]),
            .B(B[i]),
            .Pin(Pins[i-1]),
            .S(S[i]),
            .Pout(Pins[i])
        );
    end
     fulladder LAST
        (
            .A(A[31]),
            .B(B[31]),
            .Pin(Pins[30]),
            .S(S[31]),
            .Pout(Pout)
        );
endgenerate

endmodule