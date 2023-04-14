import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

def binstr2int(x):
    bw = len(x)
    if bw == 1:
        return -int(x, 2)
    return int(x[1:], 2) - int(x[0], 2) * 2**(bw - 1)

input = [3, 2, 1, 3, 2, 1, 0]
output_expected = [0, 3, 2, 1, 3, 2, 1]
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
        output_actual = dut.y_out.value.integer
        print(f"{output_actual = }, expected = {output_expected[i]}")
