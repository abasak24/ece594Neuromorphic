// --------------------------------------------------------------------
localparam neuron_config_t CFG = '{1, 0, 0, 1, 11};

// --------------------------------------------------------------------
localparam int S[T][N] = // '{ '{n[0], n[1], ... n[N]}, ... };
'{ '{3, 2}      // S[0]
,  '{2, 3} };   // S[1]

// --------------------------------------------------------------------
defparam block[0].nb.neuron[0].syn.SPIKE = {{0, 1}, {1, 0}, {1, 1}};
defparam block[0].nb.neuron[1].syn.SPIKE = {{0, 0}, {1, 1}};

defparam block[1].nb.neuron[0].syn.SPIKE = {{0, 0}, {1, 1}};
defparam block[1].nb.neuron[1].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}};