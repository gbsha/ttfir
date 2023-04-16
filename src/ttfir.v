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
    wire [BW_in - 1:0] x_in = io_in[BW_in - 1 + 2:2];
    reg signed [BW_out - 1:0] y_out;
    assign io_out[BW_out - 1:0] = y_out;
    if (BW_out < 8)
        assign io_out[7:BW_out] = 0;

    // storage for input, multiplier, output
    reg [BW_in - 1:0] coefficient;
    reg [BW_in - 1:0] x;
    wire [BW_product - 1:0] product;
    wire [BW_product - 1:0] product_signed;
    reg coefficient_sign;
    reg x_sign;

    always @(posedge clk) begin
        // initialize shift register with zeros
        if (reset) begin
            x <= 0;
            x_sign <= 0;
            coefficient <= 0;
            coefficient_sign <= 0;
            coefficient_loaded <= 0;
        end else if (!coefficient_loaded) begin
            coefficient <= x_in[BW_in - 2:0];
            coefficient_sign <= x_in[BW_in - 1];
            coefficient_loaded <= 1;
        end else begin
            x <= x_in[BW_in - 2:0];
            x_sign <= x_in[BW_in - 1];
        end
    end

    assign product = x * coefficient;
    assign product_signed = product;

    always @(*) begin
        case({x_sign, coefficient_sign})
            2'b00 : y_out = product_signed[BW_out - 1:0];
            2'b01 : y_out = - product_signed[BW_out - 1:0];
            2'b10 : y_out = - product_signed[BW_out - 1:0];
            2'b11 : y_out = product_signed[BW_out - 1:0];
        endcase
    end
endmodule
