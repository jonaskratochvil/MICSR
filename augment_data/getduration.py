#!/bin/bash/ python3
import sys
import random
import datetime

epsilon = 1

for line in sys.stdin:
    wav_dur = float(line.split("=")[0].split(":")[-1].strip())
    upperbound = 1200 - wav_dur - epsilon
    sample = random.uniform(0, upperbound)
    lower_interval = sample
    upper_interval = sample + wav_dur
    print(lower_interval)
    print(wav_dur)
    print(random.randint(0, 3))
