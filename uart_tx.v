module uart_tx(
    input clk,
    input rst,
    input baud_tick,
    input [7:0] data_in,
    input tx_start,
    output reg tx,
    output reg tx_done
);
    reg [3:0] state;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            state     <= 0;
            tx        <= 1;
            tx_done   <= 0;
            shift_reg <= 0;
        end
        else begin
            tx_done <= 0;
            case (state)
                0: begin
                    tx <= 1;
                    if (tx_start) begin
                        shift_reg <= data_in;
                        state     <= 1;
                    end
                end
                1: if (baud_tick) begin tx <= 0; state <= 2; end  // start bit
                2: if (baud_tick) begin tx <= shift_reg[0]; state <= 3; end
                3: if (baud_tick) begin tx <= shift_reg[1]; state <= 4; end
                4: if (baud_tick) begin tx <= shift_reg[2]; state <= 5; end
                5: if (baud_tick) begin tx <= shift_reg[3]; state <= 6; end
                6: if (baud_tick) begin tx <= shift_reg[4]; state <= 7; end
                7: if (baud_tick) begin tx <= shift_reg[5]; state <= 8; end
                8: if (baud_tick) begin tx <= shift_reg[6]; state <= 9; end
                9: if (baud_tick) begin tx <= shift_reg[7]; state <= 10; end
                10: if (baud_tick) begin tx <= 1; tx_done <= 1; state <= 0; end // stop bit
            endcase
        end
    end
endmodule
