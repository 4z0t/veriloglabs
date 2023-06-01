`timescale 1ns / 1ps

module riscv_unit(
    input clk_i,
    input rst_i
    );
    
wire [31:0] instr;

wire WE;
wire [31:0] WD;
wire [31:0] data_addr;
wire [31:0] instr_addr;
wire [31:0] RD;

instr_mem MEM( 
    .addr(instr_addr),
    .read_data(instr)
);

 data_mem DATA(
    .clk(clk_i),
    . WE(WE),
    .addr(data_addr),
    . write_data(WD),
    .read_data(RD)
);
    
    riscv_core CORE(
       .clk_i(clk_i),
       .rst_i(rst_i),
       .instr_i(instr),
       .RD_i(RD),
       .WD_o(WD),
       .instr_addr_o(instr_addr),
       .data_addr_o(data_addr),
       .mem_req_o(),                     
       .mem_size_o(), 
       .WE_o (WE)       
    );
    
endmodule
