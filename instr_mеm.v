`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 13:56:16
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(
    input [31:0] addr,
    output [31:0] read_data
    );
    
    reg [7:0] RAM [0:1023];
    
    initial $readmemh("program.mem", RAM);
    
    
    
    wire [7:0] Byte0 = RAM[addr+0];
    wire [7:0] Byte1 = RAM[addr+1];
    wire [7:0] Byte2 = RAM[addr+2];
    wire [7:0] Byte3 = RAM[addr+3];
    
   // assign read_data = {Byte3[7:0],Byte2[7:0],Byte1[7:0],Byte0[7:0]};
   assign read_data = {RAM[addr+3],RAM[addr+2],RAM[addr+1],RAM[addr+0]};
endmodule
