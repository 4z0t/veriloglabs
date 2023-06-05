module led_sb_ctrl(
/*
    Часть интерфейса модуля, отвечающая за подключение к системной шине
*/
  input         clk_i,
  input [31:0]  addr_i,
  input         req_i,
  input [31:0]  WD_i,
  input         WE_i,
  output reg [31:0] RD_o,

/*
    Часть интерфейса модуля, отвечающая за подключение к периферии
*/
  output reg [15:0]  led_o
);

reg [15:0]  led_val;
reg         led_mode = 0;

reg [23:0] counter = 0;
reg        cur_mode = 0;


always @(*) begin
 if(req_i && !WE_i)
    case(addr_i)
        32'h00:
           RD_o = led_val;        
        32'h04:             
           RD_o = led_mode; 
        default:
            RD_o = 32'hZZZZZZZZ;            
    endcase
   else
        RD_o = 32'hZZZZZZZZ;
end



always @(posedge clk_i) 
begin
    if(req_i && WE_i)
    case(addr_i)
        32'h00:
            if((WD_i & 32'hffff0000) == 0)
                led_val = WD_i;
        32'h04:
            if((WD_i & 32'hfffffffe) == 0)
            begin
                led_mode = WD_i;
            end
        32'h24:
            if(WD_i == 1)
            begin
                led_val = 0;
                led_mode = 0;
            end         
    endcase
    if(led_mode)
    begin
        counter = counter + 1;
        if(counter == 10_000_000)begin
            counter = 0;
            cur_mode = ~cur_mode;
         end
     end
     led_o = (!led_mode || cur_mode) ? led_val : 0; 
end

endmodule