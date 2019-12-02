## Code descriptions:
* v1.py -> python code with Brian2 which reads an input edge file and creates a neuron network corresponding to the graph topology. Tested on ultraSmallKronecker.txt.
* SSSP.py -> python code with Brian2 which performs Single Source Shortest Paths algorithm. Tested on ultraSmallKroneckerWeighted.txt. Only outputs lengths of the shortest path, not the path itself. 
* SSSP2.py -> THIS CODE DOES NOT WORK. I tried to track the presynaptic firing neuron while the simulation runs in Brian. However, I was not successful.
* SSSPWithPath.py -> THIS IS WORKING CODE. This code tracks the path after simulation is over by post-processing the spike times. Function "backTrackPath" does that.
* SSSP-stdp.py -> STDP adjusts synapse weights. Edges involved in Shortest path algorithm are stored in "shortestpathedges" list. Printing paths function needs to be added.
