// --------------------------------------------------------------------
//
// --------------------------------------------------------------------
import snn_pkg::*;

module neuron #(S, neuron_config_t CFG)
( axis_if axis_out
, synapse_if dendrite[S-1:0]
, output reg spike
, input time_step
, input force_spike
, input clk
, input reset
);
  // --------------------------------------------------------------------
  localparam VW = ($clog2(CFG.V_0) > 0) // width of membrane voltage
                ? $clog2(CFG.V_0)
                : 1;
  localparam AW = VW + $clog2(S); // width of output of adder tree

  // --------------------------------------------------------------------
  wire [VW-1:0] V_d[S-1:0];

  generate
    for(genvar j = 0; j < S; j++)
     assign V_d[j] = dendrite[j].spike ? dendrite[j].weight : 0;
  endgenerate

  // --------------------------------------------------------------------
  wire [AW-1:0] data_out;
  wire signed [AW:0] V_d_total_s = data_out;

  adder_tree #(S, VW) adder_i(V_d, data_out);

  // --------------------------------------------------------------------
  reg signed [VW:0] V_prev;
  wire signed [7:0] V_i_s = V_prev + (CFG.K_SYN * V_d_total_s) - CFG.V_LEAK;
  reg [VW-1:0] V_i;
  wire refractory;

  always_comb
    if((V_i_s >= CFG.V_0) | refractory)
      V_i = CFG.V_REST;
    else if(V_i_s < 0)
      V_i = 0;
    else
      V_i = V_i_s[VW-1:0];

  // --------------------------------------------------------------------
  wire spike_w = (V_i_s >= CFG.V_0) | force_spike ? 1 : 0;

  always_ff @(posedge clk) begin
    if(reset) begin
      V_prev <= CFG.V_REST;
      spike  <= 0;
    end
    else if(time_step) begin
      V_prev <= V_i;
      spike  <= spike_w;
    end
  end

  // --------------------------------------------------------------------
  reg [$clog2(CFG.RP)-1:0] refractory_counter;
  assign refractory = (refractory_counter != 0);

  always_ff @(posedge clk)
    if(reset)
      refractory_counter <= 0;
    else if(time_step & spike_w)
      refractory_counter <= CFG.RP;
    else if(time_step & refractory)
      refractory_counter <= refractory_counter - 1;

  // --------------------------------------------------------------------
  reg spike_fired_r;
  wire spike_fired = spike_w | spike_fired_r;

  always_ff @(posedge clk)
    if(reset)
      spike_fired_r <= 0;
    else if(spike_w)
      spike_fired_r <= 1;

  // --------------------------------------------------------------------
  reg [$clog2(TS + 1)-1:0] time_step_counter;

  always_ff @(posedge clk)
    if(reset)
      time_step_counter <= 0;
    else if(time_step & ~spike_fired)
      time_step_counter <= time_step_counter + 1;

  // --------------------------------------------------------------------
  assign axis_out.tvalid = spike_fired;
  assign axis_out.tdata  = time_step_counter;
  assign axis_out.tlast  = 1;

// --------------------------------------------------------------------
endmodule
