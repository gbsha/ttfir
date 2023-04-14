`default_nettype none

// copy parameters to tb.v, ttfir.v, test.py
// as files may be used individually
module gbsha_top #(parameter N_TAPS = 10,
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
    reg [BW_in - 1:0] x [N_TAPS - 1: 0];

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            for (integer i = 0; i < N_TAPS; i = i + 1) begin
                x[i] <= 0;
            end                
        end else begin
            x[0] <= x_in;
            for (integer i = 1; i < N_TAPS; i = i + 1) begin
                x[i] <= x[i - 1];
            end                
        end
    end

    assign y_out = x[N_TAPS - 1];
endmodule
