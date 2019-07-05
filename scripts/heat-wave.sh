#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0 >
Script para obtener las temperaturas máximas
de la ola de calor de junio de 2019
'

# Guardamos en un array el listado de las estaciones
readarray -t nombre < ~/github/data/stations-name.csv


dias=("06-27" "06-28" "06-29" "06-30")

# Variables con la ruta donde se desarrolla la movida
folder=~/github/data/records-dias/maximas/

for ((i = 0; i < ${#nombre[@]}; i++)); do

    for ((j = 0; j < ${#dias[@]}; j++)); do

        csvcut -c 4,6 "$folder"dos-records/"${nombre[$i]}"-dos-records.csv | csvgrep -c fecha -r "${dias[$j]}$" >> "$folder"junio/"${nombre[$i]}"-junio.csv




    done

done

sed -i '2,${/primero,yearprimera/d;}' ~/github/data/records-dias/maximas/junio/*.csv
