module uart_tx (
  input  logic            clk_i,      // Тактирующий сигнал
  input  logic            rst_i,      // Сигнал сброса
  output logic            tx_o,       // Сигнал линии, подключенной к выводу ПЛИС,
                                      // по которой будут отправляться данные
  output logic            busy_o,     // Сигнал о том, что модуль занят передачей данных
  input  logic [15:0]     baudrate_i, // Настройка скорости передачи данных
  input  logic            parity_en_i,// Настройка контроля целостности через бит четности
  input  logic            stopbit_i,  // Настройка длины стопового бита
  input  logic [7:0]      tx_data_i,  // Отправляемые данные
  input  logic            tx_valid_i  // Сигнал о старте передачи данных
);
endmodule