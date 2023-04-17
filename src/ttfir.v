`default_nettype none

// copy parameters to tb.v, ttfir.v, test.py
// as files may be used individually
module gbsha_top #(parameter N_TAPS = 5,
                             BW_in = 6,
                             BW_out = 8
                             )
(
  input [7:0] io_in,
  output [7:0] io_out
);
    // control signals
    wire clk = io_in[0];
    wire reset = io_in[1];
    reg [3:0] coefficients_loaded;

    // 
    wire signed [BW_in - 1:0] x_in = io_in[BW_in - 1 + 2:2];
    wire [BW_out - 1:0] y_out;
    assign io_out[BW_out - 1:0] = y_out;
    if (BW_out < 8)
        assign io_out[7:BW_out] = 0;

    // shift register
    reg [BW_in - 1:0] x [N_TAPS - 1: 0];
    reg [BW_in - 1:0] coefficient [N_TAPS - 1: 0];
    reg [N_TAPS - 1:0] x_sign;
    reg [N_TAPS - 1:0] coefficient_sign;

    always @(posedge clk) begin
        // initialize shift register with zeros
        if (reset) begin
            coefficients_loaded <= 0;
            for (integer i = 0; i < N_TAPS; i = i + 1) begin
                x[i] <= 0;
                x_sign[i] <= 0;
                coefficient[i] <= 0;
                coefficient_sign[i] <= 0;
            end                
        end else if (coefficients_loaded < N_TAPS) begin
            case(x_in[BW_in - 1])
                1'b0: coefficient[coefficients_loaded] <= x_in;
                2'b1: coefficient[coefficients_loaded] <= -x_in;
            endcase
            coefficient_sign[coefficients_loaded] = x_in[BW_in - 1];
            coefficients_loaded <= coefficients_loaded + 1;
        end else begin
            case(x_in[BW_in - 1])
                1'b0: x[0] <= x_in;
                1'b1: x[0] <= -x_in;
            endcase
            x_sign[0] <= x_in[BW_in - 1];
            for (integer i = 1; i < N_TAPS; i = i + 1) begin
                x[i] <= x[i - 1];
                x_sign[i] <= x_sign[i - 1];
            end
        end
    end

    // calculate products
    wire signed [2 * BW_in:0] product;
    // reg signed [2 * BW_in:0] product_signed;

    // Tap 0
    assign product = x[0] * coefficient[0];

    // always @(*) begin
    //     case(x_sign[0] + coefficient_sign[0])
    //         1'b0: product_signed = product;
    //         1'b1: product_signed = -product;
    //     endcase
    // end

    // assign y_out = product_signed[BW_out - 1:0];
    assign y_out = product[BW_out - 1:0];
endmodule
