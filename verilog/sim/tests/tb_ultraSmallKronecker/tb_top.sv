// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module tb_top;
  timeunit 1ns;
  timeprecision 100ps;
  // import uvm_pkg::*;
  import snn_pkg::*;
  // `include "uvm_macros.svh"

  // --------------------------------------------------------------------
  localparam realtime PERIODS[1] = '{10ns};
  localparam CLOCK_COUNT = $size(PERIODS);

  // --------------------------------------------------------------------
  bit tb_clk[CLOCK_COUNT];
  wire tb_aresetn;
  bit tb_reset[CLOCK_COUNT];

  tb_base #(.N(CLOCK_COUNT), .PERIODS(PERIODS)) tb(.*);

  // --------------------------------------------------------------------
  wire reset = tb_reset[0];
  wire clk = tb_clk[0]; // 100mhz
  wire aclk = clk;
  wire aresetn = ~reset;

  // --------------------------------------------------------------------
  axis_if #(.N(NN)) axis_out(.*);
  logic tready = 0;
  assign axis_out.tready = tready;

  // --------------------------------------------------------------------
  wire select = 0;
  logic [$clog2(T)-1:0] force_spike_block_select = 0;
  logic [$clog2(N)-1:0] force_spike_neuron_select = 0;
  logic time_step = 0;
  logic force_spike_en = 0;

  project_top dut(.*);

  // --------------------------------------------------------------------
  task dump_results;
    automatic string s = "";

    fork
    begin
      $display("%s", {80{"="}});
      $display("[block]:| == neuron == n[0]| n[1]| ...| n[N]| %s", {34{"="}});

      for(int t = 0; t < T; t++) begin
        for(int n = 0; n < N; n++) begin
          wait(axis_out.tvalid & axis_out.tready);
          @(axis_out.cb_m);
          s = $sformatf("%s|%4.d", s, axis_out.tdata);
        end

        $display("[%4.d] :%s|", t, s);
        s = "";
      end
    end
    join_none
  endtask

  // --------------------------------------------------------------------
  initial
  begin
    repeat(16) @(posedge clk);

    dump_results();

    time_step <= 1;
    force_spike_en <= 1;
    force_spike_block_select  <= 0;
    force_spike_neuron_select <= 0;

    repeat(ALPHA) @(posedge clk);

    time_step <= 0;
    force_spike_en <= 0;

    repeat(8) @(posedge clk);

    tready <= 1;
    wait(axis_out.tlast);
    @(posedge clk);
    tready <= 0;

    repeat(8) @(posedge clk);

    $stop;
  end


// --------------------------------------------------------------------
endmodule
