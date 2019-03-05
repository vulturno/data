#!/usr/local/bin/bash


for k in {1950..2019}
    do
            csvgrep -c fecha -r "^$k" ~/github/data/records-dias/records-maxima-year.csv | csvstat --count >> ~/github/data/records-dias/records-maximas-count-year.csv
            echo "$k terminada!"
    done

# Eliminamos los row count que produce csvkit
sed -i 's/Row count: //g' ~/github/data/records-dias/records-maximas-count-year.csv &&

# Ahora vamos a crear un CSV con los años y el total de cada año
csvjoin -u 1 ~/github/data/year.csv ~/github/data/records-dias/records-maximas-count-year.csv > ~/github/data/records-dias/total-records-max.csv

# Añadimos el header con year y total al csv
sed -i '1s/^/year,total\n/' ~/github/data/records-dias/total-records-max.csv
