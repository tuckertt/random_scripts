#!/bin/bash

listing=$(ls -d */Subs/*/*Eng*)
#echo "$testing"
for filename in $listing;  do
#  echo "this is the file $filename"
  direct=$(echo $filename | cut -d/ -f1 )
  srt_name=$(echo $filename | cut -d/ -f3 )
#  echo "this is the directory $direct"
  file_number=$(echo $filename | grep -Eo '[0-9]+'| tail -n 1)
#  echo "file number is $file_number"
#  echo "copying for $direct"
  cp $filename "$direct/$srt_name.Eng($file_number).srt"
done

listing2=$(ls -d */subs/*/*Eng*)
#echo "$testing"
for filename in $listing2;  do
#  echo "this is the file $filename"
  direct=$(echo $filename | cut -d/ -f1 )
  srt_name=$(echo $filename | cut -d/ -f3 )
#  echo "this is the directory $direct"
  file_number=$(echo $filename | grep -Eo '[0-9]+'| tail -n 1)
#  echo "file number is $file_number"
  echo "copying for $direct"
  cp $filename "$direct/$srt_name.Eng($file_number).srt"

done
