`default_nettype none

module gbsha_top #(parameter N_TAPS = 2,
                             BW_in = 2,
                             BW_out = 3,
                             BW_product = 2,
                             BW_sum = 3
                             )
(
  input [7:0] io_in,
  output [7:0] io_out
);
    // control signals
    wire clk = io_in[0];
    wire reset = io_in[1];
    
    // inputs and outputs
    wire signed [BW_in - 1:0] x_in = io_in[BW_in - 1 + 2:2];
    wire signed [BW_out - 1:0] y_out;
    assign io_out[BW_out - 1:0] = y_out;
    if (BW_out <= 7)
        assign io_out[7:BW_out] = 0;

    reg signed [BW_in - 1:0] x_old;
    reg signed [BW_sum - 1:0] y;
    
    wire signed [BW_product - 1:0] product [0:N_TAPS - 1];
    wire signed [BW_sum -1:0] sum;

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            x_old <= 0;
            y <= 0;
        end else begin
            x_old <= x_in;
            y <= sum;
        end
    end
    assign product[0] = 2 * x_in;
    assign product[1] = x_old;
    assign sum = product[0] + product[1];

    assign y_out = y[BW_sum - 1:BW_sum - BW_out];
endmodule
