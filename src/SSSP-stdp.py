# GOAL: read an input file, parse vertices and edges; build the appropriate network of neurons; set correct parameters for neurons and synapses; perform SSSP 
# Requires 2 parameters to run this code: 1) input edge file and 2) the total number of nodes in the graph
# Example: python SSSP.py ../datasets/ultraSmallKroneckerWeighted.txt 4 
from brian2 import *
import numpy as np

taupre = 1000*ms
taupost = taupre
dApre = 1
dApost = -dApre * taupre / taupost * 1.05


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

eqs = '''
v : 1
ref : second
'''
inputFileName = sys.argv[1] # input graph file in .txt format 
numNodes = int(sys.argv[2]) # number of nodes in the network

source = 0 # source node of SSSP algorithm
initial_stimulus_value = 0.0001  # stimulus applied to source to start SSSP algorithm

# parameters of SSSP (some are dependent on input data)
# Neuron: 1) threshold voltage; 2) refractory time 
# Synapse: 1) programmable delay, weight

Vt = 0 # threshold voltage 
Vr = 0 # reset voltage. Is this correct?? 
synapseWeight = 1 

P = NeuronGroup(numNodes, eqs, threshold='v > Vt', reset='v = Vr', refractory='ref', method='exact') # neuron group with as many neurons as number of vertices in graph
S = Synapses(P, P, model='''w:1
                            dApre/dt = -Apre / taupre : 1 (event-driven)
                            dApost/dt = -Apost / taupost : 1 (event-driven)''', on_pre=''' v_post += w
                            Apre += dApre
                            w = w+Apost''',
                            on_post=''' Apost += dApost
                            w = w+Apre''')
P.v['i==source'] = initial_stimulus_value # acts like a stimulus on the source node of SSSP
print P.v

fin = open(inputFileName, "r")
sumLength=0
numEdges=0
# Iterate through each line in the input graph, get source, dest, weight
for line in fin:
    print(line)
    edgePair = [int(i) for i in line.split()]    
    source = edgePair[0]
    dest = edgePair[1] 
    length = edgePair[2]
    sumLength += length
    numEdges += 1
    print("Source: " + str(source) + "   Destination: " + str(dest) + "   Length: "  + str(length))   
    S.connect(i=source, j=dest)        
    S.delay[source, dest] = length*ms  
fin.close()   

#visualize_connectivity(S)

alpha = (sumLength + numEdges + 1)*ms # refractory time  
P.ref = alpha
S.w = synapseWeight # synapse weight
print P.ref
print S.w
print S.delay

s_mon = SpikeMonitor(P)
run(alpha) 
S.w['w<1'] = 0
S.w['w>=2'] = 0 #happens when two connected neurons fire at same time
shortestpathedges=[]
for i in range(numNodes):
    for j in range(numNodes):
        if S.w[i,j] > 1:
            shortestpathedges.append([i, j, int(S.w[i,j])])

shortestpathedges.sort(key=lambda x: x[0])

for i in shortestpathedges:
    print i

#plot(s_mon.t/ms, s_mon.i, ',k')
plot(s_mon.t/ms, s_mon.i, "o")
print s_mon.i
print s_mon.t

xlabel('Time (ms)')
ylabel('Neuron index')
show()


