/* Generated by Amaranth Yosys 0.35 (PyPI ver 0.35.0.0.post81, git sha1 cc31c6ebc) */

(* top =  1  *)
(* generator = "Amaranth" *)
module tt_um_cmerrill_pdm(uo_out, uio_in, uio_out, uio_oe, ena, clk, rst_n, ui_in);
  reg \$auto$verilog_backend.cc:2189:dump_module$1  = 0;
  wire [9:0] \$11 ;
  wire [8:0] \$12 ;
  wire [9:0] \$14 ;
  wire \$16 ;
  wire \$18 ;
  wire \$2 ;
  wire \$20 ;
  wire \$22 ;
  wire \$24 ;
  wire [8:0] \$26 ;
  wire [8:0] \$27 ;
  wire [8:0] \$29 ;
  wire [8:0] \$30 ;
  wire [8:0] \$32 ;
  wire \$34 ;
  wire \$36 ;
  wire \$38 ;
  wire \$4 ;
  wire [8:0] \$40 ;
  wire \$42 ;
  wire \$44 ;
  wire \$46 ;
  wire [9:0] \$48 ;
  wire [9:0] \$49 ;
  wire [9:0] \$51 ;
  wire [8:0] \$52 ;
  wire [9:0] \$54 ;
  wire [8:0] \$56 ;
  wire \$58 ;
  wire [9:0] \$6 ;
  wire \$60 ;
  wire [9:0] \$62 ;
  wire [9:0] \$63 ;
  wire [8:0] \$7 ;
  wire [9:0] \$9 ;
  input clk;
  wire clk;
  wire \clk$1 ;
  wire cs_edge_detect_clk;
  wire cs_edge_detect_inp;
  wire cs_edge_detect_out;
  wire cs_edge_detect_rst;
  wire [7:0] data_in;
  reg [7:0] data_out;
  input ena;
  wire ena;
  reg [8:0] error = 9'h000;
  reg [8:0] \error$next ;
  reg [7:0] error_out;
  reg pdm_out = 1'h0;
  reg \pdm_out$next ;
  reg [8:0] pfm2_counter = 9'h000;
  reg [8:0] \pfm2_counter$next ;
  wire [8:0] pfm2_in;
  reg pfm2_out = 1'h0;
  reg \pfm2_out$next ;
  reg [8:0] pfm_counter = 9'h000;
  reg [8:0] \pfm_counter$next ;
  wire [7:0] pfm_in;
  reg pfm_out = 1'h0;
  reg \pfm_out$next ;
  reg [7:0] pwm_counter = 8'h00;
  reg [7:0] \pwm_counter$next ;
  reg pwm_out = 1'h0;
  reg \pwm_out$next ;
  wire rst;
  input rst_n;
  wire rst_n;
  wire [7:0] spi_cdc_spi_data_live;
  wire spi_cs_cdc_cs_out;
  wire spi_cs_l;
  reg [7:0] spi_data_out = 8'h00;
  reg [7:0] \spi_data_out$next ;
  wire [7:0] spi_dout;
  wire spi_reset;
  wire spi_sclk;
  wire spi_sdi;
  input [7:0] ui_in;
  wire [7:0] ui_in;
  reg [7:0] ui_in_buf;
  input [7:0] uio_in;
  wire [7:0] uio_in;
  output [7:0] uio_oe;
  wire [7:0] uio_oe;
  output [7:0] uio_out;
  wire [7:0] uio_out;
  output [7:0] uo_out;
  wire [7:0] uo_out;
  assign \$9  = $signed(\$7 ) - $signed(9'h180);
  assign \$12  = $signed(error_out) - $signed(data_out);
  assign \$14  = $signed(data_in) + $signed(\$12 );
  assign \$16  = $signed(error) > $signed(9'h07f);
  assign \$18  = $signed(error) < $signed(8'h80);
  assign \$20  = $signed(error_out) >= $signed(8'h00);
  assign \$22  = $signed(error_out) >= $signed(8'h00);
  assign \$24  = pwm_counter <= ui_in_buf;
  assign \$27  = pwm_counter + 1'h1;
  assign \$2  = ~ rst_n;
  assign \$30  = 8'hff - ui_in_buf;
  assign \$34  = \$32  == pfm_in;
  assign \$38  = \$34  & \$36 ;
  assign \$42  = \$40  == pfm_in;
  assign \$46  = \$42  & \$44 ;
  assign \$4  = ~ rst_n;
  assign \$49  = pfm_counter + 1'h1;
  assign \$52  = 8'hff - ui_in_buf;
  assign \$58  = pfm2_counter >= \$56 ;
  assign \$60  = pfm2_counter > pfm2_in;
  assign \$63  = pfm2_counter + 1'h1;
  always @(posedge \clk$1 )
    spi_data_out <= \spi_data_out$next ;
  always @(posedge \clk$1 )
    error <= \error$next ;
  always @(posedge \clk$1 )
    pdm_out <= \pdm_out$next ;
  always @(posedge \clk$1 )
    pwm_out <= \pwm_out$next ;
  always @(posedge \clk$1 )
    pwm_counter <= \pwm_counter$next ;
  always @(posedge \clk$1 )
    pfm_out <= \pfm_out$next ;
  always @(posedge \clk$1 )
    pfm_counter <= \pfm_counter$next ;
  always @(posedge \clk$1 )
    pfm2_out <= \pfm2_out$next ;
  always @(posedge \clk$1 )
    pfm2_counter <= \pfm2_counter$next ;
  assign \$7  = + ui_in_buf;
  \tt_um_cmerrill_pdm.cs_edge_detect  cs_edge_detect (
    .clk(cs_edge_detect_clk),
    .inp(cs_edge_detect_inp),
    .out(cs_edge_detect_out),
    .rst(cs_edge_detect_rst)
  );
  \tt_um_cmerrill_pdm.spi  spi (
    .cs_l(spi_cs_l),
    .dout(spi_dout),
    .reset(spi_reset),
    .sclk(spi_sclk),
    .sdi(spi_sdi)
  );
  \tt_um_cmerrill_pdm.spi_cdc  spi_cdc (
    .clk(\clk$1 ),
    .dout(spi_dout),
    .rst(rst),
    .spi_data_live(spi_cdc_spi_data_live)
  );
  \tt_um_cmerrill_pdm.spi_cs_cdc  spi_cs_cdc (
    .clk(\clk$1 ),
    .cs_l(spi_cs_l),
    .cs_out(spi_cs_cdc_cs_out),
    .rst(rst)
  );
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    \spi_data_out$next  = spi_data_out;
    casez (cs_edge_detect_out)
      1'h1:
          \spi_data_out$next  = spi_cdc_spi_data_live;
    endcase
    casez (rst)
      1'h1:
          \spi_data_out$next  = 8'h00;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (uio_in[7])
      1'h0:
          ui_in_buf = ui_in;
      1'h1:
          ui_in_buf = spi_data_out;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    \error$next  = \$14 [8:0];
    casez (rst)
      1'h1:
          \error$next  = 9'h000;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez ({ \$18 , \$16  })
      2'b?1:
          error_out = 8'h7f;
      2'b1?:
          error_out = 8'h80;
      default:
          error_out = error[7:0];
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$20 )
      1'h1:
          data_out = 8'h7f;
      default:
          data_out = 8'h80;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$22 )
      1'h1:
          \pdm_out$next  = 1'h1;
      default:
          \pdm_out$next  = 1'h0;
    endcase
    casez (rst)
      1'h1:
          \pdm_out$next  = 1'h0;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$24 )
      1'h1:
          \pwm_out$next  = 1'h1;
      default:
          \pwm_out$next  = 1'h0;
    endcase
    casez (rst)
      1'h1:
          \pwm_out$next  = 1'h0;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    \pwm_counter$next  = \$27 [7:0];
    casez (rst)
      1'h1:
          \pwm_counter$next  = 8'h00;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$38 )
      1'h1:
          \pfm_out$next  = 1'h1;
      default:
          \pfm_out$next  = 1'h0;
    endcase
    casez (rst)
      1'h1:
          \pfm_out$next  = 1'h0;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$46 )
      1'h1:
          \pfm_counter$next  = 9'h000;
      default:
          \pfm_counter$next  = \$49 [8:0];
    endcase
    casez (rst)
      1'h1:
          \pfm_counter$next  = 9'h000;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$58 )
      1'h1:
          \pfm2_out$next  = 1'h1;
      default:
          \pfm2_out$next  = 1'h0;
    endcase
    casez (rst)
      1'h1:
          \pfm2_out$next  = 1'h0;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$60 )
      1'h1:
          \pfm2_counter$next  = 9'h000;
      default:
          \pfm2_counter$next  = \$63 [8:0];
    endcase
    casez (rst)
      1'h1:
          \pfm2_counter$next  = 9'h000;
    endcase
  end
  assign \$6  = \$9 ;
  assign \$11  = \$14 ;
  assign \$26  = \$27 ;
  assign \$29  = \$30 ;
  assign \$48  = \$49 ;
  assign \$51  = \$54 ;
  assign \$62  = \$63 ;
  assign pfm2_in = \$54 [8:0];
  assign pfm_in = \$30 [7:0];
  assign data_in = \$9 [7:0];
  assign cs_edge_detect_inp = spi_cs_cdc_cs_out;
  assign cs_edge_detect_rst = rst;
  assign cs_edge_detect_clk = \clk$1 ;
  assign spi_sdi = uio_in[6];
  assign spi_sclk = uio_in[5];
  assign spi_cs_l = uio_in[4];
  assign spi_reset = \$4 ;
  assign uo_out[3] = pfm2_out;
  assign uo_out[2] = pfm_out;
  assign uo_out[4] = pwm_out;
  assign uo_out[0] = pdm_out;
  assign { uo_out[7:5], uo_out[1] } = 4'h0;
  assign uio_out = 8'h00;
  assign uio_oe = 8'h00;
  assign rst = \$2 ;
  assign \clk$1  = clk;
  assign \$32  = { 1'h0, pfm_counter[8:1] };
  assign \$36  = pfm_counter[0];
  assign \$40  = { 1'h0, pfm_counter[8:1] };
  assign \$44  = pfm_counter[0];
  assign \$54  = { \$52 , 1'h0 };
  assign \$56  = { 1'h0, \$54 [8:1] };
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.cs_edge_detect (rst, inp, out, clk);
  reg \$auto$verilog_backend.cc:2189:dump_module$2  = 0;
  wire \$1 ;
  wire \$3 ;
  input clk;
  wire clk;
  wire clock_domain_clk;
  wire clock_domain_rst;
  input inp;
  wire inp;
  reg input_buf = 1'h0;
  reg \input_buf$next ;
  output out;
  wire out;
  input rst;
  wire rst;
  assign \$1  = ~ input_buf;
  assign \$3  = \$1  & inp;
  always @(posedge clock_domain_clk)
    input_buf <= \input_buf$next ;
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$2 ) begin end
    \input_buf$next  = inp;
    casez (clock_domain_rst)
      1'h1:
          \input_buf$next  = 1'h0;
    endcase
  end
  assign out = \$3 ;
  assign clock_domain_rst = rst;
  assign clock_domain_clk = clk;
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.spi (cs_l, sclk, sdi, dout, reset);
  reg \$auto$verilog_backend.cc:2189:dump_module$3  = 0;
  wire \$1 ;
  wire \$3 ;
  input cs_l;
  wire cs_l;
  output [7:0] dout;
  reg [7:0] dout = 8'h00;
  reg [7:0] \dout$next ;
  input reset;
  wire reset;
  input sclk;
  wire sclk;
  input sdi;
  wire sdi;
  wire spi_clk;
  wire spi_rst;
  assign \$1  = ~ sclk;
  assign \$3  = ~ cs_l;
  always @(negedge sclk)
    dout <= \dout$next ;
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$3 ) begin end
    \dout$next  = dout;
    casez (\$3 )
      1'h1:
        begin
          \dout$next [1] = dout[0];
          \dout$next [2] = dout[1];
          \dout$next [3] = dout[2];
          \dout$next [4] = dout[3];
          \dout$next [5] = dout[4];
          \dout$next [6] = dout[5];
          \dout$next [7] = dout[6];
          \dout$next [0] = sdi;
        end
    endcase
    casez (spi_rst)
      1'h1:
          \dout$next  = 8'h00;
    endcase
  end
  assign spi_rst = reset;
  assign spi_clk = \$1 ;
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.spi_cdc (rst, spi_data_live, dout, clk);
  input clk;
  wire clk;
  input [7:0] dout;
  wire [7:0] dout;
  input rst;
  wire rst;
  output [7:0] spi_data_live;
  wire [7:0] spi_data_live;
  reg [7:0] stage0 = 8'h00;
  wire [7:0] \stage0$next ;
  reg [7:0] stage1 = 8'h00;
  wire [7:0] \stage1$next ;
  always @(posedge clk)
    stage0 <= \stage0$next ;
  always @(posedge clk)
    stage1 <= \stage1$next ;
  assign spi_data_live = stage1;
  assign \stage1$next  = stage0;
  assign \stage0$next  = dout;
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.spi_cs_cdc (rst, cs_l, cs_out, clk);
  input clk;
  wire clk;
  input cs_l;
  wire cs_l;
  output cs_out;
  wire cs_out;
  input rst;
  wire rst;
  reg stage0 = 1'h0;
  wire \stage0$next ;
  reg stage1 = 1'h0;
  wire \stage1$next ;
  always @(posedge clk)
    stage0 <= \stage0$next ;
  always @(posedge clk)
    stage1 <= \stage1$next ;
  assign cs_out = stage1;
  assign \stage1$next  = stage0;
  assign \stage0$next  = cs_l;
endmodule
