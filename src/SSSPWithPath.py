# GOAL: read an input file, parse vertices and edges; build the appropriate network of neurons; set correct parameters for neurons and synapses; perform SSSP
# This code provides: 1) length of shortest paths and 2) the nodes involved in the path itself 
# Requires 2 parameters to run this code: 1) input edge file and 2) the total number of nodes in the graph
# Example: python SSSPWithPath.py ../datasets/ultraSmallKroneckerWeighted.txt 4 
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

# find the path of a node from the source node in terms of the nodes involved in the path
def backTrackPath(node, nodeIDs, SpikeTimes):
    path = [node]

    refIndex = nodeIDs.index(node)  
    
    while(not(refIndex == 0)):
        test_index = refIndex - 1        
        while (test_index >= 0):  
            refTime = SpikeTimes[refIndex]
            nodej = nodeIDs[refIndex]          
            nodei_test = nodeIDs[test_index]              
            time_test = SpikeTimes[test_index]
            # time_test < refTime
            if((refTime - time_test)*ms == S.delay[nodei_test, nodej]):
                path.append(nodei_test)
                refIndex = test_index
                break
            test_index = test_index - 1 

    return path


eqs = '''
v : 1
ref : second
'''
inputFileName = sys.argv[1] # input graph file in .txt format 
numNodes = int(sys.argv[2]) # number of nodes in the network

sourceSSSP = 0 # source node of SSSP algorithm
initial_stimulus_value = 0.0001  # stimulus applied to source to start SSSP algorithm

# parameters of SSSP (some are dependent on input data)
# Neuron: 1) threshold voltage; 2) refractory time 
# Synapse: 1) programmable delay, weight

Vt = 0 # threshold voltage 
Vr = 0 # reset voltage. Is this correct?? 
synapseWeight = 1 

P = NeuronGroup(numNodes, eqs, threshold='v > Vt', reset='v = Vr', refractory='ref', method='exact') # neuron group with as many neurons as number of vertices in graph
S = Synapses(P, P, model='''w:1''', on_pre='v_post += w')
P.v['i==sourceSSSP'] = initial_stimulus_value # acts like a stimulus on the source node of SSSP
#print P.v

fin = open(inputFileName, "r")
sumLength=0
numEdges=0
# Iterate through each line in the input graph, get source, dest, weight
for line in fin:
    #print(line)
    edgePair = [int(i) for i in line.split()]    
    source = edgePair[0]
    dest = edgePair[1] 
    length = edgePair[2]
    sumLength += length
    numEdges += 1
    #print("Source: " + str(source) + "   Destination: " + str(dest) + "   Length: "  + str(length))   
    S.connect(i=source, j=dest)        
    S.delay[source, dest] = length*ms  
fin.close()   

#visualize_connectivity(S)

alpha = (sumLength + numEdges + 1)*ms # refractory time  
P.ref = alpha
S.w = synapseWeight # synapse weight
#print P.ref
#print S.w
#print S.delay

s_mon = SpikeMonitor(P)
run(alpha)     
#plot(s_mon.t/ms, s_mon.i, ',k')
plot(s_mon.t/ms, s_mon.i, "o")
# print s_mon.i
# print s_mon.t

nodeIDs = list(s_mon.i)
spikeTimesFloat = list(s_mon.t)/(1*ms)
spikeTimesInt = [int(k) for k in spikeTimesFloat]

# print nodeIDs
# print spikeTimesInt
#print nodeIDs, spikeTimesInt
for k in range(0, numNodes):
    if(k in nodeIDs): 
        path = backTrackPath(k, nodeIDs, spikeTimesInt)       
        print k, spikeTimesInt[nodeIDs.index(k)], path 
    else:
        print('node ' + str(k) + ' is not connected to source ID ' + str(sourceSSSP) + ' by any path')

xlabel('Time (ms)')
ylabel('Neuron index')
show()
