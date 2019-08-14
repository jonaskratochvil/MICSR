#!/bin/bash

for file in *.wav ; do
  soxi $file | grep "Duration" | python3 getduration.py >> dur.txt
done
awk '{ sum += $1 } END { print sum }' dur.txt > total_time.txt

cat total_time.txt | python3 prettyoutput.py

rm total_time.txt dur.txt