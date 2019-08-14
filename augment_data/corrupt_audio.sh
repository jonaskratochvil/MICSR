#!/bin/bash
# Number of files to augment and weights of augmentation loudness

# TODO: Script is still in debug mode, for final use remove echo 
# TODO: Make the factors stochastic,, check out noises in https://www.openslr.org/17/
# TODO: Make 2-3 times the data
N=10
BAR_LOW=0.2
NATURE_LOW=0.7
TRAFFIC_LOW=0.4
FACTORY_LOW=0.4
# This takes N files at random 
ls *.wav | sort -R | tail -$N | while read file ; do
  soxi $file | grep "Duration" | python3 getduration.py >> start_and_stop.txt
  # save first lines to array and than to variables
  files=( $(cat start_and_stop.txt) )
  start_time=${files[0]}
  duration=${files[1]}
  recording_number=${files[2]}
  
  # Save file name without extension and copy transcript
  y=${file%.wav}
  cp $file.trn "$y.augmented.wav.trn"
  
  # Distinguish different cases
  if [[ $recording_number -eq 0 ]]; then 
    
    # -ss is start time and -t is duration from that start time
     < /dev/null ffmpeg -ss $start_time -t $duration -i final_new_bar.mp3 -acodec copy tmp.mp3

     < /dev/null ffmpeg -i tmp.mp3 output.wav ; rm tmp.mp3
    
    # convert wav file to match recordings
     sox output.wav -r 16000 -c 1 output2.wav ; rm output.wav
     
     # lower the volume of MP3
     sox -v $BAR_LOW output2.wav reduced.wav ; rm output2.wav

    echo $file >> roztridit.txt
    echo "BAR" >> roztridit.txt
  
  elif [[ $recording_number -eq 1 ]]; then

     < /dev/null ffmpeg -ss $start_time -t $duration -i final_new_machine_sound.mp3 -acodec copy tmp.mp3

     < /dev/null ffmpeg -i tmp.mp3 output.wav ; rm tmp.mp3

     sox output.wav -r 16000 -c 1 output2.wav ; rm output.wav

     sox -v $FACTORY_LOW output2.wav reduced.wav ; rm output2.wav
  
    echo $file >> roztridit.txt
    echo "MACHINE" >> roztridit.txt

  elif [[ $recording_number -eq 2 ]]; then

     < /dev/null ffmpeg -ss $start_time -t $duration -i final_new_night_nature.mp3 -acodec copy tmp.mp3

     < /dev/null ffmpeg -i tmp.mp3 output.wav ; rm tmp.mp3

     sox output.wav -r 16000 -c 1 output2.wav ; rm output.wav

     sox -v $NATURE_LOW output2.wav reduced.wav ; rm output2.wav

     echo $file >> roztridit.txt
     echo "NATURE" >> roztridit.txt

  elif [[ $recording_number -eq 3 ]]; then

     < /dev/null ffmpeg -ss $start_time -t $duration -i final_new_night_traffic.mp3 -acodec copy tmp.mp3

     < /dev/null ffmpeg -i tmp.mp3 output.wav ; rm tmp.mp3

     sox output.wav -r 16000 -c 1 output2.wav ; rm output.wav

     sox -v $TRAFFIC_LOW output2.wav reduced.wav ; rm output2.wav

     echo $file >> roztridit.txt
     echo "TRAFFIC" >> roztridit.txt
  
  fi

  sox -m $file reduced.wav "$y.augmented.wav" ; rm reduced.wav
  rm start_and_stop.txt
done
