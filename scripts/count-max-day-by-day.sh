#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux)
A partir de todos los CSV de todas las estaciones
Vamos a obtener la temperatura máxima de cada día
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t year < ~/github/data/year.csv

# Recorremos el array de nombre de estación
for ((i = 0; i < ${#year[@]}; i++)); do

    for ((j = 0; j < ${#nombre[@]}; j++)); do

        csvgrep -c fecha -r "^${year[$i]}" ~/github/data/records-dias/"${nombre[$j]}"-records.csv >> ~/github/data/records-dias/records-maxima-year.csv

    done
    echo "${year[$i]} terminada!"

done

sed -i '2,${/fecha/d;}' ~/github/data/records-dias/records-maxima-year.csv
