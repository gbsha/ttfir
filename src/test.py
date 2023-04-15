import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

# copy parameters to tb.v, ttfir.v, test.py
# as files may be used individually
N_TAPS = 1
BW_in = 6
BW_out = 8

input =              [3, 1, 3, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
output_expected = [0, 0, 3, 9,12,15,18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
        dut.x_in.value = x % 2**BW_in
        await ClockCycles(dut.clk, 1)
        output_actual = dut.y_out.value.integer
        print(f"{output_actual = }, expected = {output_expected[i] % 2**BW_out}")
