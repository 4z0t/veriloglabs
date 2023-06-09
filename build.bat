
set gcc_=C:\Users\gaste\Downloads\xpack-riscv-none-elf-gcc-12.2.0-3-win32-x64\xpack-riscv-none-elf-gcc-12.2.0-3\bin\riscv-none-elf-gcc
set objcopy_=C:\Users\gaste\Downloads\xpack-riscv-none-elf-gcc-12.2.0-3-win32-x64\xpack-riscv-none-elf-gcc-12.2.0-3\bin\riscv-none-elf-objcopy

%gcc_% -c -march=rv32i -mabi=ilp32 startup.S -o out/startup.o
%gcc_% -c -march=rv32i -mabi=ilp32 8.c -o out/main.o
%gcc_% -march=rv32i -mabi=ilp32 -Wl,--gc-sections -nostartfiles -T linker_script.ld out/startup.o out/main.o -o out/result.elf
%objcopy_% -O verilog out/result.elf out/init.mem
%objcopy_% -O verilog -j .text out/result.elf out/init_instr.mem
%objcopy_% -O verilog -j .data -j .bss out/result.elf out/init_data.mem
