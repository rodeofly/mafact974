from random import *
from scipy import *


def genere(x0,n):
  epsilon=[2*randint(0,1)-1 for k in range(1,n+1)] 
  print("epsilon= ",epsilon)
  tau=list(random.permutation([k for k in range(1,n+1)]))   
  print("tau= ",tau)
  y=[x0]
  for k in range(0,n):
      y.append(y[k]+epsilon[k]*tau[k])
  print("y = ",y)

  sigma=[0]
  sigma.extend(list(random.permutation([k for k in range(1,n)]))) 
  sigma.append(n)
  print("sigma = ",sigma)

  x=[x0]
  for k in range(1,n+1):
      x.append(y[sigma[k]])
  print("x = ",x)

genere(1,6)

