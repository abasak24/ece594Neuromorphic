// --------------------------------------------------------------------
localparam neuron_config_t CFG = '{1, 0, 0, 1, ALPHA};

// --------------------------------------------------------------------
localparam int S[T][N] = // '{ '{n[0], n[1], ... n[N]}, ... };
'{ '{3, 2, 2, 3}}; // S[0]

// --------------------------------------------------------------------
defparam block[0].nb.neuron[0].syn.SPIKE = {{0, 1}, {0, 2}, {0, 3}};
defparam block[0].nb.neuron[1].syn.SPIKE = {{0, 0}, {0, 3}};
defparam block[0].nb.neuron[2].syn.SPIKE = {{0, 0}, {0, 3}};
defparam block[0].nb.neuron[3].syn.SPIKE = {{0, 0}, {0, 1}, {0, 2}};

defparam block[0].nb.neuron[0].syn_if[0].WEIGHT = 63;
defparam block[0].nb.neuron[0].syn_if[1].WEIGHT = 12;
defparam block[0].nb.neuron[0].syn_if[2].WEIGHT = 13;
defparam block[0].nb.neuron[1].syn_if[0].WEIGHT = 63;
defparam block[0].nb.neuron[1].syn_if[1].WEIGHT = 30;
defparam block[0].nb.neuron[2].syn_if[0].WEIGHT = 12;
defparam block[0].nb.neuron[2].syn_if[1].WEIGHT = 1 ;
defparam block[0].nb.neuron[3].syn_if[0].WEIGHT = 13;
defparam block[0].nb.neuron[3].syn_if[1].WEIGHT = 30;
defparam block[0].nb.neuron[3].syn_if[2].WEIGHT = 1 ;

