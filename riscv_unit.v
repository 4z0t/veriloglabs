`timescale 1ns / 1ps

`define MEM_ID 8'd0
`define SWITCH_ID 8'd1
`define LED_ID 8'd2


module riscv_unit(
    input clk_i,
    input resetn,
    
         // Входы и выходы периферии
      input [15:0] sw_i,    // Переключатели
      output[15:0] led_o,   // Светодиоды
      input        kclk,    // Тактирующий сигнал клавиатуры
      input        kdata,   // Сигнал данных клавиатуры
      output [6:0] hex_led, // Вывод семисегментных индикаторов
      output [7:0] hex_sel, // Селектор семисегментных индикаторов
      input        rx_i,    // Линия приема по UART
      output       tx_o     // Линия передачи по UART
    );

wire sysclk, rst;
    sys_clk_rst_gen divider(.ex_clk_i(clk_i),.ex_areset_n_i(resetn),.div_i(10),.sys_clk_o(sysclk), .sys_reset_o(rst));
    
wire [31:0] instr;

wire WE;
wire [31:0] WD;
wire [31:0] data_addr;

wire [7:0]  device_id = data_addr[31:24];
wire [31:0] device_addr = {8'd0, data_addr[23:0]};
wire [31:0] instr_addr;
reg [31:0] RD;
wire mem_req;

instr_mem MEM( 
    .addr(instr_addr),
    .read_data(instr)
);

   
riscv_core CORE(
   .clk_i(sysclk),
   .rst_i(rst),
   .instr_i(instr),
   .RD_i(RD),
   .WD_o(WD),
   .instr_addr_o(instr_addr),
   .data_addr_o(data_addr),
   .mem_req_o(mem_req),                     
   .mem_size_o(), 
   .WE_o (WE)       
);



wire [255:0] out = 1 << device_id;
wire [31:0] switch_RD;
wire [31:0] led_RD;
wire [31:0] mem_RD;


always @(*)begin
    case(device_id)
        `MEM_ID: RD = mem_RD;
        `SWITCH_ID: RD = switch_RD; 
        `LED_ID: RD = led_RD;
    endcase
end


 data_mem DATA(
    .req(mem_req && out[`MEM_ID]),
    .clk(sysclk),
    .WE(WE),
    .addr(device_addr),
    .write_data(WD),
    .read_data(mem_RD)
);
 


sw_sb_ctrl SWITCHES(
    .addr_i(device_addr),
    .req_i(mem_req &&  out[`SWITCH_ID]),
    .WD_i(WD),
    .clk_i(sysclk),
    .WE_i(WE),
    .RD_o(switch_RD),
    .sw_i(sw_i)
);

led_sb_ctrl LEDS(
    .addr_i(device_addr),
    .req_i(mem_req && out [`LED_ID]),
    .WD_i(WD),
    .clk_i(sysclk),
    .WE_i(WE),
    .RD_o(led_RD),
    .led_o(led_o)
);

endmodule
