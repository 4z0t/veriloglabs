module PS2Receiver(
    input         clk,          // Сигнал тактирования процессора и вашего модуля-контроллера
    input         kclk,         // Тактовый сигнал, приходящий с клавиатуры
    input         kdata,        // Сигнал данных, приходящий с клавиатуры
    output [15:0] keycodeout,   // Сигнал полученного с клавиатуры скан-кода клавиши
    output        keycode_valid // Сигнал готовности данных на выходе keycodeout
    );
endmodule