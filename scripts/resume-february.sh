#!/usr/local/bin/bash

: '
Dependencias: jq - json2csv - sed(linux)
Vamos a quedarnos solamente con el resumen anual de cada año.
Y de ese resumen solamente con la temperatura media del año.
Recorremos todas las estaciones con un for sobre el array de station.
Con jq creamos un JSON solamente con la fecha y la temperatura.
Con sed eliminamos el -13 de la fecha.
Convertimos el json a csv.
Y por último eliminamos todos los archivos que hemos creado con el nombre limpio.
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t indicativo < ~/github/data/stations-indicative.csv

# Recorremos el array stations
for (( i=0; i<${#nombre[@]}; ++i )); do
    jq -c 'map(select(.fecha | contains("-2")) |  {"year": .fecha, "temp": .tm_mes} )' ~/github/data/anuales/"${indicativo[$i]}"-total-anual.json >> ~/github/data/febrero/"${indicativo[$i]}"-limpio.json &&
    sed -i 's/\-2"/"/g' ~/github/data/febrero/"${indicativo[$i]}"-limpio.json &&
    jq -r '["year", "temp"], (.[] | select(.temp!= null) | [.year, .temp]) | @csv' ~/github/data/febrero/"${indicativo[$i]}"-limpio.json > ~/github/data/febrero/"${nombre[$i]}".csv

    echo "${nombre[$i]}"

done

sed -i 's/\"//g' ~/github/data/febrero/*.csv

find . -name '*-limpio*' -delete
