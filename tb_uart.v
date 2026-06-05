`timescale 1ns/1ps
module tb_uart;

    reg clk;
    reg rst;
    reg [7:0] tx_data;
    reg tx_start;

    wire tx_done;
    wire rx_done;
    wire [7:0] rx_data;

    uart_top uut(
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_done(tx_done),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, tb_uart);

        rst      = 1;
        tx_start = 0;
        tx_data  = 8'h00;
        #1000;
        rst = 0;
        #1000;

        tx_data  = 8'hA5;
        tx_start = 1;
        #20;
        tx_start = 0;

        // wait for rx_done
        wait(rx_done == 1);
        #100;

        if (rx_data == 8'hA5)
            $display("SUCCESS! Received: %h", rx_data);
        else
            $display("FAILED! Got: %h", rx_data);

        $finish;
    end
endmodule
