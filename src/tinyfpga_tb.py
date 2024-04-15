from amaranth import *
from amaranth.build import *
from amaranth_boards import tinyfpga_bx

import tt_um_cmerrill_pdm

# FPGA-based TB
class Top(Elaboratable):
    def __init__(self):
        pass
    
    def elaborate(self, platform):
        m = Module()
        m.submodules.tt06 = tt06 = tt_um_cmerrill_pdm.Top()
        
        # Clock Connection
        clk16 = platform.request("clk16").i
        m.d.comb += [
            tt06.clk.eq(clk16),
            tt06.rst_n.eq(Signal(1, reset=1))
        ]

        # IO Connections
        platform.add_resources([
            Resource("parallel_in", 0, Pins("10 11 12 13 14 15 16 17", dir="i", conn=("gpio", 0))),
            Resource("clk_div", 0, Pins("21 22 23 24", dir="i", conn=("gpio", 0))),
            Resource("inp_sel_mux", 0, Pins("20", dir="i", conn=("gpio", 0))),
            Resource("cs_l_latch", 0, Pins("19", dir="i", conn=("gpio", 0))),
            Resource("spi_sdi", 0, Pins("1", dir="i", conn=("gpio", 0))),
            Resource("spi_sck", 0, Pins("2", dir="i", conn=("gpio", 0))),
            Resource("out", 0, Pins("6 7 8 9", dir="o", conn=("gpio", 0))),
        ])
        
        # Tie it together
        out_pins = platform.request("out").o
        m.d.comb += [
            tt06.ui_in.eq(platform.request("parallel_in").i),
            # tt06.ui_in.eq(Signal(8, reset=2)), #Test
            tt06.uio_in[0:4].eq(platform.request("clk_div").i),
            # tt06.uio_in[7].eq(platform.request("input_sel_mux").i),
            tt06.uio_in[7].eq(Signal(1, reset=0)), # Test: Force Parallel
            tt06.uio_in[4].eq(platform.request("cs_l_latch").i),
            # tt06.uio_in[6].eq(platform.request("spi_sdi").i),
            # tt06.uio_in[5].eq(platform.request("spi_sck").i),
            out_pins[0].eq(tt06.uo_out[0]), # PDM
            out_pins[1].eq(tt06.uo_out[2]), # PFM1
            out_pins[2].eq(tt06.uo_out[3]), # PFM2
            out_pins[3].eq(tt06.uo_out[4]), # PWM
        ]

        # Test: LED
        m.d.comb += [
            platform.request("led").o.eq(tt06.uo_out[0]),
        ]

        # Boilerplate
        return m
    
if __name__ == "__main__":
    tinyfpga_bx.TinyFPGABXPlatform().build(Top(), do_program=True)
