`timescale 1ns / 1ps

module uart_rx_adv #(
    parameter integer CLK_FREQ     = 100000000,
    parameter integer BAUD_RATE    = 9600,
    parameter integer CLKS_PER_BIT = 0,
    parameter integer PARITY_MODE  = 1
)(
    input        clk,
    input        rst,
    input        rx_line,

    output reg [7:0] rx_data,
    output reg       rx_data_valid,
    output reg       parity_error,
    output reg       frame_error
);

    // --------------------------------------------------
    // Baud-rate calculation
    // --------------------------------------------------

    localparam integer BIT_TICKS =
        (CLKS_PER_BIT != 0) ?
        CLKS_PER_BIT :
        (CLK_FREQ / BAUD_RATE);

    localparam integer HALF_BIT_TICKS =
        BIT_TICKS / 2;

    // --------------------------------------------------
    // UART receiver states
    // --------------------------------------------------

    localparam IDLE   = 3'd0;
    localparam START  = 3'd1;
    localparam DATA   = 3'd2;
    localparam PARITY = 3'd3;
    localparam STOP   = 3'd4;

    // --------------------------------------------------
    // Registers
    // --------------------------------------------------

    reg [2:0]  state;
    reg [31:0] clk_count;
    reg [2:0]  bit_index;

    reg [7:0]  data_reg;
    reg        parity_bit;

    // --------------------------------------------------
    // UART Receiver
    // --------------------------------------------------

    always @(posedge clk) begin

        if (rst) begin

            state          <= IDLE;
            clk_count      <= 32'd0;
            bit_index      <= 3'd0;

            data_reg       <= 8'd0;
            parity_bit     <= 1'b0;

            rx_data        <= 8'd0;
            rx_data_valid  <= 1'b0;
            parity_error   <= 1'b0;
            frame_error    <= 1'b0;

        end

        else begin

            // Default: status signals are pulses
            rx_data_valid <= 1'b0;
            parity_error  <= 1'b0;
            frame_error   <= 1'b0;

            case (state)

                // --------------------------------------
                // IDLE
                // --------------------------------------

                IDLE: begin

                    clk_count <= 32'd0;
                    bit_index <= 3'd0;

                    // UART idle = HIGH
                    // Start bit = LOW
                    if (rx_line == 1'b0) begin

                        state <= START;

                    end

                end


                // --------------------------------------
                // START BIT
                // --------------------------------------

                START: begin

                    // Wait until middle of start bit
                    if (clk_count < HALF_BIT_TICKS - 1) begin

                        clk_count <= clk_count + 1'b1;

                    end

                    else begin

                        clk_count <= 32'd0;

                        // Confirm start bit is still LOW
                        if (rx_line == 1'b0) begin

                            bit_index <= 3'd0;
                            state     <= DATA;

                        end

                        else begin

                            // False start
                            state <= IDLE;

                        end

                    end

                end


                // --------------------------------------
                // DATA BITS
                // --------------------------------------

                DATA: begin

                    if (clk_count < BIT_TICKS - 1) begin

                        clk_count <= clk_count + 1'b1;

                    end

                    else begin

                        clk_count <= 32'd0;

                        // LSB first
                        data_reg[bit_index] <= rx_line;

                        if (bit_index < 3'd7) begin

                            bit_index <= bit_index + 1'b1;

                        end

                        else begin

                            bit_index <= 3'd0;

                            if (PARITY_MODE != 0)
                                state <= PARITY;
                            else
                                state <= STOP;

                        end

                    end

                end


                // --------------------------------------
                // PARITY BIT
                // --------------------------------------

                PARITY: begin

                    if (clk_count < BIT_TICKS - 1) begin

                        clk_count <= clk_count + 1'b1;

                    end

                    else begin

                        clk_count  <= 32'd0;
                        parity_bit <= rx_line;

                        state <= STOP;

                    end

                end


                // --------------------------------------
                // STOP BIT
                // --------------------------------------

                STOP: begin

                    if (clk_count < BIT_TICKS - 1) begin

                        clk_count <= clk_count + 1'b1;

                    end

                    else begin

                        clk_count <= 32'd0;

                        // Check stop bit
                        if (rx_line != 1'b1)
                            frame_error <= 1'b1;

                        // Check parity
                        if (PARITY_MODE == 1) begin

                            if (parity_bit != ^data_reg)
                                parity_error <= 1'b1;

                        end

                        else if (PARITY_MODE == 2) begin

                            if (parity_bit != ~^data_reg)
                                parity_error <= 1'b1;

                        end

                        // Store received data
                        rx_data <= data_reg;

                        // Valid only when no errors
                        if ((rx_line == 1'b1) &&
                            ((PARITY_MODE == 0) ||
                             (PARITY_MODE == 1 && parity_bit == ^data_reg) ||
                             (PARITY_MODE == 2 && parity_bit == ~^data_reg))) begin

                            rx_data_valid <= 1'b1;

                        end

                        state <= IDLE;

                    end

                end


                // --------------------------------------
                // DEFAULT
                // --------------------------------------

                default: begin

                    state          <= IDLE;
                    clk_count      <= 32'd0;
                    bit_index      <= 3'd0;

                    data_reg       <= 8'd0;
                    parity_bit     <= 1'b0;

                    rx_data        <= 8'd0;
                    rx_data_valid  <= 1'b0;
                    parity_error   <= 1'b0;
                    frame_error    <= 1'b0;

                end

            endcase

        end

    end

endmodule
