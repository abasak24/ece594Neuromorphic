localparam neuron_config_t CFG = '{1, 0, 0, 1, ALPHA};

localparam int S[T][N] = 
'{ '{3, 2, 2, 3}};

defparam block[0].nb.neuron[0].syn.SPIKE = {{0, 1}, {0, 2}, {0, 3}};
defparam block[0].nb.neuron[1].syn.SPIKE = {{0, 0}, {0, 3}};
defparam block[0].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 3}};
defparam block[0].nb.neuron[3].syn.SPIKE = {{0, 0}, {0, 1}, {0, 2}};
