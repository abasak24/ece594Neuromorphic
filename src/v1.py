# GOAL: read an input file, parse vertices and edges and build the appropriate network of neurons 
# Requires 2 parameters to run this code: 1) input edge file and 2) the total number of nodes in the graph
# Example: python v1.py ../datasets/ultraSmallKronecker.txt 4
from brian2 import *

# function taken from brian tutorial 
def visualize_connectivity(S):    
    Ns = len(S.source)
    Nt = len(S.target)
    figure(figsize=(10, 4))
    subplot(121)
    plot(zeros(Ns), arange(Ns), 'ok', ms=10)
    plot(ones(Nt), arange(Nt), 'ok', ms=10)
    for i, j in zip(S.i, S.j):
        plot([0, 1], [i, j], '-k')
    xticks([0, 1], ['Source', 'Target'])
    ylabel('Neuron index')
    xlim(-0.1, 1.1)
    ylim(-1, max(Ns, Nt))
    subplot(122)
    plot(S.i, S.j, 'ok')
    xlim(-1, Ns)
    ylim(-1, Nt)
    xlabel('Source neuron index')
    ylabel('Target neuron index')
    show()

# eqs are placeholders for the moment
tau = 10*ms
eqs = '''
dv/dt = (1-v)/tau : 1
'''
inputFileName = sys.argv[1] # input graph file in .txt format 
numNodes = int(sys.argv[2]) # number of nodes in the network

P = NeuronGroup(numNodes, eqs, threshold='v > 1', reset='v = 0', method='exact') # neuron group with as many neurons as number of vertices in graph
S = Synapses(P, P, on_pre='v_post += 0.2') # random placeholder for on_pre function

fin = open(inputFileName, "r")
# Iterate through each line in the inupt graph, get source and dest
for line in fin:
    print(line)
    edgePair = [int(i) for i in line.split()]
    source = edgePair[0]
    dest = edgePair[1] 
    print("Source: " + str(source) + "   Destination: " + str(dest))   
    S.connect(i=source, j=dest)
fin.close()    

visualize_connectivity(S)