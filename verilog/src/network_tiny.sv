// --------------------------------------------------------------------
//
// --------------------------------------------------------------------
import snn_pkg::*;

module network_tiny
( input  select
, input [$clog2(T)-1:0] force_spike_block_select
, input [$clog2(N)-1:0] force_spike_neuron_select
, input force_spike_en
, input  clk
, input  reset
);
  // // --------------------------------------------------------------------
  // localparam N = 3; // neurons per block
  // localparam T = 2; // number of blocks

  // --------------------------------------------------------------------
  localparam neuron_config_t CONFIG = '{14, 6, 1, 1};
  localparam int S[T][N] = // '{ '{n[0], n[1], ... n[N]}, ... };
  '{ '{2, 3, 4}      // S[0]
  ,  '{5, 1, 2} };   // S[1]

  // --------------------------------------------------------------------
  defparam block[0].nb.neuron[0].syn.SPIKE = {{1, 0}, {1, 1}};
  defparam block[0].nb.neuron[1].syn.SPIKE = {{1, 0}, {1, 1}, {1, 2}};
  defparam block[0].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};
  defparam block[1].nb.neuron[0].syn.SPIKE = {{0, 0}, {0, 1}, {0, 2}, {1, 1}, {1, 2}};
  defparam block[1].nb.neuron[1].syn.SPIKE = {{0, 0}};
  defparam block[1].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 1}};

  // --------------------------------------------------------------------
  wire [N-1:0] spike_in[T-1:0];

  generate
    for(genvar j = 0; j < T; j++) begin : block
      wire force_spike = force_spike_en & (force_spike_block_select == j);
      wire [N-1:0] spike_out;
      assign spike_in[j] = spike_out;
      neuron_block #(T, N, CONFIG, S[j]) nb(.force_spike_en(force_spike), .*);
    end
  endgenerate

// --------------------------------------------------------------------
endmodule
