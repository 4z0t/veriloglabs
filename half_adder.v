module half_adder(
    input A,
    input B,
    output S,
    output P
) ;


assign S = A ^ B;
assign P = A & B;
   
endmodule