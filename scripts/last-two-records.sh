#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0 >
Para obtener la primera y la segunda temperatura más alta de cada día del año

Tiempo aproximado de ejecución: 4 horas
'

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t days < ~/github/data/dias.csv


for ((j = 0; j < ${#days[@]}; j++)); do

    csvgrep -c fecha -r "${days[$j]}$" ~/github/data/day-by-day/Zaragoza-diarias.csv | csvsort -c maxima -r > temp.csv &&
    sed '1,3!d' temp.csv >> ~/github/data/records-dias/maximas/Zaragoza-dos-records.csv &&
    rm temp.csv

done

folder=~/github/data/records-dias/maximas/

sed -i '2,${/fecha/d;}' "$folder"Zaragoza-dos-records.csv

# Eliminamos impares nos quedamos con el primer record
sed '1~2d' "$folder"Zaragoza-dos-records.csv > "$folder"temp-primer-record.csv

sed -i '1s/^/fecha,maxima,minima\n/' "$folder"temp-primer-record.csv

# Nos quedamos solo con la columna del primer record
csvcut -c 2 "$folder"temp-primer-record.csv > "$folder"primer-record.csv

# Nos quedamos solamente con la columna de fecha que posteriormente utilizaremos para
csvcut -c 1 "$folder"temp-primer-record.csv > "$folder"fecha-record-primera.csv

# Sustituimos el header del CSV
sed -i 's/fecha/fechaprimero/g' "$folder"fecha-record-primera.csv

# Sustituimos el header del CSV
sed -i 's/maxima/primero/g' "$folder"primer-record.csv

# Eliminamos el temporal que hemos creado
rm "$folder"temp-primer-record.csv

# Eliminamos pares, nos quedamos con el segundo record
sed '0~2d' "$folder"Zaragoza-dos-records.csv > "$folder"temp-segundo-record.csv

# Nos quedamos solo con la columna del segundo record
csvcut -c 2 "$folder"temp-segundo-record.csv > "$folder"segundo-record.csv

# Nos quedamos solamente con la columna de fecha que posteriormente utilizaremos para
csvcut -c 1 "$folder"temp-segundo-record.csv > "$folder"fecha-record-segunda.csv

# Sustituimos el header del CSV
sed -i 's/fecha/fechasegundo/g' "$folder"fecha-record-segunda.csv

# Sustituimos el header del CSV
sed -i 's/maxima/segundo/g' "$folder"segundo-record.csv

# Eliminamos el temporal que hemos creado
rm "$folder"temp-segundo-record.csv


# Ahora vamos a generar el CSV
csvjoin -u 1 "$folder"fecha-record-primera.csv "$folder"primer-record.csv "$folder"segundo-record.csv "$folder"fecha-record-segunda.csv  >"$folder"Zaragoza-primero-segundo-record.csv

rm "$folder"{segundo-record,primer-record,fecha-record,Zaragoza-dos-records,fecha-record-segunda,fecha-record-primera}.csv

mv "$folder"Zaragoza-primero-segundo-record.csv "$folder"Zaragoza-dos-records.csv
