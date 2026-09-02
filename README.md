# Advanced UART Controller using Verilog HDL

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![FPGA](https://img.shields.io/badge/FPGA-ZedBoard-orange)
![UART](https://img.shields.io/badge/Protocol-UART-green)
![Vivado](https://img.shields.io/badge/Tool-Xilinx%20Vivado-red)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Project Overview

This project presents the design, simulation, synthesis, implementation, and bitstream generation of an Advanced UART (Universal Asynchronous Receiver Transmitter) Controller using Verilog HDL.

The UART controller supports serial data transmission and reception with configurable baud rate, optional parity handling, parity error detection, frame error detection, and RX data validation.

The design was developed using modular RTL design methodology and targeted for FPGA implementation on the ZedBoard platform.

---

## Project Objectives

The main objectives of this project are:

- To design a UART transmitter using Verilog HDL.
- To design a UART receiver using Verilog HDL.
- To implement configurable baud-rate operation.
- To implement optional parity generation and checking.
- To detect parity errors.
- To detect frame errors.
- To verify UART communication using behavioral simulation.
- To synthesize and implement the RTL design for FPGA.
- To generate an FPGA programming bitstream.

---

## System Architecture

The overall UART architecture consists of two major blocks:

```text
                         ADVANCED UART CONTROLLER
                                  |
             +--------------------+--------------------+
             |                                         |
             v                                         v
     +---------------+                         +---------------+
     | UART          |                         | UART          |
     | TRANSMITTER   |                         | RECEIVER      |
     |    (TX)       |                         |    (RX)       |
     +-------+-------+                         +-------+-------+
             |                                         ^
             |                                         |
             |       Serial UART Communication         |
             +---------------> TXD/RXD <---------------+
             |
             v
       Serial Data
