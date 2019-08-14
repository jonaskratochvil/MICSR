#!/bin/bash

name=$(basename "`pwd`")
text="final_ali.txt"

python3 ../splittext.py $text $name
 
for file in *.wav; do
    dir_name="${file%.*}"
    mkdir -p $dir_name
    mkdir -p $dir_name/audio_segments
    mv $file ${dir_name}.txt $dir_name
    python3 ../second_alignment.py $name $dir_name
done
#TODO: doplnit second_alignment.py spravne a to by melo byt cele