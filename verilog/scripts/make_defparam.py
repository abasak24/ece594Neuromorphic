#
import re

filepath = 'smallKroneckerWeighted.txt'

alpha = 0
neuron = '0'
s = -1

with open(filepath) as fp:
  for cnt, line in enumerate(fp):
  
    chunks = line.split()
    alpha += int(chunks[2]) + 1
    
    if chunks[0] != neuron:
      neuron = chunks[0]
      s = 0
    else:
      s += 1
      
    print( 'defparam block[0].nb.neuron[' 
         + chunks[0] 
         + '].syn_if[' 
         + str(s) 
         + '].WEIGHT = ' 
         + chunks[2] 
         + ';')
    
    # print(chunks)
    

print("ALPHA =", alpha)




