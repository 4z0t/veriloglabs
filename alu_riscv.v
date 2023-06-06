`include "defines_riscv.vh"

module alu_riscv (
  input       [31:0]  A,
  input       [31:0]  B,
  input       [4:0]   ALUOp,
  output  reg         Flag,   // reg, потому что тебе потребуется мультиплексор,
  output  reg [31:0]  Result  // описанный в case внутри always, 
);                            // а в always, слева от "равно", всегда стоит reg

always @(*) begin
    
    case(ALUOp)
        `ALU_ADD: Result = A + B;
        `ALU_SUB: Result = A - B;
        `ALU_SLL: Result = A << B;
        `ALU_SLTS: Result = A < B;
        `ALU_SLTU: Result = A <B;
        `ALU_XOR: Result = A ^ B;
        `ALU_SRL: Result = A >> B;
        `ALU_SRA: Result = A >>> B;
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
        `ALU_LTS: Flag = (A<B);
        `ALU_GES: Flag = (A>=B);
        `ALU_LTU: Flag = (A<B);
        `ALU_GEU: Flag = (A>=B);
        default: Flag = 0;
    endcase

end

endmodule