// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

package snn_pkg;

  // --------------------------------------------------------------------
  localparam N = 2; // neurons per block
  localparam T = 2; // number of blocks
  localparam ALPHA = 4 + 1;
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

