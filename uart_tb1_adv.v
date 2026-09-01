`timescale 1ns / 1ps

module uart_tb1_adv;

    // =========================================================
    // PARAMETERS
    // =========================================================

    parameter integer CLK_FREQ    = 50_000_000;
    parameter integer BAUD_RATE   = 9600;
    parameter integer PARITY_MODE = 1;   // EVEN PARITY

    localparam integer BIT_TICKS =
        CLK_FREQ / BAUD_RATE;

    localparam integer BIT_TIME_NS =
        1_000_000_000 / BAUD_RATE;


    // =========================================================
    // CLOCK / RESET
    // =========================================================

    reg clk;
    reg rst;


    // =========================================================
    // RX LINE
    // We directly control this line for error testing
    // =========================================================

    reg rx_line;


    // =========================================================
    // RECEIVER OUTPUTS
    // =========================================================

    wire [7:0] rx_data;
    wire       rx_data_valid;

    wire       parity_error;
    wire       frame_error;


    // =========================================================
    // UART RECEIVER
    // =========================================================

    uart_rx_adv #(
        .CLK_FREQ     (CLK_FREQ),
        .BAUD_RATE    (BAUD_RATE),
        .CLKS_PER_BIT (0),
        .PARITY_MODE  (PARITY_MODE)
    )
    DUT_RX (
        .clk           (clk),
        .rst           (rst),
        .rx            (rx_line),

        .rx_data       (rx_data),
        .rx_data_valid (rx_data_valid),

        .parity_error  (parity_error),
        .frame_error   (frame_error)
    );


    // =========================================================
    // 50 MHz CLOCK
    // Period = 20 ns
    // =========================================================

    initial begin
        clk = 1'b0;

        forever #10 clk = ~clk;
    end


    // =========================================================
    // TASK : SEND BYTE WITH WRONG PARITY
    // =========================================================

    task send_bad_parity;

        input [7:0] data;

        integer i;

        begin

            // IDLE
            rx_line = 1'b1;
            #(BIT_TIME_NS);

            // START BIT
            rx_line = 1'b0;
            #(BIT_TIME_NS);

            // DATA BITS - LSB FIRST
            for (i = 0; i < 8; i = i + 1) begin

                rx_line = data[i];
                #(BIT_TIME_NS);

            end

            // -------------------------------------------------
            // WRONG EVEN PARITY
            //
            // For AA:
            // AA = 10101010
            // Number of 1s = 4
            // Correct EVEN parity = 0
            //
            // We intentionally send 1.
            // -------------------------------------------------

            rx_line = 1'b1;
            #(BIT_TIME_NS);

            // STOP BIT
            rx_line = 1'b1;
            #(BIT_TIME_NS);

            // Back to IDLE
            rx_line = 1'b1;

        end

    endtask


    // =========================================================
    // TASK : SEND BYTE WITH WRONG STOP BIT
    // =========================================================

    task send_bad_frame;

        input [7:0] data;

        integer i;

        begin

            // IDLE
            rx_line = 1'b1;
            #(BIT_TIME_NS);

            // START BIT
            rx_line = 1'b0;
            #(BIT_TIME_NS);

            // DATA BITS - LSB FIRST
            for (i = 0; i < 8; i = i + 1) begin

                rx_line = data[i];
                #(BIT_TIME_NS);

            end

            // -------------------------------------------------
            // CORRECT EVEN PARITY
            //
            // For 55:
            // 55 = 01010101
            // Number of 1s = 4
            // Correct EVEN parity = 0
            // -------------------------------------------------

            rx_line = 1'b0;
            #(BIT_TIME_NS);

            // -------------------------------------------------
            // WRONG STOP BIT
            //
            // Correct stop = 1
            // We intentionally send 0.
            // -------------------------------------------------

            rx_line = 1'b0;
            #(BIT_TIME_NS);

            // Return to IDLE
            rx_line = 1'b1;

        end

    endtask


    // =========================================================
    // MAIN TEST SEQUENCE
    // =========================================================

    initial begin

        // Initial conditions

        rst     = 1'b1;
        rx_line = 1'b1;


        // =====================================================
        // RESET
        // =====================================================

        #200;

        rst = 1'b0;

        #(BIT_TIME_NS * 2);


        // =====================================================
        // TEST 3
        // INTENTIONAL PARITY ERROR
        // =====================================================

        send_bad_parity(8'hAA);

        // Give receiver time to process STOP bit
        #(BIT_TIME_NS / 2);

        $display("");
        $display("======================================");
        $display("UART ADVANCED TEST 3");
        $display("PARITY ERROR TEST");
        $display("======================================");

        $display("TX DATA        = %h", 8'hAA);
        $display("RX DATA        = %h", rx_data);
        $display("RX VALID       = %b", rx_data_valid);
        $display("PARITY ERROR   = %b", parity_error);
        $display("FRAME ERROR    = %b", frame_error);

        $display("======================================");


        // =====================================================
        // GAP BETWEEN TESTS
        // =====================================================

        #(BIT_TIME_NS * 2);


        // =====================================================
        // TEST 4
        // INTENTIONAL FRAME ERROR
        // =====================================================

        send_bad_frame(8'h55);

        // Give receiver time to process STOP bit
        #(BIT_TIME_NS / 2);

        $display("");
        $display("======================================");
        $display("UART ADVANCED TEST 4");
        $display("FRAME ERROR TEST");
        $display("======================================");

        $display("TX DATA        = %h", 8'h55);
        $display("RX DATA        = %h", rx_data);
        $display("RX VALID       = %b", rx_data_valid);
        $display("PARITY ERROR   = %b", parity_error);
        $display("FRAME ERROR    = %b", frame_error);

        $display("======================================");


        // =====================================================
        // END SIMULATION
        // =====================================================

        #(BIT_TIME_NS * 2);

        $finish;

    end

endmodule
