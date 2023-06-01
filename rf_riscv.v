`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 14:30:47
// Design Name: 
// Module Name: rf_riscv
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


module rf_riscv(
    input clk,
    input WE,
    
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
    );
    
     
    reg [31:0] RAM [0:31];

    assign RD1 = A1 ? RAM[A1] : 0;
    assign RD2 = A2 ? RAM[A2] : 0;
    
    
    always @ (posedge clk)
    begin
     if(WE)begin
            RAM[A3]<=WD3;
     end
        
    end
endmodule
