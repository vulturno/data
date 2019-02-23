#!/usr/local/bin/bash

: '
Dependencias: jq - sed(linux)
A partir de los JSON en bruto vamos a obtener un CSV.
Este CSV solo va a contener la fecha(yyyy-dd-mm), la temperatura máxima y mínima.
Fecha, máxima y mínima corresponden al HEADER del CSV.
Ahora nos quedamos con los valores de .fecha, .tmax y .tmin
Al final pipeamos con la opcion @csv para que exporte un CSV.
El archivo generado se sigue quedando con algunas comillas dobles.
No hacen nada malo pero a mí personalmente me MOLESTAN(TOC).
Así que las eliminamos con sed.
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t indicativo < ~/github/data/stations-indicative.csv

# Recorremos el array de nombre de estación
for (( i=0; i<${#nombre[@]}; ++i )); do

    # Obtenemos un CSV solamente con la fecha, máxima y mínima de cada día
    jq -r '["fecha", "maxima", "minima"], (.[] | select(.tmax != null) | select(.tmin != null) | [.fecha, .tmax, .tmin ]) | @csv' ~/github/data/diarias/"${indicativo[$i]}"-total-diario.json > ~/github/data/day-by-day/"${nombre[$i]}"-diarias.csv

    echo "${nombre[$i]} terminada!"
done

# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' ~/github/data/day-by-day/*.csv
