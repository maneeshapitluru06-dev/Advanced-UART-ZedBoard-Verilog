# Advanced UART Controller using Verilog HDL

## Project Overview

This project implements an Advanced UART (Universal Asynchronous Receiver Transmitter) Controller using Verilog HDL.

The design includes UART transmission and reception with configurable baud rate, parity error detection, frame error detection, and RX data validation.

The design was verified through behavioral simulation and synthesized, implemented, and converted into a bitstream for the ZedBoard FPGA platform.

## Architecture

The UART controller consists of two major modules:

- UART Transmitter (TX)
- UART Receiver (RX)

### UART Transmitter

The transmitter converts 8-bit parallel data into serial UART data.

Transmission format:

Start Bit → 8 Data Bits → Optional Parity Bit → Stop Bit

### UART Receiver

The receiver samples the incoming serial data and reconstructs the original 8-bit data.

The receiver also detects:

- Parity errors
- Frame errors
- Invalid received data

## Features

- 8-bit UART communication
- Configurable baud rate
- UART Transmitter and Receiver
- Optional parity support
- Parity error detection
- Frame error detection
- RX data validation
- Verilog HDL implementation
- Behavioral simulation
- FPGA synthesis
- FPGA implementation
- Bitstream generation

## Project Structure

```text
Advanced-UART-ZedBoard-Verilog/
│
├── src/
│   ├── uart_tx_adv.v
│   ├── uart_rx_adv.v
│   └── uart_zedboard_top.v
│
├── testbench/
│   ├── uart_tb_adv.v
│   └── uart_tb1_adv.v
│
├── constraints/
│   └── uart_zedboard.xdc
│
├── bitstream/
│   └── uart_zedboard_top.bit
│
├── results/
│   ├── simulation_waveform.png
│   ├── synthesis_success.png
│   ├── implementation_success.png
│   └── bitstream_success.png
│
├── README.md
└── LICENSE
