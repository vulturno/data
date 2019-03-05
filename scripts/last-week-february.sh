#!/usr/local/bin/bash

: '
Dependencias: jq - sed(linux)
Vamos a quedarnos con la última semana de febrero de cada uno de los años
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t days < ~/github/data/last-week-february.csv

# Recorremos el array stations
for (( i=0; i<${#nombre[@]}; ++i )); do

    for (( j=0; j<${#days[@]}; ++j )); do
    csvgrep -c fecha -r "${days[$j]}$" ~/github/data/day-by-day/"${nombre[$i]}"-diarias.csv >> ~/github/data/febrero/"${nombre[$i]}"-last-week-february.csv
    done

    echo "${nombre[$i]}"

done


sed -i '2,${/fecha/d;}' ~/github/data/febrero/*.csv
