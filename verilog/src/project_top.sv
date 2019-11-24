// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

import snn_pkg::*;

module project_top
( input select
, input [$clog2(T)-1:0] force_spike_block_select
, input [$clog2(N)-1:0] force_spike_neuron_select
, input force_spike_en
, input clk
, input reset
);

  // --------------------------------------------------------------------
  network_tiny network_i(.*);


// --------------------------------------------------------------------
endmodule
