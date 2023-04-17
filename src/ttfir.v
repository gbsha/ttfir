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
    wire [BW_in - 1:0] x_in = io_in[BW_in - 1 + 2:2];
    wire [BW_out - 1:0] y_out;
    assign io_out[BW_out - 1:0] = y_out;
    if (BW_out < 8)
        assign io_out[7:BW_out] = 0;

    // shift register
    reg [BW_in - 1:0] x [N_TAPS - 1: 0];
    reg [BW_in - 1:0] coefficient [N_TAPS - 1: 0];

    always @(posedge clk) begin
        // initialize shift register with zeros
        if (reset) begin
            coefficients_loaded <= 0;
            for (integer i = 0; i < N_TAPS; i = i + 1) begin
                x[i] <= 0;
                coefficient[i] <= 0;
            end                
        end else if (coefficients_loaded < N_TAPS) begin
            coefficient[coefficients_loaded] <= x_in;
            coefficients_loaded <= coefficients_loaded + 1;
        end else begin
            x[0] <= x_in;
            for (integer i = 1; i < N_TAPS; i = i + 1) begin
                x[i] <= x[i - 1];
            end                
        end
    end

    assign y_out = x[N_TAPS - 1];
endmodule
