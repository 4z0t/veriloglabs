`include "defines_riscv.v"

module alu_riscv (
  input       [31:0]  A,
  input       [31:0]  B,
  input       [4:0]   ALUOp,
  output  reg         Flag,   // reg, потому что тебе потребуется мультиплексор,
  output  reg [31:0]  Result  // описанный в case внутри always, 
);                            // а в always, слева от "равно", всегда стоит reg

wire  [31:0] Sum;
wire [31:0] Sub;


fulladder32 adder(
    .a_i(A),
    .b_i(B),
    .carry_i(1'b0),
    .sum_o(Sum)
    );

    
fulladder32 subber(
    .a_i(A),
    .b_i(~B+1),
    .carry_i(1'b0),
    .sum_o(Sub)
    );


always @(*) begin

    case(ALUOp)
        `ALU_ADD: Result = Sum;
        `ALU_SUB: Result = Sub;
        `ALU_SLL: Result = A << B[4:0];
        `ALU_SLTS: Result = $signed(A) < $signed(B);
        `ALU_SLTU: Result = A < B;
        `ALU_XOR: Result = A ^ B;
        `ALU_SRL: Result = A >> B[4:0];
        `ALU_SRA: Result = $signed(A) >>> B[4:0];
        `ALU_OR: Result = A | B;
        `ALU_AND: Result = A & B;
        `ALU_EQ: Result = 0;
        `ALU_NE: Result = 0;
        `ALU_LTS: Result = 0;
        `ALU_GES: Result = 0;
        `ALU_LTU: Result = 0;
        `ALU_GEU: Result = 0;
        default: Result = 0;
    endcase


    case(ALUOp)
        `ALU_ADD: Flag = 0;
        `ALU_SUB: Flag = 0;
        `ALU_SLL: Flag = 0;
        `ALU_SLTS:Flag = 0;
        `ALU_SLTU:Flag = 0;
        `ALU_XOR: Flag = 0;
        `ALU_SRL: Flag = 0;
        `ALU_SRA: Flag = 0;
        `ALU_OR:  Flag = 0;
        `ALU_AND: Flag = 0;
        `ALU_EQ: Flag = (A==B);
        `ALU_NE: Flag = (A!=B);
        `ALU_LTS: Flag = ($signed(A)<$signed(B));
        `ALU_GES: Flag = ($signed(A)>=$signed(B));
        `ALU_LTU: Flag = (A<B);
        `ALU_GEU: Flag = (A>=B);
        default: Flag = 0;
    endcase

end

endmodule