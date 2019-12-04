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
  axis_if #(.N(NN), .U(NU)) axis_out(.*);
  logic tready = 0;
  assign axis_out.tready = tready;

  // --------------------------------------------------------------------
  wire select = 0;
  logic [TA-1:0] force_spike_block_select = 0;
  logic [$clog2(N)-1:0] force_spike_neuron_select = 0;
  logic time_step = 0;
  logic force_spike_en = 0;
  wire done;

  project_top dut(.*);

  // --------------------------------------------------------------------
  task set_timeout;
    fork
    begin
      repeat(2*ALPHA) @(posedge clk);
      $display("!!!! Test Timed Out!!!");
      $stop;
    end
    join_none
  endtask

  // --------------------------------------------------------------------
  task dump_results;
    automatic string s0 = "";
    automatic string s1 = "";

    fork
    begin
      $display("%s", {80{"-"}});
      $display("[block]:| == neuron == n[0]| n[1]| ...| n[N]| %s", {34{"="}});

      for(int t = 0; t < T; t++) begin
        for(int n = 0; n < N; n++) begin
          wait(axis_out.tvalid & axis_out.tready);
          @(axis_out.cb_m);
          s0 = $sformatf("%s|%4.d", s0, axis_out.tuser);
          s1 = $sformatf("%s|%8.h", s1, axis_out.tdata);
        end

        $display("[%4.d] :%s|", t, s0);
        $display("[%4.d] :%s|", t, s1);
        s0 = "";
        s1 = "";
      end
        $display("#### dump_results Done ####");
    end
    join_none
  endtask

  // --------------------------------------------------------------------
  task do_test(int block_select, int neuron_select);
    $display("%s", {80{"="}});
    $display("### do_test | block = %d | neuron = %d |", block_select, neuron_select);

    @(posedge clk);
    tb.assert_reset(80ns);
    wait(~reset);
    repeat(8) @(posedge clk);

    dump_results();

    time_step <= 1;
    force_spike_block_select  <= block_select;
    force_spike_neuron_select <= neuron_select;

    force_spike_en <= 1;
    @(posedge clk);
    force_spike_en <= 0;

    repeat(ALPHA-1) @(posedge clk);

    time_step <= 0;

    repeat(8) @(posedge clk);

    // set_timeout();

    tready <= 1;
    wait(axis_out.tlast);
    @(posedge clk);
    tready <= 0;

    repeat(8) @(posedge clk);
  endtask

  // --------------------------------------------------------------------
  initial
  begin
    for(int t = 0; t < T; t++)
      for(int n = 0; n < N; n++)
        do_test(t, n);

    $display("#### Test Done!!!");
    $stop;
  end


// --------------------------------------------------------------------
endmodule
