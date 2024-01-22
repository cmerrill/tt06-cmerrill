/* Generated by Amaranth Yosys 0.35 (PyPI ver 0.35.0.0.post81, git sha1 cc31c6ebc) */

(* top =  1  *)
(* generator = "Amaranth" *)
module tt_um_cmerrill_pdm(uo_out, uio_in, uio_out, uio_oe, ena, clk, rst_n, ui_in);
  reg \$auto$verilog_backend.cc:2189:dump_module$1  = 0;
  wire [8:0] \$11 ;
  wire [8:0] \$12 ;
  wire [8:0] \$14 ;
  wire [8:0] \$15 ;
  wire [8:0] \$17 ;
  wire \$19 ;
  wire \$2 ;
  wire \$21 ;
  wire \$23 ;
  wire [8:0] \$25 ;
  wire \$27 ;
  wire \$29 ;
  wire \$31 ;
  wire [9:0] \$33 ;
  wire [9:0] \$34 ;
  wire [9:0] \$36 ;
  wire [8:0] \$37 ;
  wire [9:0] \$39 ;
  wire [9:0] \$4 ;
  wire [8:0] \$41 ;
  wire \$43 ;
  wire \$45 ;
  wire [9:0] \$47 ;
  wire [9:0] \$48 ;
  wire [8:0] \$5 ;
  wire [9:0] \$7 ;
  wire \$9 ;
  input clk;
  wire clk;
  wire \clk$1 ;
  wire cs_edge_detect_inp;
  wire cs_edge_detect_out;
  wire cs_signal;
  input ena;
  wire ena;
  wire [7:0] pdm_data_in;
  wire pdm_pdm_out;
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
  wire spi_cs_l;
  wire [7:0] spi_dout;
  wire spi_rst;
  wire spi_sclk;
  wire spi_sdi;
  input [7:0] ui_in;
  wire [7:0] ui_in;
  reg [7:0] ui_in_sel = 8'h00;
  reg [7:0] \ui_in_sel$next ;
  reg [7:0] ui_in_sel_mux;
  input [7:0] uio_in;
  wire [7:0] uio_in;
  output [7:0] uio_oe;
  wire [7:0] uio_oe;
  output [7:0] uio_out;
  wire [7:0] uio_out;
  output [7:0] uo_out;
  wire [7:0] uo_out;
  assign \$9  = pwm_counter <= ui_in_sel;
  assign \$12  = pwm_counter + 1'h1;
  assign \$15  = 8'hff - ui_in_sel;
  assign \$19  = \$17  >= pfm_in;
  assign \$23  = \$19  & \$21 ;
  assign \$27  = \$25  >= pfm_in;
  assign \$2  = ~ rst_n;
  assign \$31  = \$27  & \$29 ;
  assign \$34  = pfm_counter + 1'h1;
  assign \$37  = 8'hff - ui_in_sel;
  assign \$43  = pfm2_counter >= \$41 ;
  assign \$45  = pfm2_counter > pfm2_in;
  assign \$48  = pfm2_counter + 1'h1;
  always @(posedge \clk$1 )
    ui_in_sel <= \ui_in_sel$next ;
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
  assign \$5  = + ui_in_sel;
  assign \$7  = $signed(\$5 ) - $signed(9'h180);
  \tt_um_cmerrill_pdm.cs_edge_detect  cs_edge_detect (
    .clk(\clk$1 ),
    .inp(cs_edge_detect_inp),
    .out(cs_edge_detect_out),
    .rst(rst)
  );
  \tt_um_cmerrill_pdm.pdm  pdm (
    .clk(\clk$1 ),
    .data_in(pdm_data_in),
    .pdm_out(pdm_pdm_out),
    .rst(rst)
  );
  \tt_um_cmerrill_pdm.spi  spi (
    .clk(\clk$1 ),
    .cs_l(spi_cs_l),
    .dout(spi_dout),
    .rst(rst),
    .\rst$1 (spi_rst),
    .sclk(spi_sclk),
    .sdi(spi_sdi)
  );
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (uio_in[7])
      1'h0:
          ui_in_sel_mux = ui_in;
      1'h1:
          ui_in_sel_mux = spi_dout;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    \ui_in_sel$next  = ui_in_sel;
    casez (cs_edge_detect_out)
      1'h1:
          \ui_in_sel$next  = ui_in_sel_mux;
    endcase
    casez (rst)
      1'h1:
          \ui_in_sel$next  = 8'h00;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$9 )
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
    \pwm_counter$next  = \$12 [7:0];
    casez (rst)
      1'h1:
          \pwm_counter$next  = 8'h00;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$23 )
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
    casez (\$31 )
      1'h1:
          \pfm_counter$next  = 9'h000;
      default:
          \pfm_counter$next  = \$34 [8:0];
    endcase
    casez (rst)
      1'h1:
          \pfm_counter$next  = 9'h000;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$1 ) begin end
    (* full_case = 32'd1 *)
    casez (\$43 )
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
    casez (\$45 )
      1'h1:
          \pfm2_counter$next  = 9'h000;
      default:
          \pfm2_counter$next  = \$48 [8:0];
    endcase
    casez (rst)
      1'h1:
          \pfm2_counter$next  = 9'h000;
    endcase
  end
  assign \$4  = \$7 ;
  assign \$11  = \$12 ;
  assign \$14  = \$15 ;
  assign \$33  = \$34 ;
  assign \$36  = \$39 ;
  assign \$47  = \$48 ;
  assign pfm2_in = \$39 [8:0];
  assign pfm_in = \$15 [7:0];
  assign pdm_data_in = \$7 [7:0];
  assign cs_edge_detect_inp = cs_signal;
  assign spi_sdi = uio_in[6];
  assign spi_sclk = uio_in[5];
  assign spi_cs_l = cs_signal;
  assign spi_rst = rst;
  assign cs_signal = uio_in[4];
  assign uo_out[3] = pfm2_out;
  assign uo_out[2] = pfm_out;
  assign uo_out[4] = pwm_out;
  assign uo_out[0] = pdm_pdm_out;
  assign { uo_out[7:5], uo_out[1] } = 4'h0;
  assign uio_out = 8'h00;
  assign uio_oe = 8'h00;
  assign rst = \$2 ;
  assign \clk$1  = clk;
  assign \$17  = { 1'h0, pfm_counter[8:1] };
  assign \$21  = pfm_counter[0];
  assign \$25  = { 1'h0, pfm_counter[8:1] };
  assign \$29  = pfm_counter[0];
  assign \$39  = { \$37 , 1'h0 };
  assign \$41  = { 1'h0, \$39 [8:1] };
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.cs_edge_detect (rst, inp, out, clk);
  reg \$auto$verilog_backend.cc:2189:dump_module$2  = 0;
  wire \$1 ;
  wire \$3 ;
  input clk;
  wire clk;
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
  always @(posedge clk)
    input_buf <= \input_buf$next ;
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$2 ) begin end
    \input_buf$next  = inp;
    casez (rst)
      1'h1:
          \input_buf$next  = 1'h0;
    endcase
  end
  assign out = \$3 ;
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.pdm (rst, data_in, pdm_out, clk);
  reg \$auto$verilog_backend.cc:2189:dump_module$3  = 0;
  wire [9:0] \$1 ;
  wire \$10 ;
  wire \$12 ;
  wire [8:0] \$2 ;
  wire [9:0] \$4 ;
  wire \$6 ;
  wire \$8 ;
  input clk;
  wire clk;
  input [7:0] data_in;
  wire [7:0] data_in;
  reg [7:0] data_out;
  reg [8:0] error = 9'h000;
  reg [8:0] \error$next ;
  reg [7:0] error_out;
  output pdm_out;
  reg pdm_out = 1'h0;
  reg \pdm_out$next ;
  input rst;
  wire rst;
  assign \$10  = $signed(error_out) >= $signed(8'h00);
  assign \$12  = $signed(error_out) >= $signed(8'h00);
  always @(posedge clk)
    error <= \error$next ;
  always @(posedge clk)
    pdm_out <= \pdm_out$next ;
  assign \$2  = $signed(error_out) - $signed(data_out);
  assign \$4  = $signed(data_in) + $signed(\$2 );
  assign \$6  = $signed(error) > $signed(9'h07f);
  assign \$8  = $signed(error) < $signed(8'h80);
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$3 ) begin end
    \error$next  = \$4 [8:0];
    casez (rst)
      1'h1:
          \error$next  = 9'h000;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$3 ) begin end
    (* full_case = 32'd1 *)
    casez ({ \$8 , \$6  })
      2'b?1:
          error_out = 8'h7f;
      2'b1?:
          error_out = 8'h80;
      default:
          error_out = error[7:0];
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$3 ) begin end
    (* full_case = 32'd1 *)
    casez (\$10 )
      1'h1:
          data_out = 8'h7f;
      default:
          data_out = 8'h80;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$3 ) begin end
    (* full_case = 32'd1 *)
    casez (\$12 )
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
  assign \$1  = \$4 ;
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.spi (rst, \rst$1 , cs_l, sclk, sdi, dout, clk);
  reg \$auto$verilog_backend.cc:2189:dump_module$4  = 0;
  wire \$2 ;
  wire \$4 ;
  input clk;
  wire clk;
  input cs_l;
  wire cs_l;
  output [7:0] dout;
  wire [7:0] dout;
  input rst;
  wire rst;
  input \rst$1 ;
  wire \rst$1 ;
  input sclk;
  wire sclk;
  input sdi;
  wire sdi;
  wire spi_clk;
  reg [7:0] spi_data_cdc_spi_data_live = 8'h00;
  reg [7:0] \spi_data_cdc_spi_data_live$next ;
  wire spi_rst;
  assign \$2  = ~ sclk;
  assign \$4  = ~ cs_l;
  always @(negedge sclk)
    spi_data_cdc_spi_data_live <= \spi_data_cdc_spi_data_live$next ;
  \tt_um_cmerrill_pdm.spi.spi_cs_cdc  spi_cs_cdc (
    .clk(clk),
    .cs_l(cs_l),
    .rst(rst)
  );
  \tt_um_cmerrill_pdm.spi.spi_data_cdc  spi_data_cdc (
    .clk(clk),
    .dout(dout),
    .rst(rst),
    .spi_data_live(spi_data_cdc_spi_data_live)
  );
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$4 ) begin end
    \spi_data_cdc_spi_data_live$next  = spi_data_cdc_spi_data_live;
    casez (\$4 )
      1'h1:
        begin
          \spi_data_cdc_spi_data_live$next [7] = spi_data_cdc_spi_data_live[6];
          \spi_data_cdc_spi_data_live$next [6] = spi_data_cdc_spi_data_live[5];
          \spi_data_cdc_spi_data_live$next [5] = spi_data_cdc_spi_data_live[4];
          \spi_data_cdc_spi_data_live$next [4] = spi_data_cdc_spi_data_live[3];
          \spi_data_cdc_spi_data_live$next [3] = spi_data_cdc_spi_data_live[2];
          \spi_data_cdc_spi_data_live$next [2] = spi_data_cdc_spi_data_live[1];
          \spi_data_cdc_spi_data_live$next [1] = spi_data_cdc_spi_data_live[0];
          \spi_data_cdc_spi_data_live$next [0] = sdi;
        end
    endcase
    casez (spi_rst)
      1'h1:
          \spi_data_cdc_spi_data_live$next  = 8'h00;
    endcase
  end
  assign spi_rst = \rst$1 ;
  assign spi_clk = \$2 ;
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.spi.spi_cs_cdc (rst, cs_l, clk);
  reg \$auto$verilog_backend.cc:2189:dump_module$5  = 0;
  input clk;
  wire clk;
  input cs_l;
  wire cs_l;
  wire cs_out;
  input rst;
  wire rst;
  reg stage0 = 1'h0;
  reg \stage0$next ;
  reg stage1 = 1'h0;
  reg \stage1$next ;
  always @(posedge clk)
    stage0 <= \stage0$next ;
  always @(posedge clk)
    stage1 <= \stage1$next ;
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$5 ) begin end
    \stage0$next  = cs_l;
    casez (rst)
      1'h1:
          \stage0$next  = 1'h0;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$5 ) begin end
    \stage1$next  = stage0;
    casez (rst)
      1'h1:
          \stage1$next  = 1'h0;
    endcase
  end
  assign cs_out = stage1;
endmodule

(* generator = "Amaranth" *)
module \tt_um_cmerrill_pdm.spi.spi_data_cdc (rst, dout, spi_data_live, clk);
  reg \$auto$verilog_backend.cc:2189:dump_module$6  = 0;
  input clk;
  wire clk;
  output [7:0] dout;
  wire [7:0] dout;
  input rst;
  wire rst;
  input [7:0] spi_data_live;
  wire [7:0] spi_data_live;
  reg [7:0] stage0 = 8'h00;
  reg [7:0] \stage0$next ;
  reg [7:0] stage1 = 8'h00;
  reg [7:0] \stage1$next ;
  always @(posedge clk)
    stage0 <= \stage0$next ;
  always @(posedge clk)
    stage1 <= \stage1$next ;
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$6 ) begin end
    \stage0$next  = spi_data_live;
    casez (rst)
      1'h1:
          \stage0$next  = 8'h00;
    endcase
  end
  always @* begin
    if (\$auto$verilog_backend.cc:2189:dump_module$6 ) begin end
    \stage1$next  = stage0;
    casez (rst)
      1'h1:
          \stage1$next  = 8'h00;
    endcase
  end
  assign dout = stage1;
endmodule
