// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

package snn_pkg;

  // --------------------------------------------------------------------
  localparam N = 5; // neurons per block
  localparam T = 4; // number of blocks
  localparam TS = N * T; // number of time steps
  localparam NN = ($clog2(TS + 1) % 8 == 0) // axi4 data width of neuron data
                ? ($clog2(TS + 1) / 8)
                : ($clog2(TS + 1) / 8) + 1; 

  // --------------------------------------------------------------------
  typedef struct {
    int V_0=14;
    int V_REST=6;
    int V_LEAK=1;
    int K_SYN=1;
    int RP=1; // refractory period
  } neuron_config_t;

// --------------------------------------------------------------------
endpackage

