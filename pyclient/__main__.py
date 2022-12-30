import os
import sys

#from grids import *
from demosocket import *

def main() -> int:
    """Run one project"""
    print("Running gen-art demo...")
    print("\t dir : ", os. getcwd())

    TestSocketClient()
    return 0

if __name__ == '__main__':
    sys.exit(main())