#!/bin/sh

for file in $(ls .)
do
  convert ${file} -resize '1000x12>' ${file}
done

