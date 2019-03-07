#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0 >
Script para obtener la primera y la segunda temperatura más alta de cada día del año
'

# Generamos el array cargando la lista de dias
readarray -t days < ~/github/data/dias.csv

# Guardamos en un array el listado de las estaciones
readarray -t nombre < ~/github/data/stations-name.csv

# Variables con la ruta donde se desarrolla la movida
folder=~/github/data/records-dias/maximas/dos-records/

# Comprobamos si ya tenemos creado el directorio
if [[ -d "$folder" ]] ; then

    # Si lo tenemos creado eliminamos todos los archivos
    echo "El directorio ya existe, eliminamos los records anteriores"
    rm "$folder"/*.*

else

    # No lo tenemos, pues lo creamos
    echo "El directorio no existe, lo creamos"
    mkdir "$folder"
fi

for ((i = 0; i < ${#nombre[@]}; i++)); do

    for ((j = 0; j < ${#days[@]}; j++)); do

        csvgrep -c fecha -r "${days[$j]}$" ~/github/data/day-by-day/"${nombre[$i]}"-diarias.csv | csvsort -c maxima -r > "$folder"temp.csv
        sed '1,3!d' "$folder"temp.csv >> "$folder""${nombre[$i]}"-dos-records.csv

    done

    sed -i '2,${/fecha/d;}' "$folder""${nombre[$i]}"-dos-records.csv

    # Eliminamos impares nos quedamos con el primer record
    sed '1~2d' "$folder""${nombre[$i]}"-dos-records.csv > "$folder"temp-primer-record.csv

    sed -i '1s/^/fecha,maxima,minima\n/' "$folder"temp-primer-record.csv

    # Nos quedamos solo con la columna del primer record
    csvcut -c 2 "$folder"temp-primer-record.csv > "$folder"primer-record.csv

    # Nos quedamos solamente con la columna de fecha que posteriormente utilizaremos
    csvcut -c 1 "$folder"temp-primer-record.csv > "$folder"fecha-record-primera.csv

    # A partir del CSV que solo contiene la fecha creamos otros que solo tiene el año
    sed -r '1! s/-.*//' "$folder"fecha-record-primera.csv > "$folder"year-record-primera.csv

    # Nos quedamos solo con el día
    sed -r '1! s/.*(.{2})/\1/' "$folder"fecha-record-primera.csv > "$folder"fecha-records.csv

    # Nos quedamos con el día y el mes
    sed -r '1! s/.{5}//' "$folder"fecha-record-primera.csv

    # Sustituimos el header del CSV
    sed -i 's/fecha/dia/g' "$folder"fecha-records.csv

    # Sustituimos el header del CSV
    sed -i 's/fecha/yearprimera/g' "$folder"year-record-primera.csv

    # Sustituimos el header del CSV
    sed -i 's/maxima/primero/g' "$folder"primer-record.csv

    # Eliminamos el temporal que hemos creado
    rm "$folder"temp-primer-record.csv

    # Eliminamos pares, nos quedamos con el segundo record
    sed '0~2d' "$folder""${nombre[$i]}"-dos-records.csv > "$folder"temp-segundo-record.csv

    # Nos quedamos solo con la columna del segundo record
    csvcut -c 2 "$folder"temp-segundo-record.csv > "$folder"segundo-record.csv

    # Nos quedamos solamente con la columna de fecha que posteriormente utilizaremos para
    csvcut -c 1 "$folder"temp-segundo-record.csv > "$folder"fecha-record-segunda.csv

    # Nos quedamos solo con el año
    sed -r 's/-.*//' "$folder"fecha-record-segunda.csv > "$folder"year-record-segunda.csv

    # Sustituimos el header del CSV
    sed -i 's/fecha/yearsegundo/g' "$folder"year-record-segunda.csv

    # Sustituimos el header del CSV
    sed -i 's/maxima/segundo/g' "$folder"segundo-record.csv

    # Eliminamos el temporal que hemos creado
    rm "$folder"temp-segundo-record.csv

    # Ahora vamos a generar el CSV
    csvjoin -u 1 "$folder"fecha-record-primera.csv "$folder"fecha-records.csv "$folder"primer-record.csv "$folder"segundo-record.csv "$folder"year-record-primera.csv "$folder"year-record-segunda.csv > "$folder""${nombre[$i]}"-primero-segundo-record.csv

    # Eliminamos todos los archivos que ya no son necesarios
    rm "$folder"{segundo-record,primer-record,"${nombre[$i]}"-dos-records,fecha-record-segunda,fecha-record-primera,year-record-segunda,year-record-primera,temp,fecha-records}.csv

    mv "$folder""${nombre[$i]}"-primero-segundo-record.csv "$folder""${nombre[$i]}"-dos-records.csv

    # Para saber cuantas estaciones quedan pendientes de analizar
    x=$((${#nombre[@]} - 1))
    y=$i
    left=$((x - y))

    echo "${nombre[$i]} terminada! Quedan $left estaciones por analizar"

done
