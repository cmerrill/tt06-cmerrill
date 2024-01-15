from amaranth import *
from amaranth.cli import main
from amaranth.lib import enum

from amaranth.lib.coding import GrayEncoder

class OE(enum.Enum, shape=1):
    INPUT = 0
    OUTPUT = 1


class Top(Elaboratable):
    def __init__(self):
        self.ui_in = Signal(8)    # Dedicated Inputs
        self.uo_out = Signal(8)   # Dedicated Outputs
        self.uio_in = Signal(8)   # IOs: Input Path
        self.uio_out = Signal(8)  # IOs: Output Path
        self.uio_oe = Signal(8)   # IOs: Enable path (active high: 0=input, 1=output)
        self.ena = Signal(1)      # Enable
        self.clk = Signal(1)      # Clock
        self.rst_n = Signal(1)    # Reset
    
    def elaborate(self, platform):
        m = Module()

        # Boilerplate: Set up synchronous clock domain
        m.domains.sync = cd_sync = ClockDomain(local=True)
        m.d.comb += [
            cd_sync.clk.eq(self.clk),
            cd_sync.rst.eq(~self.rst_n),
        ]

        # Boilerplate: Zero unused outputs
        m.d.comb += [
            self.uio_oe.eq(OE.INPUT),
            self.uio_out.eq(Const(0)),
            self.uo_out.eq(Const(0)),
        ]

        # Feedback Loop Variables
        self.data_in = Signal(signed(8))
        self.error = Signal(signed(9))
        self.error_out = Signal(signed(8))
        self.data_out = Signal(signed(8), reset=-128)

        # Center the data
        m.d.comb += self.data_in.eq(self.ui_in - Const(-128))
        m.d.sync += self.error.eq(self.data_in + (self.error_out - self.data_out))

        # Saturating Error Add
        with m.If(self.error > Const(127)):
            m.d.comb += self.error_out.eq(Const(127))
        with m.Elif(self.error < Const(-128)):
            m.d.comb += self.error_out.eq(Const(-128))
        with m.Else():
            m.d.comb += self.error_out.eq(self.error[0:8])

        # PDM It
        self.pdm_out = Signal(1)
        with m.If(self.error_out >= Const(0)):
            m.d.comb += self.data_out.eq(Const(127))
            m.d.sync += self.pdm_out.eq(Const(1))
        with m.Else():
            m.d.comb += self.data_out.eq(Const(-128))
            m.d.sync += self.pdm_out.eq(Const(0))
        m.d.comb += self.uo_out[0].eq(self.pdm_out)

        # Boilerplate: Return module
        return m


if __name__ == "__main__":
    top = Top()
    main(top, name="tt_um_cmerrill_pdm", ports=[top.ui_in, top.uo_out, top.uio_in, top.uio_out, top.uio_oe, top.ena, top.clk, top.rst_n])