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
    route_list = map(int, line.rstrip().split(" "))
    orig = route_list[0]
    dest = route_list[1]
    #weight = float(route_list[2])
    g.add_edge(orig, dest) #, distance=(weight))


# In[14]:


for destination in list(g.nodes)[1:]:
    print nx.dijkstra_path(g, source=origin, target=destination)


# In[ ]:




