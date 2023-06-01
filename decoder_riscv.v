`include "defines_riscv.vh"

`define RWMEM mem_req_o = 1;
`define RESET  begin    illegal_instr_o = 0;\
                        mem_req_o = 0;     \
                        gpr_we_a_o = 0;    \
                        wb_src_sel_o  = 0; \
                        alu_op_o = `ALU_ADD; \
                        mem_we_o = 0;      \
                        branch_o = 0;      \
                        jal_o      = 0;\
                        jalr_o = 0;\
               end
`define ILLEGAL begin  `RESET illegal_instr_o = 1;  end 
`define WRREG gpr_we_a_o = 1;

`define DO_NOP 

module decoder_riscv (
  input       [31:0]  fetched_instr_i,
  output  reg [1:0]   ex_op_a_sel_o,      
  output  reg [2:0]   ex_op_b_sel_o,      
  output  reg [4:0]   alu_op_o,           
  output  reg         mem_req_o,          
  output  reg         mem_we_o,           
  output  reg [2:0]   mem_size_o,         
  output  reg         gpr_we_a_o,         
  output  reg         wb_src_sel_o,       
  output  reg         illegal_instr_o,    
  output  reg         branch_o,           
  output  reg         jal_o,              
  output  reg         jalr_o              
);

wire        is32 =     fetched_instr_i[1:0] == 2'b11;
wire [4:0]  opcode =   fetched_instr_i[6:2]; //2 младших бита всегда 11
wire [4:0]  rd =       fetched_instr_i[11:7];
wire [4:0]  rs1 =      fetched_instr_i[19:15];
wire [4:0]  rs2 =      fetched_instr_i[24:20];
wire [4:0]  shamt =    rs2;
wire [2:0]  funct3 =   fetched_instr_i[14:12];
wire [6:0]  funct7 =   fetched_instr_i[31:25];

//wire imm_jal =  {fetched_instr_i[31:12]}
//wire imm12 =    {fetched_instr_i[31:12], 12{0}};

wire [11:0] sysfunc =  {funct7, rs2};


