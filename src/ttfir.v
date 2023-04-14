`default_nettype none

module gbsha_top #(parameter N_TAPS = 2,
                             BW_in = 2,
                             BW_out = 4,
                             BW_product = 3, // TODO: clarify required sum bitwidth
                             BW_sum = 4
                             )
(
  input [7:0] io_in,
  output [7:0] io_out
);
    wire clk = io_in[0];
    wire reset = io_in[1];
    wire signed [BW_in - 1:0] x_in = io_in[BW_in - 1 + 2:2];
    wire signed [BW_out - 1:0] y_out;
    assign io_out[BW_out - 1:0] = y_out;

    reg signed [BW_in - 1:0] x;
    wire signed [BW_sum - 1:0] y;
    wire signed [BW_product - 1:0] product [0:N_TAPS - 1];
    reg signed [BW_sum - 1:0] sum [0:N_TAPS - 1];

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            x <= 0;
            sum[0] <= 0;
            sum[1] <= 0;
        end else begin
            x <= x_in;
        end
    end

    always @(posedge clk) begin
        sum[0] <= product[0] + sum[1];
        sum[1] <= product[1];
    end

    // TODO: use generate
    assign product[0] = -x;
    assign product[1] = x;

    assign y = sum[0];
    assign y_out = y[BW_sum - 1:BW_sum - BW_out];
endmodule
