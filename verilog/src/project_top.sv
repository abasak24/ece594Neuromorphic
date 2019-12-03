// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

import snn_pkg::*;

module project_top
( axis_if axis_out
, input select
, input [TA-1:0] force_spike_block_select
, input [$clog2(N)-1:0] force_spike_neuron_select
, input time_step
, input force_spike_en
, input clk
, input reset
);
  // --------------------------------------------------------------------
  wire aclk = clk;
  wire aresetn = ~reset;

  // --------------------------------------------------------------------
  network network_i(.*);

// --------------------------------------------------------------------
endmodule
