import sys
import os

def add(a, b):
    return int(a) + int(b)

print(add(sys.argv[1], sys.argv[2]))
print(f'Welcome to {os.environ.get("FOO")}')
