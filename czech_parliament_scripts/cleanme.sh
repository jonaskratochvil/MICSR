#!/bin/bash

# Only mandatory input is text file name
file_name=$1
fifth_name=$2
sixth_name=$3

first_name=$(python3 get_names2.py --in_text $file_name --in_spk 1)
second_name=$(python3 get_names2.py --in_text $file_name --in_spk 2)

if [ $# -eq 2 ]; then
  third_name=$(python3 get_names2.py --in_text $file_name --in_spk 3)
  speaker3=$(echo $third_name | python3 get_speaker1.py)
fi

if [ $# -eq 3 ]; then
  third_name=$(python3 get_names2.py --in_text $file_name --in_spk 3)
  speaker3=$(echo $third_name | python3 get_speaker1.py)

  fourth_name=$(python3 get_names2.py --in_text $file_name --in_spk 4)
  sed -i "/$third_name/d" ./$file_name
  sed -i "/$fourth_name/d" ./$file_name
  speaker4=$(echo $fourth_name | python3 get_speaker1.py)
fi



sed -i "/Zdroj:/d" ./$file_name
sed -i "/Datum vysílání:/d" ./$file_name
sed -i "/Čas vysílání:/d" ./$file_name
sed -i "/pořad:/d" ./$file_name
sed -i "/Stopáž:/d" ./$file_name
sed -i "/Pořadí:/d" ./$file_name
sed -i "/<<<Konec>>>/d" ./$file_name
sed -i "/Datum:/d" ./$file_name
sed -i "/Název:/d" ./$file_name
sed -i "/Rozsah:/d" ./$file_name
sed -i "/Text:/d" ./$file_name

dir_name=$(echo $file_name | python3 get_dir_name.py)
speaker1=$(echo $first_name | python3 get_speaker1.py)
speaker2=$(echo $second_name | python3 get_speaker1.py)

echo $dir_name

sed -i "/$first_name/d" ./$file_name
sed -i "/$second_name/d" ./$file_name
if [ $# -eq 2 ]; then
  sed -i "/$third_name/d" ./$file_name
fi

cat $file_name | python3 makepretty.py > tmp.txt
sed 's/[.!?] */&\n/g' ./tmp.txt > tmp1.txt
tr -d \? < tmp1.txt > tmp2.txt
tr -d \. < tmp2.txt > outfile.txt
tr -d \! < outfile.txt > outfile2.txt

tr -d $'\r' < outfile2.txt > ll.txt

cat -s ll.txt > final_ali.txt

python3 speakerid.py --speaker1 $speaker1 --speaker2 $speaker2 >> speaker_id.txt

mkdir final/$dir_name


head -n 20 final_ali.txt

mv $file_name final_ali.txt speaker_id.txt final/$dir_name

rm tmp.txt tmp1.txt tmp2.txt outfile2.txt outfile.txt ll.txt
