#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux)
A partir de todos los CSV de todas las estaciones
Vamos a obtener la temperatura máxima de cada día
'

for i in {1950..2018};
    do
            csvgrep -c fecha -r "^$i" ~/github/data/records-dias/records-maxima-year.csv | csvstat --count >> ~/github/data/records-dias/records-count-year.csv
    done

# Eliminamos los row count que produce csvkit
sed -i 's/Row count: //g' ~/github/data/records-dias/records-count-year.csv &&
# Ahora vamos a crear un CSV con los años y el total de cada año
csvjoin -u 1 ~/github/data/year.csv ~/github/data/records-dias/records-count-year.csv > ~/github/data/records-dias/total-records-max.csv

# Añadimos el header con year y total al csv
sed -i '1s/^/year,total\n/' ~/github/data/records-dias/total-records-max.csv
