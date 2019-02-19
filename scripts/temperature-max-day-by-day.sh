#!/usr/local/bin/bash

<<comentario
Dependencias: csvkit - sed(linux)
A partir de todos los CSV de todas las estaciones
Vamos a obtener la temperatura máxima de cada día

comentario

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t days < ~/github/data/dias.csv

# Recorremos el array de nombre de estación
for ((i = 0; i < ${#nombre[@]}; i++)); do

    for ((j = 0; j < ${#days[@]}; j++)); do

        csvgrep -c fecha -r "${days[$j]}$" ~/github/data/day-by-day/${nombre[$i]}-diarias.csv | csvsort -c maxima -r > temp.csv &&
        sed '1,2!d' temp.csv >> ~/github/data/records-dias/${nombre[$i]}-records.csv &&
        rm temp.csv

    done
    echo "${nombre[$i]} terminada!"

done

sed -i '2,${/fecha/d;}' ~/github/data/records-dias/*.csv
