#!/bin/sh

for file in $(ls ./*-flag.png)
do
  #convert ${file} -resize '18x1000>' ${file} # converts with ratio
  convert ${file} -resize '1800x80>' ${file}
done

