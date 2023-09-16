#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0 >
Este script solo sirve para volver a contar todos los records
de máximas. Necesitamos haber extraído o actualizado el último mes
'

cat ~/github/data/records-dias/maximas/*-records.csv > ~/github/data/records-dias/records-maxima-year.csv

sed -i '2,${/fecha/d}' ~/github/data/records-dias/records-maxima-year.csv


for k in {1950..2023}
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
