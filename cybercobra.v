`timescale 1ns / 1ps
`define bits5 [4:0]
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2023 12:57:11
// Design Name: 
// Module Name: cybercobra
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CYBERcobra (
  input           clk_i,
  input           rst_i,
  input   [15:0]  sw_i,
  output  [31:0]  out_o
);


reg [31:0] PC=0; // program counter

wire [31:0] instruction_data; //4 bytes for read data

instr_mem MEM( // read instruction from addres on PC
    .addr(PC),
    .read_data(instruction_data)
);


// flags and arguments
wire Jump;
wire B;
wire [1:0] WS;
wire `bits5 ALUop;
wire `bits5 RA1; 
wire `bits5 RA2;
wire [7:0] offset;
wire `bits5 WA;


// decompose it into needed flags and arguments
assign {Jump, B, WS, ALUop, RA1, RA2, offset, WA } = instruction_data[31:0];


// sign extensions
wire [31:0] SE_input;
wire [31:0] SE_read ;

assign SE_read = {instruction_data[27] ?  9'b111111111 : 9'b000000000 , instruction_data[27:5] }; 
assign SE_input = { sw_i[15] ? 16'hffff : 16'd0  , sw_i}; 


// write data for register
reg [31:0] WD;


// ALU arguments
wire [31:0] A1;
wire [31:0] A2;

//ALU result
wire ALU_flag;
wire [31:0] ALU_result;


// decide what to put on write
always @(*) begin
case (WS)
    2'b00: WD = SE_read;
    2'b01: WD = ALU_result;
    2'b10: WD = SE_input;
    2'b11: WD = 0;
endcase
end


rf_riscv CONNECT_REGISTER
(
       .clk(clk_i),
        .WE(!( Jump || B)),

    .A1(RA1),
    .A2(RA2),
     .A3(WA),
    
    .WD3(WD),
    .RD1(A1),
    .RD2(A2)

);


alu_riscv ALU_CALC
(
  .A(A1),
  .B(A2),
  .ALUOp(ALUop),
  .Flag(ALU_flag),   
  .Result (ALU_result)
);

wire [31:0] offsetPC;
assign  offsetPC = {{22{offset[7]}}   ,offset,2'b00};
assign out_o = A1;

 always @ (posedge clk_i)
    begin
    if (rst_i) PC=0;
    else
      if( Jump || B && ALU_flag)
        PC = PC + offsetPC;
      else
        PC = PC + 4;  
    end
endmodule