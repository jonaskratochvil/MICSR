#!/bin/bash/ python3
import sys
for line in sys.stdin:
    minutes = float(line)/60
    hours = minutes/60
    print("The total number of hours is {} and minutes {}".format(
        hours, minutes))
