import os
import sys

#from grids import *
from demosocket import *

def main() -> int:
    """Run one project"""
    print("Running gen-art demo...")
    print("\t dir : ", os. getcwd())

    #src = "/Users/avikpaul/Documents/Processing/avik_demo_1/res/square.png"
    #dest = "/Users/avikpaul/Documents/Processing/avik_demo_1/res/square-outline.png"
    #RemoveBg(src, dest)
    TestSocketClient()
    return 0

if __name__ == '__main__':
    sys.exit(main())