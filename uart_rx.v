module uart_rx (
  input  logic            clk_i,      // Тактирующий сигнал
  input  logic            rst_i,      // Сигнал сброса
  input  logic            rx_i,       // Сигнал линии, подключенной к выводу ПЛИС,
                                      // по которой будут приниматься данные
  output logic            busy_o,     // Сигнал о том, что модуль занят приемом данных
  input  logic [15:0]     baudrate_i, // Настройка скорости передачи данных
  input  logic            parity_en_i,// Настройка контроля целостности через бит четности
  input  logic            stopbit_i,  // Настройка длины стопового бита
  output logic [7:0]      rx_data_o,  // Принятые данные
  output logic            rx_valid_o  // Сигнал о том, что прием данных завершен

);
endmodule