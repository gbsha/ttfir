`default_nettype none

module gbsha_top #(parameter N_TAPS = 1,
                             BW_in = 2,
                             BW_out = 2
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

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            x_d1 <= 0;
        end else begin
            x_d1 <= x_in;
        end
    end

    assign y_out = x_d1;
endmodule
