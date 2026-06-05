module uart_rx(
    input clk,
    input rst,
    input rx,
    output reg [7:0] data_out,
    output reg rx_done
);
    reg [3:0]  state;
    reg [12:0] clk_count;
    reg [7:0]  shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            state     <= 0;
            rx_done   <= 0;
            clk_count <= 0;
            shift_reg <= 0;
            data_out  <= 0;
        end
        else begin
            rx_done <= 0;
            case (state)
                0: begin
                    clk_count <= 0;
                    if (rx == 0) state <= 1;  // detect start bit
                end
                // wait half bit to sample middle
                1: begin
                    if (clk_count == 13'd2603) begin
                        clk_count <= 0;
                        state     <= 2;
                    end
                    else clk_count <= clk_count + 1;
                end
                // sample 8 data bits
                2: begin
                    if (clk_count == 13'd5207) begin
                        clk_count        <= 0;
                        shift_reg[0]     <= rx;
                        state            <= 3;
                    end
                    else clk_count <= clk_count + 1;
                end
                3: begin
                    if (clk_count == 13'd5207) begin
                        clk_count    <= 0;
                        shift_reg[1] <= rx;
                        state        <= 4;
                    end
                    else clk_count <= clk_count + 1;
                end
                4: begin
                    if (clk_count == 13'd5207) begin
                        clk_count    <= 0;
                        shift_reg[2] <= rx;
                        state        <= 5;
                    end
                    else clk_count <= clk_count + 1;
                end
                5: begin
                    if (clk_count == 13'd5207) begin
                        clk_count    <= 0;
                        shift_reg[3] <= rx;
                        state        <= 6;
                    end
                    else clk_count <= clk_count + 1;
                end
                6: begin
                    if (clk_count == 13'd5207) begin
                        clk_count    <= 0;
                        shift_reg[4] <= rx;
                        state        <= 7;
                    end
                    else clk_count <= clk_count + 1;
                end
                7: begin
                    if (clk_count == 13'd5207) begin
                        clk_count    <= 0;
                        shift_reg[5] <= rx;
                        state        <= 8;
                    end
                    else clk_count <= clk_count + 1;
                end
                8: begin
                    if (clk_count == 13'd5207) begin
                        clk_count    <= 0;
                        shift_reg[6] <= rx;
                        state        <= 9;
                    end
                    else clk_count <= clk_count + 1;
                end
                9: begin
                    if (clk_count == 13'd5207) begin
                        clk_count    <= 0;
                        shift_reg[7] <= rx;
                        state        <= 10;
                    end
                    else clk_count <= clk_count + 1;
                end
                // stop bit
                10: begin
                    if (clk_count == 13'd5207) begin
                        data_out  <= shift_reg;
                        rx_done   <= 1;
                        clk_count <= 0;
                        state     <= 0;
                    end
                    else clk_count <= clk_count + 1;
                end
            endcase
        end
    end
endmodule