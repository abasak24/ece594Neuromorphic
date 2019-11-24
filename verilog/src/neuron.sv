// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module neuron #(S, V_0=14, V_REST=6, V_LEAK=1, K_SYN=1)
( synapse_if dendrite[S-1:0]
, output reg spike
, input force_spike
, input clk
, input reset
);
  // --------------------------------------------------------------------
  localparam VW = $clog2(V_0); // width of membrane voltage
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
  wire signed [7:0] V_i_s = V_prev + (K_SYN * V_d_total_s) - V_LEAK;
  reg [VW-1:0] V_i;

  always_comb
    if(V_i_s >= V_0)
      V_i = V_REST;
    else if(V_i_s < 0)
      V_i = 0;
    else
      V_i = V_i_s[VW-1:0];

  // --------------------------------------------------------------------
  wire spike_w = (V_i_s >= V_0) | force_spike ? 1 : 0;

  always_ff @(posedge clk) begin
    if(reset) begin
      V_prev <= V_REST;
      spike  <= 0;
    end
    else begin
      V_prev <= V_i;
      spike  <= spike_w;
    end
  end

// --------------------------------------------------------------------
endmodule
