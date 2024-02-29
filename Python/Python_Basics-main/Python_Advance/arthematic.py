def add(a,b):
    print(a+b)

def sub(a,b):
    print(a-b)

def mul(a,b):
    print(a*b)

def dev(a,b):
    print(a/b)

def pov(a,b):
    print(a**b)

def factorial(n):
    if n==1 or n==0:
        return 1
    else:
        return n*factorial(n-1)
    
