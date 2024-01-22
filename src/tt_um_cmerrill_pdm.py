from amaranth import *
from amaranth.cli import main
from amaranth.lib import enum
from amaranth.lib.cdc  import FFSynchronizer


class OE(enum.Enum, shape=1):
    INPUT = 0
    OUTPUT = 1


class EdgeDetect(Elaboratable):
    def __init__(self, edge="pos"):
        self.inp = Signal(1)
        self.out = Signal(1)
        self._edge = edge

    def elaborate(self, platform):
        m = Module()

        # Edge detect - comapred delayed signal with current value
        # Output is a single-clock width pulse on an edge
        input_buf = Signal(1)
        m.d.sync += input_buf.eq(self.inp)
        if self._edge == "pos":
            m.d.comb += self.out.eq((~input_buf) & self.inp)
        elif self._edge == "neg":
            m.d.comb += self.out.eq(input_buf & (~self.inp))
        else:
            raise Exception("Edge must be 'pos' or 'neg'.")
        
        return m


class SPIShiftReg(Elaboratable):
    def __init__(self, width=8, edge="pos", clk_inv=False):
        # Configuration
        self._edge = edge
        self._clk_inv = clk_inv
        self._width = width
        # SPI Input Signals
        self.sdi = Signal(1)
        self.sclk = Signal(1)
        self.cs_l = Signal(1)
        self.rst = Signal(1)
        # Output signals
        self.dout = Signal(width)
        self.cs_out = Signal(1)
    
    def elaborate(self, platform):
        m = Module()

        # Boilerplate: Set up sclk clock domain
        m.domains.spi = sclk_domain = ClockDomain("spi", local=True, clk_edge=self._edge, async_reset=True)
        if self._clk_inv:
            m.d.comb += sclk_domain.clk.eq(~self.sclk)
        else:
            m.d.comb += sclk_domain.clk.eq(self.sclk)
        m.d.comb += sclk_domain.rst.eq(self.rst)

        # Assumes MSB first
        spi_data_live = Signal(len(self.dout))
        with m.If(self.cs_l == Const(0)):
            m.d.spi += spi_data_live[1:].eq(spi_data_live[:-1])
            m.d.spi += spi_data_live[0].eq(self.sdi)
        
        # Shift to CS clock domain
        m.submodules.spi_data_cdc = FFSynchronizer(spi_data_live, self.dout, reset_less=False)
        m.submodules.spi_cs_cdc = FFSynchronizer(self.cs_l, self.cs_out, reset_less=False)

        return m
        

class PDMGenerator(Elaboratable):
    def __init__(self, bits=8):
        # Internal constants
        self._max_val = 2**(bits - 1) - 1
        self._min_val = -(2**(bits - 1))

        # Input Signals
        self.data_in = Signal(signed(bits))
        # Output Signals
        self.pdm_out = Signal(1)
    
    def elaborate(self, platform):
        m = Module()

        # Feedback Loop
        error = Signal(signed(len(self.data_in) + 1))
        error_out = Signal(signed(len(self.data_in)))
        data_out = Signal(signed(len(self.data_in)), reset=self._min_val)
        m.d.sync += error.eq(self.data_in + (error_out - data_out))

        # Saturating Error Add
        with m.If(error > Const(self._max_val)):
            m.d.comb += error_out.eq(Const(self._max_val))
        with m.Elif(error < Const(self._min_val)):
            m.d.comb += error_out.eq(Const(self._min_val))
        with m.Else():
            # As long as we are within min/max value, the upper two sign bits will be the same.
            # So we can just truncate the error and not lose anything
            m.d.comb += error_out.eq(error[0:len(error)-1])

        # PDM It
        with m.If(error_out >= Const(0)):
            m.d.comb += data_out.eq(Const(self._max_val))
            m.d.sync += self.pdm_out.eq(Const(1))
        with m.Else():
            m.d.comb += data_out.eq(Const(self._min_val))
            m.d.sync += self.pdm_out.eq(Const(0))

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

        # Serial data input shift register
        m.submodules.spi = self.spi_bus_in = SPIShiftReg(width=8)
        m.d.comb += [
            self.spi_bus_in.rst.eq(ResetSignal("sync")),
            self.spi_bus_in.cs_l.eq(self.uio_in[4]),
            self.spi_bus_in.sclk.eq(self.uio_in[5]),
            self.spi_bus_in.sdi.eq(self.uio_in[6]),
        ]

        # CS Rising Edge Detector
        m.submodules.cs_edge_detect = cs_edge_detect = EdgeDetect("pos")
        m.d.comb += [
            cs_edge_detect.inp.eq(self.spi_bus_in.cs_out),
        ]

        # Select how we get the input data (parallel, SPI)
        self.ui_in_sel = Signal(unsigned(8))
        ui_in_sel_mux = Signal(unsigned(8))
        with m.Switch(self.uio_in[7]):
            with m.Case(Const(0)): 
                m.d.comb += [
                    ui_in_sel_mux.eq(self.ui_in),
                    # self.ui_in_sel.eq(Const(60, 8)),  # Testbench: Set fixed PDM value
                ]
            with m.Case(Const(1)):
                m.d.comb += ui_in_sel_mux.eq(self.spi_bus_in.dout),
        # Latch Data on low to high edge on CS_L/Latch
        with m.If(cs_edge_detect.out):
            m.d.sync += self.ui_in_sel.eq(ui_in_sel_mux)

        ## PDM Implementation
        # Connect the signals
        m.submodules.pdm = pdm = PDMGenerator(bits=8)
        m.d.comb += [
            pdm.data_in.eq(self.ui_in_sel - Const(-128)), # Center the data
            self.uo_out[0].eq(pdm.pdm_out),  # Output PDM waveform
        ]

        ## PWM Implementation
        # PWM It
        # FIXME: Do we need to buffer the input based on full PWM loops?
        self.pwm_counter = Signal(unsigned(8))
        self.pwm_out = Signal(1)
        with m.If(self.pwm_counter <= self.ui_in_sel):
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
        m.d.comb += self.pfm_in.eq(Const(255) - self.ui_in_sel)
        with m.If(((self.pfm_counter >> 1) >= self.pfm_in)
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
        m.d.comb += self.pfm2_in.eq((Const(255) - self.ui_in_sel) << 1)
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