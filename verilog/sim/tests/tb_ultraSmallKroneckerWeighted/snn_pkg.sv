// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

package snn_pkg;

  // --------------------------------------------------------------------
  localparam N = 4; // neurons per block
  localparam T = 1; // number of blocks
  localparam TA = $clog2(T) > 0 ? $clog2(T) : 1;
  localparam ALPHA = 239;
  localparam TS = ALPHA; // number of time steps
  localparam NN = ((N*T) % 8 == 0) // axi4 tdata width of neuron data
                ? ((N*T) / 8)
                : ((N*T) / 8) + 1; 
  localparam NU = $clog2(TS + 1); // axi4 tuser width of neuron data

  // --------------------------------------------------------------------
  typedef struct {
    int V_0;
    int V_REST;
    int V_LEAK;
    int K_SYN;
    int RP; // refractory period
  } neuron_config_t;

// --------------------------------------------------------------------
endpackage

