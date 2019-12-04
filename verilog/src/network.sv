// --------------------------------------------------------------------
//
// --------------------------------------------------------------------
import snn_pkg::*;

module network
( axis_if axis_out
, input  select
// , input [$clog2(T)-1:0] force_spike_block_select
, input [TA-1:0] force_spike_block_select
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
  `include "snn_network.svh"

  // --------------------------------------------------------------------
  wire [T-1:0] done_w;

  always_ff @(posedge clk)
    if(reset)
      done <= 0;
    else
      done <= &done_w;

  // --------------------------------------------------------------------
  axis_if #(.N(NN), .U(NU)) axis_in[T-1:0](.*);
  wire [N-1:0] spike_in[T-1:0];

  generate
    for(genvar j = 0; j < T; j++) begin : block
      wire force_spike = force_spike_en & (force_spike_block_select == j);
      wire [N-1:0] spike_out;
      assign spike_in[j] = spike_out;
      neuron_block #(T, N, CFG, S[j])
        nb(.axis_out(axis_in[j]), .force_spike_en(force_spike), .done(done_w[j]), .*);
    end
  endgenerate

  // --------------------------------------------------------------------
  generate
    if(T > 1) begin : catenate
      recursive_axis_catenate #(.N(NN), .U(NU), .MN(T)) catenate_i(.*);
    end
    else begin : axis_alias
      axis_alias axis_alias_i(axis_in[0], axis_out);
    end
  endgenerate

// --------------------------------------------------------------------
endmodule
