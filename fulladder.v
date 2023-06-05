module fulladder(
    input A,
    input B,
    output Pin,
    output S,
    output Pout
) ;


wire AXORB = A ^ B;
assign S = AXORB ^ Pin;
assign Pout = (A & B) | (Pin & AXORB);
   
endmodule