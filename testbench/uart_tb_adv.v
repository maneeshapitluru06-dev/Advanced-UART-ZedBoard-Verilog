`timescale 1ns / 1ps

module uart_tb;

    // ==================================================
    // CLOCK AND RESET
    // ==================================================

    reg clk;
    reg rst;

    // ==================================================
    // UART TX SIGNALS
    // ==================================================

    reg       tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;

    // ==================================================
    // UART RX SIGNALS
    // ==================================================

    wire [7:0] rx_data;
    wire       rx_data_valid;

    // ==================================================
    // UART TRANSMITTER
    // ==================================================

    uart_tx #(
        .CLKS_PER_BIT(5208)
    ) DUT_TX (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx        (tx),
        .tx_busy  (tx_busy)
    );

    // ==================================================
    // UART RECEIVER
    // TX IS CONNECTED DIRECTLY TO RX
    // ==================================================

    uart_rx #(
        .CLKS_PER_BIT(5208)
    ) DUT_RX (
        .clk           (clk),
        .rst           (rst),
        .rx            (tx),
        .rx_data       (rx_data),
        .rx_data_valid (rx_data_valid)
    );

    // ==================================================
    // 50 MHz CLOCK
    // Period = 20 ns
    // ==================================================

    initial begin

        clk = 1'b0;

        forever #10 clk = ~clk;

    end

    // ==================================================
    // TEST SEQUENCE
    // ==================================================

    initial begin

        // Initial conditions
        rst      = 1'b1;
        tx_start = 1'b0;
        tx_data  = 8'h00;

        // ---------------- RESET ----------------

        #100;

        rst = 1'b0;

        // ==================================================
        // TEST 1 : SEND AA
        // ==================================================

        tx_data = 8'hAA;

        #100;

        tx_start = 1'b1;

        #20;

        tx_start = 1'b0;

        // Wait until transmitter finishes
        wait(tx_busy == 1'b0);

        // Wait until receiver gets data
        wait(rx_data_valid == 1'b1);

        #100;

        $display("======================================");
        $display("UART TEST 1");
        $display("TX DATA = %h", tx_data);
        $display("RX DATA = %h", rx_data);
        $display("RX VALID = %b", rx_data_valid);
        $display("======================================");

        // ==================================================
        // TEST 2 : SEND 55
        // ==================================================

        tx_data = 8'h55;

        #100;

        tx_start = 1'b1;

        #20;

        tx_start = 1'b0;

        // Wait until transmitter finishes
        wait(tx_busy == 1'b0);

        // Wait until receiver gets data
        wait(rx_data_valid == 1'b1);

        #100;

        $display("======================================");
        $display("UART TEST 2");
        $display("TX DATA = %h", tx_data);
        $display("RX DATA = %h", rx_data);
        $display("RX VALID = %b", rx_data_valid);
        $display("======================================");

        // ==================================================
        // END SIMULATION
        // ==================================================

        #100;

        $finish;

    end

endmodule
