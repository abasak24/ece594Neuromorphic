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
, output done
, input clk
, input reset
);
  // --------------------------------------------------------------------
  localparam VW = ($clog2(CFG.V_0) > 0) // width of membrane voltage
                ? $clog2(CFG.V_0)
                : 1;
  localparam AW = VW + $clog2(S); // width of output of adder tree

  // --------------------------------------------------------------------
  wire [S-1:0] V_d;
  wire spike_in = |V_d;

  generate
    for(genvar j = 0; j < S; j++)
     assign V_d[j] = dendrite[j].spike;
  endgenerate

  // --------------------------------------------------------------------
  wire refractory;
  wire spike_w = (spike_in & ~refractory) | force_spike ? 1 : 0;

  always_ff @(posedge clk)
    if(reset)
      spike  <= 0;
    else if(time_step)
      spike  <= spike_w;

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
  reg [1:0] time_step_r;
  wire time_step_fall = (time_step_r == 2'b01);

  always_ff @(posedge clk)
    if(reset)
      time_step_r <= 0;
    else
      time_step_r <= {time_step, time_step_r[1]};

  // --------------------------------------------------------------------
  reg time_step_fall_r;

  always_ff @(posedge clk)
    if(reset)
      time_step_fall_r <= 0;
    else if(time_step_fall)
      time_step_fall_r <= 1;

  // --------------------------------------------------------------------
  wire [S-1:0] dendrite_spiked;

  generate
    for(genvar j = 0; j < S; j++) begin : memory
      reg spiked;

      always_ff @(posedge clk)
        if(reset)
          spiked <= 0;
        else if(spike_w & ~spike_fired_r)
          spiked <= dendrite[j].spike;

      assign dendrite_spiked[j] = spiked;
  end
  endgenerate

  // --------------------------------------------------------------------
  assign axis_out.tvalid = time_step_fall_r;
  assign axis_out.tdata  = dendrite_spiked;
  assign axis_out.tlast  = 1;
  assign axis_out.tuser  = time_step_counter;
  assign done = spike_fired;

// --------------------------------------------------------------------
endmodule
