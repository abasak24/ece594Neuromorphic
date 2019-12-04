// --------------------------------------------------------------------
//
// --------------------------------------------------------------------
import snn_pkg::*;

module neuron_block #(T, N, neuron_config_t CFG, int S[N])
( axis_if axis_out
, input  [N-1:0] spike_in[T-1:0]
, output reg [N-1:0] spike_out
, input [$clog2(N)-1:0] force_spike_neuron_select
, input time_step
, input force_spike_en
, output reg done
, input clk
, input reset
);
  // --------------------------------------------------------------------
  wire aclk = clk;
  wire aresetn = ~reset;

  // --------------------------------------------------------------------
  wire [N-1:0] done_w;

  always_ff @(posedge clk)
    if(reset)
      done <= 0;
    else
      done <= &done_w;

  // --------------------------------------------------------------------
  axis_if #(.N(NN), .U(NU)) axis_in[N-1:0](.*);

  generate
    for(genvar j = 0; j < N; j++) begin : neuron
      synapse_if syn_if[S[j]](.*);
      synapse #(T, N, S[j]) syn(.dendrite(syn_if), .*);

      wire spike;
      wire force_spike = force_spike_en & (force_spike_neuron_select == j);

      neuron #(S[j], CFG)
        n(.axis_out(axis_in[j]), .dendrite(syn_if), .done(done_w[j]), .*);

      assign spike_out[j] = spike;
    end
  endgenerate

  // --------------------------------------------------------------------
  recursive_axis_catenate #(.N(NN), .U(NU), .MN(N)) catenate_i(.*);

// --------------------------------------------------------------------
endmodule
