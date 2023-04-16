`default_nettype none

// copy parameters to tb.v, ttfir.v, test.py
// as files may be used individually
module gbsha_top #(parameter N_TAPS = 1,
                             BW_in = 6,
                             BW_product = 12,
                             BW_out = 8
                             )
(
  input [7:0] io_in,
  output [7:0] io_out
);
    // control signals
    wire clk = io_in[0];
    wire reset = io_in[1];
    reg coefficient_loaded;

    // inputs and output
    wire signed [BW_in - 1:0] x_in = io_in[BW_in - 1 + 2:2];
    wire signed [BW_out - 1:0] y_out;
    assign io_out[BW_out - 1:0] = y_out;
    if (BW_out < 8)
        assign io_out[7:BW_out] = 0;

    // storage for input, multiplier, output
    reg signed [BW_in - 1:0] coefficient;
    reg signed [BW_in - 1:0] x;
    wire signed [BW_product - 1:0] product;

    always @(posedge clk) begin
        // initialize shift register with zeros
        if (reset) begin
            x <= 0;
            coefficient <= 0;
            coefficient_loaded <= 0;
        end else if (!coefficient_loaded) begin
            coefficient <= x_in;
            coefficient_loaded <= 1;
        end else begin
            x <= x_in;
        end
    end

    assign product = x * coefficient;
    assign y_out = product[BW_out - 1:0];
endmodule
