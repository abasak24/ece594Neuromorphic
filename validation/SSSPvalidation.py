#!/usr/bin/env python
# coding: utf-8

# In[1]:


import networkx as nx
import os
import sys

# In[11]:


g = nx.Graph()
inputFileName = sys.argv[1]
numNodes = int(sys.argv[2])
f_routes = open(inputFileName, 'rb')
origin=0 #source for SSSP


for line in f_routes:
    route_list = line.rstrip().split(" ")
    orig = int(route_list[0])
    dest = int(route_list[1])
    weight = float(route_list[2])
    g.add_edge(orig, dest, distance=(weight))

c=[]

for destination in list(g.nodes)[1:]:
    #print nx.dijkstra_path(g, source=origin, target=destination, weight='weight') 
    #print nx.shortest_path_length(g, source=origin, target=destination, weight='weight', method='dijkstra')
    a,b= nx.single_source_dijkstra(g, origin, destination, weight='distance')
    print nx.single_source_dijkstra(g, origin, destination, weight='distance')
    c.append([a,b[-1]])

sorteds= sorted( c,key=lambda  x: ( x[0], x[1]))

'''
k=[ 0. ,  8.1, 13.2, 16.2, 21.2, 23.2, 23.3, 24.2, 28.2, 29.3, 32.3,
       33.3, 33.3, 35.3, 36.4, 40.3, 40.4, 40.4, 41.2, 41.4, 41.4, 42.3,
       42.3, 42.4, 44.5, 46.4, 48.3, 49.4, 52.3, 53.5, 54.4, 62.6]
node=[ 0,  8, 13, 19, 10, 15, 26, 17,  2, 28, 30,  3,  7,  6, 24, 14, 20,
       27,  1,  4, 18, 25, 29,  5, 22, 11, 16,  9, 21, 12, 23, 31]
print k
for i,path in enumerate(sorteds):
    print node[i],k[i],path[0]
'''

