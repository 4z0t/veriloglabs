module ps2_sb_ctrl(
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
    Часть интерфейса модуля, отвечающая за подключение к модулю,
    осуществляющему прием данных с клавиатуры
*/
  input kclk,
  input kdata
);

reg [7:0] scan_code;
reg       scan_code_is_unread;

endmodule