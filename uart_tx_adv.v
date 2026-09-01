`timescale 1ns / 1ps

module uart_zedboard_top (
    input  wire clk,
    input  wire btn,
    output wire tx
);

    // --------------------------------------------------
    // Button synchronizer
    // --------------------------------------------------

    reg btn_ff1;
    reg btn_ff2;
    reg btn_prev;

    wire btn_pulse;

    assign btn_pulse = btn_ff2 & ~btn_prev;

    always @(posedge clk) begin

        btn_ff1  <= btn;
        btn_ff2  <= btn_ff1;
        btn_prev <= btn_ff2;

    end


    // --------------------------------------------------
    // UART signals
    // --------------------------------------------------

    wire       tx_busy;

    // Test data
    wire [7:0] tx_data = 8'hAA;


    // --------------------------------------------------
    // UART TRANSMITTER
    // --------------------------------------------------

    uart_tx_adv #(
        .CLK_FREQ     (100_000_000),
        .BAUD_RATE    (9600),
        .CLKS_PER_BIT (0),
        .PARITY_MODE  (1)
    )
    UART_TX (
        .clk      (clk),
        .rst      (1'b0),
        .tx_start (btn_pulse),
        .tx_data  (tx_data),
        .tx        (tx),
        .tx_busy  (tx_busy)
    );

endmodule