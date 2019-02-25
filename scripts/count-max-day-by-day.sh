#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0

Importante, para ejecutar este script se necesita
haber lanzado: temperature-max-day-by-day.sh

Entro en el for, corresponde a los años.
Estamos en 1950 y acto seguido entro al siguiente for, corresponde a estaciones.
Seguimos en 1950 pero en la estación de la AEMET de Albacete.
Ahora con CSVGREP busco en la columna fecha todas las fechas
que comiencen por 1950 y las guardo en un archivo de records.
Así hasta 2018 y con todas las estaciones.
En último lugar elimino todas las cabeceras de los CSV(fecha, máxima) de todos los archivos
que he generado.

Tiempo aproximado de ejecución: 30 minutos
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t year < ~/github/data/year.csv

# Recorremos el array de años
for ((i = 0; i < ${#year[@]}; i++)); do

    for ((j = 0; j < ${#nombre[@]}; j++)); do

        csvgrep -c fecha -r "^${year[$i]}" ~/github/data/records-dias/"${nombre[$j]}"-records.csv >> ~/github/data/records-dias/records-maxima-year.csv

    done
    echo "${year[$i]} terminada!"

done

sed -i '2,${/fecha/d;}' ~/github/data/records-dias/records-maxima-year.csv
