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

# Array con todos los indicativos de todas las estaciones de la AEMET
station=('0016A' '0076' '0367' '1024E' '1082' '1109' '1249I' '1387' '1428' '1484C' '1690A' '2030' '2331' '2400E' '2444' '2465' '2539' '2661' '2867' '3195' '3260B' '3469A' '4121' '4452' '4642E' '5402' '5514' '5783' '5960' '6000A' '6155A' '6325O' '7031' '8025' '8096' '8175' '8416' '8500A' '9091O' '9170' '9434' '9771C' '9898' 'B278' 'C447A' 'C649I')

# Recorremos el array stations
for (( i=0; i<${#station[@]}; ++i )); do
    # Convierte JSON a CSV directamente con JQ
    jq -r 'map(select(.fecha | contains("-13")) |
           {"year": .fecha, "temp": .tm_mes}) |
           (.[0] | keys_unsorted) as $keys |
           ($keys | @csv),
           (.[] | [.[$keys[]]] | @csv)' \
        ~/github/data/anuales/"${station[$i]}"-total-anual.json |
    sed 's/-13//g' > ~/github/data/anuales/csv/"${station[$i]}".csv &&
    echo "${station[$i]}"
done