always @(*) begin
     if(is32)begin
         `RESET
         ex_op_a_sel_o      = `OP_A_RS1; 
         ex_op_b_sel_o      = `OP_B_RS2;
        case(opcode)
            `LUI_OPCODE:
                begin
                    ex_op_a_sel_o = `OP_A_ZERO;      // 0
                    ex_op_b_sel_o = `OP_B_IMM_U;     // imm12
                    wb_src_sel_o = `WB_EX_RESULT;    // alu: 0+imm12
                   `WRREG                            // write to register
                end
            `AUIPC_OPCODE:
                begin
                    ex_op_a_sel_o = `OP_A_CURR_PC;   // PC
                    ex_op_b_sel_o = `OP_B_IMM_U;     // imm12
                    wb_src_sel_o = `WB_EX_RESULT;    // alu: PC+imm12
                    `WRREG                           // write to register
                end
            `JAL_OPCODE:
                begin
                    jal_o = 1;
                    ex_op_a_sel_o = `OP_A_CURR_PC;   // PC
                    ex_op_b_sel_o = `OP_B_INCR;      // 4
                    wb_src_sel_o = `WB_EX_RESULT;    // alu: PC+4
                   `WRREG                            // write to register
                end
            `JALR_OPCODE:
                begin
                    if(funct3==3'b000) begin
                        jalr_o = 1;
                        ex_op_a_sel_o = `OP_A_CURR_PC;   // PC
                        ex_op_b_sel_o = `OP_B_INCR;      // 4
                        wb_src_sel_o = `WB_EX_RESULT;    // alu: PC+4
                        `WRREG                           // write to register
                    end
                    else `ILLEGAL
                end
            `BRANCH_OPCODE:
                begin
                    branch_o = 1;
                    alu_op_o = {2'b11, funct3};
                    ex_op_a_sel_o = `OP_A_RS1; // rs1
                    ex_op_b_sel_o = `OP_B_RS2; // rs2 
                    case(funct3)
                        3'b010: `ILLEGAL
                        3'b011: `ILLEGAL
                    endcase
                end
            `LOAD_OPCODE:
                begin 
                    ex_op_a_sel_o = `OP_A_RS1;      // rs1
                    ex_op_b_sel_o = `OP_B_IMM_I;    // imm
                    wb_src_sel_o = `WB_LSU_DATA;    // get from data memory
                    `WRREG                          // write to register
                    `RWMEM                          // read/write into memory
                    case(funct3)
                        `LDST_B:    mem_size_o = 3'd0;
                        `LDST_H:    mem_size_o = 3'd1;
                        `LDST_W:    mem_size_o = 3'd2;
                        `LDST_BU:   mem_size_o = 3'd4;
                        `LDST_HU:   mem_size_o = 3'd5;
                        default: `ILLEGAL
                    endcase
                end
            `STORE_OPCODE:
                begin
                    mem_we_o = 1;               // write into memory
                    ex_op_a_sel_o = `OP_A_RS1;  // rs1
                    ex_op_b_sel_o = `OP_B_IMM_S;// imm
                    `RWMEM                      // read/write into memory
                    case(funct3)
                        3'b000:    mem_size_o = 3'd0;
                        3'b001:    mem_size_o = 3'd1;
                        3'b010:    mem_size_o = 3'd2;
                        default: `ILLEGAL
                    endcase
                end
            `OP_IMM_OPCODE:
                begin
                    ex_op_a_sel_o = `OP_A_RS1;      // rs1
                    ex_op_b_sel_o = `OP_B_IMM_I;    // imm
                    wb_src_sel_o = `WB_EX_RESULT;   //alu: rs1 op imm
                    `WRREG                          // write to register
               
                    case(funct3)
                        3'b001:
                            case(funct7)
                                7'b000_0000: alu_op_o = `ALU_SLL; //slli
                                default: `ILLEGAL
                            endcase 
                        3'b010:  alu_op_o = `ALU_SLTS; 
                        3'b011:  alu_op_o = `ALU_SLTU; 
                        3'b101: 
                           case(funct7)
                                7'b000_0000: alu_op_o = `ALU_SRL;//srli
                                7'b010_0000: alu_op_o = `ALU_SRA;//srai
                                default: `ILLEGAL
                            endcase
                        3'b100: alu_op_o = `ALU_XOR;
                        3'b110: alu_op_o = `ALU_OR;
                        3'b111: alu_op_o = `ALU_AND;

                    endcase 
                 
                end
            `OP_OPCODE:
                begin
                    ex_op_a_sel_o = `OP_A_RS1;      // rs1
                    ex_op_b_sel_o = `OP_B_RS2;      // rs2
                    wb_src_sel_o = `WB_EX_RESULT;   //alu: rs1 op rs2
                    `WRREG                          // write to register   
                    case(funct7)
                        7'b000_0000:  alu_op_o = {2'b00, funct3};
                        7'b010_0000:
                            case (funct3)
                                3'b000: alu_op_o = `ALU_SUB;  
                                3'b101: alu_op_o = `ALU_SRA;
                                default: `ILLEGAL
                            endcase
                        default: `ILLEGAL
                    endcase
                end
            `MISC_MEM_OPCODE: //fence
                if(funct3 != 0)
                    `ILLEGAL
            `SYSTEM_OPCODE: 
                begin
                    case(sysfunc)
                        12'b0000_0000_0000: `DO_NOP;//ecall
                        12'b0000_0000_0001: `DO_NOP;//ebreak
                        default: `ILLEGAL
                    endcase
                    if(!(rd == 0 && funct3 == 0 && rs1 == 0))`ILLEGAL
                end
             default: `ILLEGAL
        endcase
    end
    else     `ILLEGAL
end

endmodule