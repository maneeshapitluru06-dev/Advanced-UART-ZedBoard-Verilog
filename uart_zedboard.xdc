## =========================================================
## ZEDBOARD UART
## =========================================================

## ---------------------------------------------------------
## 100 MHz PL CLOCK
## ---------------------------------------------------------

set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -add -name sys_clk_pin \
    -period 10.00 \
    -waveform {0 5} \
    [get_ports clk]


## ---------------------------------------------------------
## CENTER PUSH BUTTON
## BTNC = P16
## ---------------------------------------------------------

set_property PACKAGE_PIN P16 [get_ports btn]
set_property IOSTANDARD LVCMOS18 [get_ports btn]


## ---------------------------------------------------------
## UART TX
## Pmod JA1 = Y11
## ---------------------------------------------------------

set_property PACKAGE_PIN Y11 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]