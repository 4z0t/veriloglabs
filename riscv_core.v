`timescale 1ns / 1ps
`define bits5 [4:0]

module riscv_core(
       input        clk_i,
       input        rst_i,
       input [31:0] instr_i,
       input [31:0] RD_i,
       output [31:0]WD_o,
       output [31:0] instr_addr_o,
       output [31:0] data_addr_o,
       output       mem_req_o,                     
       output [2:0] mem_size_o, 
       output       WE_o
    );

reg [31:0] PC = 0; // program counter

assign instr_addr_o = PC;

wire [1:0]op_a;
wire [2:0]op_b;
wire [4:0]alu_op;
wire WE3;
wire wb_src_sel;

wire illegal_instr;
wire branch_instr;
wire jal_instr;
wire jalr_instr;

 decoder_riscv DECODER(
        .fetched_instr_i(instr_i),
        .ex_op_a_sel_o(op_a),      
        .ex_op_b_sel_o(op_b),  
        .alu_op_o(alu_op),           
        .mem_req_o(mem_req_o),          
        .mem_we_o(WE_o),           
        .mem_size_o(mem_size_o),         
        .gpr_we_a_o(WE3),         
        .wb_src_sel_o(wb_src_sel),       
        .illegal_instr_o(illegal_instr),    
        .branch_o(branch_instr),           
        .jal_o(jal_instr),              
        .jalr_o(jalr_instr)   
);



// imm's
wire [31:0]imm_I;
wire [31:0]imm_U;
wire [31:0]imm_S;
wire [31:0]imm_B;
wire [31:0]imm_J;

wire [11:0]imm_I_;
wire [11:0]imm_S_;
wire [12:0]imm_B_;
wire [21:0]imm_J_;

assign imm_I_ = {instr_i[31:20]};
assign imm_S_ = {instr_i[31:25], instr_i[11:7] };
assign imm_B_ = {instr_i[31], instr_i[7],instr_i[30:25],instr_i[11:8],1'b0 };
assign imm_J_ = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[31:21], 1'b0 }; 

assign imm_I = {{20{imm_I_[11]}} ,imm_I_[11:0]};
assign imm_U = {instr_i[31:12], 12'h000 };
assign imm_S = {{20{imm_S_[11]}}, imm_S_[11:0]};
assign imm_B = {{19{imm_B_ [12] }},imm_B_ [12:0]};
assign imm_J = {{10{imm_J_[21]}},imm_J_ [21:0]};



// flags and arguments
wire `bits5 RA1; 
wire `bits5 RA2;
wire `bits5 WA;

assign RA1 = {instr_i[19:15]};
assign RA2 = {instr_i[24:20]};
assign WA = {instr_i[11:7]};

// write data for register
reg [31:0] WD;

// reg out
wire [31:0] RD1;
wire [31:0] RD2;

// ALU arguments
reg [31:0] A1;
reg [31:0] A2;

//ALU result
wire ALU_flag;
wire [31:0] ALU_result;


always @(*) begin
    case(op_a)
        2'b00: A1 = RD1;
        2'b01: A1 = PC;
        2'b10: A1 = 0;
    endcase
    
    case(op_b)
        3'b000: A2 = RD2;
        3'b001: A2 = imm_I;
        3'b010: A2 = imm_U;
        3'b011: A2 = imm_S;
        3'b100: A2 = 4;
    endcase
    
    WD = wb_src_sel ? RD_i : ALU_result;
end


rf_riscv CONNECT_REGISTER
(
    .clk(clk_i),
    .WE(WE3),

    .A1(RA1),
    .A2(RA2),
    .A3(WA),
    
    .WD3(WD),
    .RD1(RD1),
    .RD2(RD2)

);

assign WD_o = RD2;


alu_riscv ALU_CALC
(
  .A(A1),
  .B(A2),
  .ALUOp(alu_op),
  .Flag(ALU_flag),   
  .Result (ALU_result)
);
assign data_addr_o = ALU_result;  


 always @ (posedge clk_i)
    begin
    if (rst_i) PC=0;
    else
        if(jalr_instr)
                PC = RD1 + imm_I;
         else
                PC = PC + (
                    ((ALU_flag && branch_instr) || jal_instr) ?
                    (branch_instr ? 
                        imm_B 
                        :
                        imm_J
                    )
                    :
                    4
                );     
     end
endmodule
