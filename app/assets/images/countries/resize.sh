#!/bin/sh

for file in $(ls ./*.png)
do
  #convert ${file} -resize '18x1000>' ${file} # converts with ratio
  convert ${file} -sample '18x12!' ${file}
done

