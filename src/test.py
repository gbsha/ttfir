import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

def binstr2signed_int(x):
    bw = len(x)
    if bw == 1:
        return -int(x, 2)
    return int(x[1:], 2) - int(x[0], 2) * 2**(bw - 1)

N_TAPS = 4

@cocotb.test()
async def test_delay(dut):
    input =           [0] * (N_TAPS - 1) + [8, 8, 0, 0]
    output_expected = [0] * (N_TAPS + 2) + [1]
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut._log.info("checking...")
    for clock_cycle, (x, y_expected) in enumerate(zip(input, output_expected)):
        dut.x_in.value = x
        await ClockCycles(dut.clk, 1)
        y_actual = binstr2signed_int(dut.y_out.value.binstr)
        assert y_actual == y_expected, f"{clock_cycle = }: {y_actual = }, {y_expected = }"


@cocotb.test()
async def test_identity_function(dut):
    input =           [0] * (N_TAPS - 1) + [16] + [x * 4 for x in range(-8, 8)] + [0, 0]
    output_expected = [0] * (N_TAPS + 2) + [x for x in range(-8, 8)]
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut._log.info("checking...")
    for clock_cycle, (x, y_expected) in enumerate(zip(input, output_expected)):
        dut.x_in.value = x
        await ClockCycles(dut.clk, 1)
        y_actual = binstr2signed_int(dut.y_out.value.binstr)
        assert y_actual == y_expected, f"{clock_cycle = }: {y_actual = }, {y_expected = }"


@cocotb.test()
async def test_minus_function(dut):
    input =           [0] * (N_TAPS - 1) + [-32] + [x * 2 for x in range(-16, 16)] + [0, 0]
    output_expected = [0] * (N_TAPS + 2) + [-x for x in range(-16, 16)]
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut._log.info("checking...")
    for clock_cycle, (x, y_expected) in enumerate(zip(input, output_expected)):
        dut.x_in.value = x
        await ClockCycles(dut.clk, 1)
        y_actual = binstr2signed_int(dut.y_out.value.binstr)
        assert y_actual == y_expected, f"{clock_cycle = }: {y_actual = }, {y_expected = }"


@cocotb.test()
async def test_maximum_value(dut):
    input =           [-32 for _ in range(2 * N_TAPS)] + 2 * [0]
    output_expected = [0] * (N_TAPS + 2) + [i * 16 for i in range(1, N_TAPS + 1)]
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut._log.info("checking...")
    for clock_cycle, (x, y_expected) in enumerate(zip(input, output_expected)):
        dut.x_in.value = x
        await ClockCycles(dut.clk, 1)
        y_actual = binstr2signed_int(dut.y_out.value.binstr)
        assert y_actual == y_expected, f"{clock_cycle = }: {y_actual = }, {y_expected = }"


@cocotb.test()
async def test_minimum_value(dut):
    input =           [-32] * N_TAPS + [31] * N_TAPS
    output_expected = [0] * (N_TAPS + 2) + [-32 * 31 * i // 2**6  for i in range(1, N_TAPS + 1)]
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut._log.info("checking...")
    for clock_cycle, (x, y_expected) in enumerate(zip(input, output_expected)):
        dut.x_in.value = x
        await ClockCycles(dut.clk, 1)
        y_actual = binstr2signed_int(dut.y_out.value.binstr)
        assert y_actual == y_expected, f"{clock_cycle = }: {y_actual = }, {y_expected = }"