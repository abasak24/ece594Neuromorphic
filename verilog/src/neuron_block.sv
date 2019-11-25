// --------------------------------------------------------------------
//
// --------------------------------------------------------------------
import snn_pkg::*;

module neuron_block #(T, N, neuron_config_t CONFIG, int S[N])
( input  [N-1:0] spike_in[T-1:0]
, output reg [N-1:0] spike_out
, input [$clog2(N)-1:0] force_spike_neuron_select
, input force_spike_en
, input clk
, input reset
);
  // --------------------------------------------------------------------
  generate
    for(genvar j = 0; j < N; j++) begin : neuron
      synapse_if syn_if[S[j]](.*);
      synapse #(T, N, S[j]) syn(.dendrite(syn_if), .*);

      wire spike;
      wire force_spike = force_spike_en & (force_spike_neuron_select == j);
      
      neuron #(S[j]) n(.dendrite(syn_if), .*);

      assign spike_out[j] = spike;
      // always_ff @(posedge clk)
        // spike_out[j] <= spike;
    end
  endgenerate

// --------------------------------------------------------------------
endmodule