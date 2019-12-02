// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

package snn_pkg;

  // --------------------------------------------------------------------
  localparam N = 32; // neurons per block
  localparam T = 1; // number of blocks
  localparam TA = $clog2(T) > 0 ? $clog2(T) : 1;
  localparam ALPHA = (8*4) + 1;
  localparam TS = ALPHA; // number of time steps
  localparam NN = ($clog2(TS + 1) % 8 == 0) // axi4 data width of neuron data
                ? ($clog2(TS + 1) / 8)
                : ($clog2(TS + 1) / 8) + 1; 

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

