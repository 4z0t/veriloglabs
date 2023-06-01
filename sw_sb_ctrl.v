module sw_sb_ctrl(
/*
    Часть интерфейса модуля, отвечающая за подключение к системной шине
*/
  input [31:0]  addr_i,
  input         req_i,
  input [31:0]  WD_i, // \
  input         clk_i,//  - эти сигналы не используются и добавлены для совместимости с системной шиной
  input         WE_i, // /
  output [31:0] RD_o,

/*
    Часть интерфейса модуля, отвечающая за подключение к периферии
*/
  input [15:0]  sw_i
);

always @(*) begin
    if(req_i == 1 && WE_i == 0 && addr_i == 0x00)
    begin
         RD_o = {{16{0}}, sw_i};
    end
    else
    RD_o = 32'hZZZZZZZZ;
end

endmodule