`default_nettype none

// copy parameters to tb.v, ttfir.v, test.py
// as files may be used individually
module gbsha_top #(parameter N_TAPS = 2,
                             BW_in = 1,
                             BW_out = 1
                             )
(
  input [7:0] io_in,
  output [7:0] io_out
);
    // control signals
    wire clk = io_in[0];
    wire reset = io_in[1];

    // 
    wire [BW_in - 1:0] x_in = io_in[BW_in - 1 + 2:2];
    wire [BW_out - 1:0] y_out;
    assign io_out[BW_out - 1:0] = y_out;
    assign io_out[7:BW_out] = 0;

    // shift register
    reg [BW_in - 1:0] x_d1;
    reg [BW_in - 1:0] x_d2;

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            x_d1 <= 0;
            x_d2 <= 0;
        end else begin
            x_d1 <= x_in;
            x_d2 <= x_d1;
        end
    end

    assign y_out = x_d2;
endmodule
