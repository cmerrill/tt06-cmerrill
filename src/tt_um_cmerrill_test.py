from amaranth import *
from amaranth.cli import main
from amaranth.lib import enum
from amaranth.lib import wiring
from amaranth.lib.wiring import In, Out

from amaranth.lib.coding import GrayEncoder

class OE(enum.Enum, shape=1):
    INPUT = 0
    OUTPUT = 1

class Top(wiring.Component):
    ui_in: In(8)    # Dedicated Inputs
    uo_out: Out(8)  # Dedicated Outputs
    uio_in: In(8)   # IOs: Input Path
    uio_out: Out(8) # IOs: Output Path
    uio_oe: Out(8)  # IOs: Enable path (active high: 0=input, 1=output)
    ena: In(1)      # Enable
    clk: In(1)      # Clock
    rst_n: In(1)    # Reset
    
    def elaborate(self, platform):
        m = Module()

        # Boilerplate: Set up synchronous clock domain
        m.domains.sync = cd_sync = ClockDomain(local=True)
        m.d.comb += [
            cd_sync.clk.eq(self.clk),
            cd_sync.rst.eq(~self.rst_n),
        ]

        m.d.comb += [
            self.uio_oe.eq(Const(0)),
            self.uio_out.eq(Const(0)),
        ]


        # Clocked Adder
        m.d.sync += [
            self.uo_out.eq(self.ui_in + self.uio_in),
        ]

        # Boilerplate: Return module
        return m




if __name__ == "__main__":
    top = Top()
    main(top, name="tt_um_cmerrill_test", ports=[top.ui_in, top.uo_out, top.uio_in, top.uio_out, top.uio_oe, top.ena, top.clk, top.rst_n])