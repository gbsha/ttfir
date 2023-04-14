import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


# segments = [ 63, 6, 91, 79, 102, 109, 124, 7, 127, 103 ]

@cocotb.test()
async def test_gbsha_top(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut.x_in.value = -1

    dut._log.info("checking...")
    for i in range(10):
        dut._log.info("check {}".format(i))
        await ClockCycles(dut.clk, 1)
        print(f"{dut.y_out.value.binstr}")
