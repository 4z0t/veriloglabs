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


always @(posedge clk_i) 
begin
    if(WD_i & 32'hffff0000 == 0)
    begin 
        
    end
    else 
    RD_o = 32'hZZZZZZZZ;
end

endmodule