import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

def binstr2signed_int(x):
    bw = len(x)
    if bw == 1:
        return -int(x, 2)
    return int(x[1:], 2) - int(x[0], 2) * 2**(bw - 1)

# copy parameters to tb.v, ttfir.v, test.py
# as files may be used individually
N_TAPS = 3
BW_in =  6
BW_out = 8

# test sequence for multiplication
input =                    [1,-3, 0, 1, 3, 4,  5,  6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
output_expected = [0, 0, 0, 0, 0, 0,-3,-8,-9,-11,-13, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

# # test sequence for multiplication
# input =             [ 3, 1, 3,  4,  5,  6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
# input_sign =        [ 1, 0, 0,  1,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
# output_expected = [0, 0,-3,-9, 12,-15,-18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

# # test sequence for subtraction
# input =              [3, 1, 3,  4,  5,  6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
# output_expected = [0,-3,-2, 0,  1,  2,  3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3]

@cocotb.test()
async def test_gbsha_top(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut._log.info("checking...")
    for i, x in enumerate(input):
        dut.x_in.value = x
        await ClockCycles(dut.clk, 1)
        output_actual = binstr2signed_int(dut.y_out.value.binstr)
        print(f"{output_actual = }, expected = {output_expected[i]}")
