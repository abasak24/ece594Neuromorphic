// --------------------------------------------------------------------
localparam neuron_config_t CFG = '{14, 6, 1, 1, 5};

// --------------------------------------------------------------------
localparam int S[T][N] = // '{ '{n[0], n[1], ... n[N]}, ... };
'{ '{2, 3, 4, 4, 2}      // S[0]
,  '{2, 3, 4, 4, 2}      // S[1]
,  '{5, 1, 2, 2, 5}      // S[2]
,  '{5, 1, 2, 2, 5} };   // S[3]

// --------------------------------------------------------------------
defparam block[0].nb.neuron[0].syn.SPIKE = {{1, 0}, {1, 1}};
defparam block[0].nb.neuron[1].syn.SPIKE = {{1, 0}, {1, 1}, {1, 2}};
defparam block[0].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};
defparam block[0].nb.neuron[3].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};
defparam block[0].nb.neuron[4].syn.SPIKE = {{1, 0}, {1, 1}};
// defparam block[0].nb.neuron[5].syn.SPIKE = {{1, 0}, {1, 1}, {1, 2}};
// defparam block[0].nb.neuron[6].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};
// defparam block[0].nb.neuron[7].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};

defparam block[1].nb.neuron[0].syn.SPIKE = {{1, 0}, {1, 1}};
defparam block[1].nb.neuron[1].syn.SPIKE = {{1, 0}, {1, 1}, {1, 2}};
defparam block[1].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};
defparam block[1].nb.neuron[3].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};
defparam block[1].nb.neuron[4].syn.SPIKE = {{1, 0}, {1, 1}};
// defparam block[1].nb.neuron[5].syn.SPIKE = {{1, 0}, {1, 1}, {1, 2}};
// defparam block[1].nb.neuron[6].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};
// defparam block[1].nb.neuron[7].syn.SPIKE = {{0, 0}, {0, 1}, {1, 0}, {1, 2}};

defparam block[2].nb.neuron[0].syn.SPIKE = {{0, 0}, {0, 1}, {0, 2}, {1, 1}, {1, 2}};
defparam block[2].nb.neuron[1].syn.SPIKE = {{0, 0}};
defparam block[2].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 1}};
defparam block[2].nb.neuron[3].syn.SPIKE = {{0, 0}, {0, 1}};
defparam block[2].nb.neuron[4].syn.SPIKE = {{0, 0}, {0, 1}, {0, 2}, {1, 1}, {1, 2}};
// defparam block[2].nb.neuron[5].syn.SPIKE = {{0, 0}};
// defparam block[2].nb.neuron[6].syn.SPIKE = {{0, 0}, {0, 1}};
// defparam block[2].nb.neuron[7].syn.SPIKE = {{0, 0}, {0, 1}};

defparam block[3].nb.neuron[0].syn.SPIKE = {{0, 0}, {0, 1}, {0, 2}, {1, 1}, {1, 2}};
defparam block[3].nb.neuron[1].syn.SPIKE = {{0, 0}};
defparam block[3].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 1}};
defparam block[3].nb.neuron[3].syn.SPIKE = {{0, 0}, {0, 1}};
defparam block[3].nb.neuron[4].syn.SPIKE = {{0, 0}, {0, 1}, {0, 2}, {1, 1}, {1, 2}};
// defparam block[3].nb.neuron[5].syn.SPIKE = {{0, 0}};
// defparam block[3].nb.neuron[6].syn.SPIKE = {{0, 0}, {0, 1}};
// defparam block[3].nb.neuron[7].syn.SPIKE = {{0, 0}, {0, 1}};

