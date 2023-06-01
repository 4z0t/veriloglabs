module led_sb_ctrl(
/*
    Часть интерфейса модуля, отвечающая за подключение к системной шине
*/
  input         clk_i,
  input [31:0]  addr_i,
  input         req_i,
  input [31:0]  WD_i,
  input         WE_i,
  output [31:0] RD_o,

/*
    Часть интерфейса модуля, отвечающая за подключение к периферии
*/
  output [15:0]  led_o
);

reg [15:0]  led_val;
reg         led_mode;

endmodule