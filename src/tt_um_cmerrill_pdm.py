from amaranth import *
from amaranth.cli import main
from amaranth.lib import enum

from amaranth.lib.coding import GrayEncoder
from amaranth.hdl.ast  import Rose, Fell


class OE(enum.Enum, shape=1):
    INPUT = 0
    OUTPUT = 1


class SPIShiftReg(Elaboratable):
    def __init__(self, width=8, edge="pos", clk_inv=False):
        self._edge = edge
        self._clk_inv = clk_inv
        self.sdi = Signal(1)
        self.sclk = Signal(1)
        self.cs_l = Signal(1)
        self.dout = Signal(width)
        self.reset = Signal(1)
    
    def elaborate(self, platform):
        m = Module()

        # Boilerplate: Set up sclk clock domain
        m.domains.sclk = sclk_domain = ClockDomain("sclk", local=True, clk_edge=self._edge)
        if self._clk_inv:
            m.d.comb += sclk_domain.clk.eq(self.sclk)
        else: 
            m.d.comb += sclk_domain.clk.eq(~self.sclk)
        m.d.comb += sclk_domain.rst.eq(self.reset)

        with m.If(self.cs_l == Const(0)):
            for i in range(len(self.dout) - 1):
                m.d.sclk += self.dout[i+1].eq(self.dout[i])
            m.d.sclk += self.dout[0].eq(self.sdi)

        return m
        

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
            # cd_sync.rst.eq(Const(0)), # Testbench: force out of reset
        ]

        # Boilerplate: Zero unused outputs
        m.d.comb += [
            self.uio_oe.eq(Repl(OE.INPUT,8)), # IO pins set as input (not output)
            self.uio_out.eq(Const(0)),
            self.uo_out.eq(Const(0)),
        ]

        # Select how we get the input data (parallel, SPI)
        self.ui_in_buf = Signal(unsigned(8))
        m.d.comb += [
            self.ui_in_buf.eq(self.ui_in),
            # self.ui_in_buf.eq(Const(60, 8)),  # Testbench: Set fixed PDM value
        ]

        ## PDM Implementation
        # Feedback Loop Variables
        self.data_in = Signal(signed(8))
        self.error = Signal(signed(9))
        self.error_out = Signal(signed(8))
        self.data_out = Signal(signed(8), reset=-128)

        # Center the data
        m.d.comb += self.data_in.eq(self.ui_in_buf - Const(-128))
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

        ## PWM Implementation
        # PWM It
        # FIXME: Do we need to buffer the input based on full PWM loops?
        self.pwm_counter = Signal(unsigned(8))
        self.pwm_out = Signal(1)
        with m.If(self.pwm_counter <= self.ui_in_buf):
            m.d.sync += self.pwm_out.eq(Const(1))
        with m.Else():
            m.d.sync += self.pwm_out.eq(Const(0))
        m.d.sync += self.pwm_counter.eq(self.pwm_counter + 1)
        m.d.comb += self.uo_out[4].eq(self.pwm_out)

        ## PFM Implementations
        # PFM(?) It
        # FIXME: Do we need to buffer the input based on full loops?
        self.pfm_counter = Signal(unsigned(9))
        self.pfm_out = Signal(1)
        self.pfm_in = Signal(unsigned(8))
        m.d.comb += self.pfm_in.eq(Const(255) - self.ui_in_buf)
        with m.If(((self.pfm_counter >> 1) == self.pfm_in)
                    & (self.pfm_counter[0] == Const(1))): # Divide clock by two so that we always have a square wave
            m.d.sync += self.pfm_out.eq(Const(1))
            m.d.sync += self.pfm_counter.eq(Const(0))
        with m.Else():
            m.d.sync += self.pfm_out.eq(Const(0))
            m.d.sync += self.pfm_counter.eq(self.pfm_counter + 1)
        m.d.comb += self.uo_out[2].eq(self.pfm_out)

        # PFM(?) It, V2
        # FIXME: Do we need to buffer the input based on full loops?
        #        Does that even make sense with PFM like this?
        self.pfm2_counter = Signal(unsigned(9))
        self.pfm2_out = Signal(1)
        self.pfm2_in = Signal(unsigned(9))
        m.d.comb += self.pfm2_in.eq((Const(255) - self.ui_in_buf) << 1)
        with m.If(self.pfm2_counter >= (self.pfm2_in >> 1)):
            m.d.sync += self.pfm2_out.eq(Const(1))
        with m.Else():
            m.d.sync += self.pfm2_out.eq(Const(0))
        # Counter
        with m.If(self.pfm2_counter > self.pfm2_in):
            m.d.sync += self.pfm2_counter.eq(Const(0))
        with m.Else():
            m.d.sync += self.pfm2_counter.eq(self.pfm2_counter + 1)
        # Output
        m.d.comb += self.uo_out[3].eq(self.pfm2_out)
            
        # Boilerplate: Return module
        return m


if __name__ == "__main__":
    top = Top()
    main(top, name="tt_um_cmerrill_pdm", ports=[top.ui_in, top.uo_out, top.uio_in, top.uio_out, top.uio_oe, top.ena, top.clk, top.rst_n])