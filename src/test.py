import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

def binstr2int(x):
    bw = len(x)
    if bw == 1:
        return -int(x, 2)
    return int(x[1:], 2) - int(x[0], 2) * 2**(bw - 1)

input = [-1, 1, 1, -2, 1, -1, 1, 0, 1, 0, 0, 0, 0, 0]
output_expected = [0, 0, 1, -2, 0, 3, -3, 2, -2, 1, -1, 1, 0, 0]
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
    output = []
    for x in input:
        dut.x_in.value = x
        await ClockCycles(dut.clk, 1)
        output.append(binstr2int(dut.y_out.value.binstr))
    for (actual, expected) in zip(output, output_expected):
        assert actual == expected