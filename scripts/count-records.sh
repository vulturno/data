#!/usr/local/bin/bash

: '
Dependencias: jq - sed(linux)
'

decade=("1950" "1950" "1950" "1950" "1950" "1950" "1950" "1950" "1950" "1950" "1960" "1960" "1960" "1960" "1960" "1960" "1960" "1960" "1960" "1960" "1970" "1970" "1970" "1970" "1970" "1970" "1970" "1970" "1970" "1970" "1980" "1980" "1980" "1980" "1980" "1980" "1980" "1980" "1980" "1980" "1990" "1990" "1990" "1990" "1990" "1990" "1990" "1990" "1990" "1990" "2000" "2000" "2000" "2000" "2000" "2000" "2000" "2000" "2000" "2000" "2010" "2010" "2010" "2010" "2010" "2010" "2010" "2010" "2010" "2010" "2020" "2020" "2020" "2020")

csvjoin -u 1 -y 0 -I ~/github/data/records-dias/total-records-max.csv ~/github/data/decade.csv > ~/github/data/records-dias/decadas-sin-total-max.csv
csvjoin -u 1 -y 0 -I ~/github/data/records-dias/total-records-min.csv ~/github/data/decade.csv > ~/github/data/records-dias/decadas-sin-total-min.csv

for ((j = 0; j < ${#decade[@]}; j++)); do
    csvgrep -c decade -r "${decade[$j]}" ~/github/data/records-dias/decadas-sin-total-max.csv | csvstat -c 2 --sum >> ~/github/data/records-dias/decadas-cont-total-max.csv
    csvgrep -c decade -r "${decade[$j]}" ~/github/data/records-dias/decadas-sin-total-min.csv | csvstat -c 2 --sum >> ~/github/data/records-dias/decadas-cont-total-min.csv
done


sed -i 's/\.//' ~/github/data/records-dias/decadas-cont-total-max.csv ~/github/data/records-dias/decadas-cont-total-min.csv

sed -i 's/\,//g' ~/github/data/records-dias/decadas-cont-total-max.csv ~/github/data/records-dias/decadas-cont-total-min.csv

sed -i '1s/^/totaldecade\n/' ~/github/data/records-dias/decadas-cont-total-max.csv ~/github/data/records-dias/decadas-cont-total-min.csv

csvjoin -u 1 -y 0 -I ~/github/data/records-dias/decadas-sin-total-max.csv ~/github/data/records-dias/decadas-cont-total-max.csv > ~/github/data/records-dias/total-records-max-decade.csv

csvjoin -u 1 -y 0 -I ~/github/data/records-dias/decadas-sin-total-min.csv ~/github/data/records-dias/decadas-cont-total-min.csv > ~/github/data/records-dias/total-records-min-decade.csv

rm ~/github/data/records-dias/{decadas-sin-total-max,decadas-cont-total-max,decadas-sin-total-min,decadas-cont-total-min}.csv
