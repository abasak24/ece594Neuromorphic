// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module tb_top;
  timeunit 1ns;
  timeprecision 100ps;
  import uvm_pkg::*;
  import snn_pkg::*;
  `include "uvm_macros.svh"

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

  // --------------------------------------------------------------------
  wire select = 0;
  logic [$clog2(T)-1:0] force_spike_block_select = 0;
  logic [$clog2(N)-1:0] force_spike_neuron_select = 0;
  logic force_spike_en = 0;
  
  project_top dut(.*);
  
  // --------------------------------------------------------------------
  // tb_dut_config #(N, U) cfg_h = new(axis_in, axis_stub);

  initial
  begin
    // cfg_h.init( .pixels_per_line(AW)
              // , .lines_per_frame(AH)
              // , .bits_per_pixel(B * 8)
              // );
    // uvm_config_db #(tb_dut_config #(N, U))::set(null, "*", "tb_dut_config", cfg_h);
    // run_test("t_debug");

    repeat(16) @(posedge clk);
    
    force_spike_en <= 1;
    force_spike_block_select <= 0;
    force_spike_neuron_select <= 1;
    
    repeat(16) @(posedge clk);
    
    force_spike_en <= 0;
    
    repeat(16) @(posedge clk);
    
    $stop;
  end


// --------------------------------------------------------------------
endmodule
