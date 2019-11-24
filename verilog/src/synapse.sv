// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module synapse #(T, N, S, int SPIKE[S-1:0][2])
( input [N-1:0] spike_in [T-1:0]
, synapse_if dendrite [S-1:0]
, input clk
, input reset
);
  // --------------------------------------------------------------------
  generate
    for(genvar j = 0; j < S; j++)
      assign dendrite[j].spike = spike_in[ SPIKE[j][0] ][ SPIKE[j][1] ];
  endgenerate

// --------------------------------------------------------------------
endmodule
