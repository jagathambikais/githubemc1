module uart_top(
    input clk,
    input rst,
    input [7:0] tx_data,
    input tx_start,
    output tx_done,
    output rx_done,
    output [7:0] rx_data
);
    wire baud_tick;
    wire tx_line;

    baud_gen bg(
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    uart_tx tx(
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .data_in(tx_data),
        .tx_start(tx_start),
        .tx(tx_line),
        .tx_done(tx_done)
    );

    uart_rx rx(
        .clk(clk),
        .rst(rst),
        .rx(tx_line),
        .data_out(rx_data),
        .rx_done(rx_done)
    );
endmodule
