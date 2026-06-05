module baud_gen(
    input clk,
    input rst,
    output reg baud_tick
);
    reg [12:0] count;
    always @(posedge clk) begin
        if (rst) begin
            count     <= 0;
            baud_tick <= 0;
        end
        else begin
            if (count == 13'd5207) begin
                count     <= 0;
                baud_tick <= 1;
            end
            else begin
                count     <= count + 1;
                baud_tick <= 0;
            end
        end
    end
endmodule
