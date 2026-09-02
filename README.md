# Advanced UART Controller using Verilog HDL

## Project Overview

This project presents the design, simulation, synthesis, implementation, and bitstream generation of an Advanced UART (Universal Asynchronous Receiver Transmitter) Controller using Verilog HDL.

The UART controller supports serial data transmission and reception with configurable baud rate, optional parity handling, parity error detection, frame error detection, and RX data validation.

The design was developed for FPGA implementation targeting the ZedBoard platform using Xilinx Vivado.

---

## Architecture

The system consists of two main modules:

- UART Transmitter (TX)
- UART Receiver (RX)

### UART Transmitter

The transmitter converts 8-bit parallel data into serial UART data.

The transmission sequence is:

```text
IDLE → START → DATA → PARITY → STOP
