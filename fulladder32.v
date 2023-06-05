module fulladder32
(
    input [31:0] A,
    input [31:0] B,
    input Pin,
    output [31:0] S,
    output Pout
);


wire [31:0] Pins;
wire [31:0] Pouts;

fulladder ADDERS[31:0] 
(
    .A(A)
    .B(B)
    .Pin(Pins)
    .S(Pouts)
    .Pout(Pouts)
);

initial begin

    Pins[0] = Pin;
    Pout = Pouts[31];
    integer i;

    for (i = 1; i < 32 ;i = i + 1 ) begin
         Pins[i] = Pouts[i-1];
    end
end

endmodule