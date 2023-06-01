module uart_rx_sb_ctrl(
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
    осуществляющему вывод цифр на семисегментные индикаторы
*/
  input         rx_i
);

  reg busy;
  reg [15:0] baudrate;
  reg parity_en;
  reg stopbit;
  reg data;
  reg valid;

endmodule