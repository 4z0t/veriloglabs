module hex_sb_ctrl(
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
  output [6:0] hex_led,
  output [7:0] hex_sel
);

  reg [3:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;
  reg [7:0] bitmask_on_off;
endmodule