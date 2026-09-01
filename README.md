# Advanced UART Controller using Verilog HDL

## Project Overview
This project presents the design, simulation, and FPGA implementation of an advanced UART controller using Verilog HDL for the ZedBoard FPGA platform.

## Features
- UART Transmitter and Receiver
- Configurable baud rate
- Parity error detection
- Frame error detection
- RX data validation
- UART testbench verification
- FPGA synthesis and implementation
- Bitstream generation for ZedBoard

## Tools Used
- Verilog HDL
- Xilinx Vivado 2020.2
- ZedBoard FPGA

## Project Files
- `uart_tx_adv.v` – UART transmitter
- `uart_rx_adv.v` – UART receiver
- `uart_tb_adv.v` – UART testbench
- `uart_tb1_adv.v` – Advanced UART testbench
- `uart_zedboard.xdc` – ZedBoard pin constraints
- `simulation_waveform.png` – Simulation waveform
- `synthesis_success.png` – Synthesis result
- `implementation_success.png` – Implementation result
- `bitstream_success.png` – Bitstream generation result

## Verification
The UART design was verified through behavioral simulation. The waveform demonstrates UART transmission and reception along with parity and frame error detection.

## FPGA Implementation
The design was synthesized, implemented, and a bitstream was successfully generated for the ZedBoard target.

## License
MIT License
