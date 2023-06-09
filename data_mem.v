`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 14:17:05
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input req,
    input clk,
    input WE,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
    );
    
    reg [7:0] RAM [0:1023];
  
always @ (*)
    begin
        if(!WE && req)begin
            if ((addr & 32'hffff_fc00) == 0)
            read_data = addr == 0 ? 0 : {RAM[addr+3],RAM[addr+2],RAM[addr+1],RAM[addr+0]};
        end
    end
    
always @ (posedge clk)
    begin
        if(WE && req)begin
            if ((addr & 32'hffff_fc00) == 0)
                {RAM[addr+3],RAM[addr+2],RAM[addr+1],RAM[addr+0]} <= write_data;
        end
    end
    
endmodule
