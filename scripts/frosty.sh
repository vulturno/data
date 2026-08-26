#!/usr/local/bin/bash

: '
Dependencias: jq 1.6 - sed(linux) - bash 5.0 - csvkit 1.0.3

A partir de los JSON en bruto vamos a obtener un CSV.
Este CSV solo va a contener aquella temperaturas mínimas que son iguales o inferiores a 0ºC.
Esto es lo que se llama una helada.
Ahora vamos a seleccionar aquellos valores que son iguales o inferiores a 0ºC en .tmin
Y nos quedamos con los valores de .fecha y .tmin
Al final pipeamos con la opcion @csv para que exporte un CSV.
El archivo generado se sigue quedando con algunas comillas dobles.
No hacen nada malo pero a mí personalmente me MOLESTAN(TOC).
Así que las eliminamos con sed.
Concatenamos todos los CSV en uno solo
Eliminamos los headers de los CSV a excepción del primero
Ahora vamos a contabilizar las heladas por año
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t indicativo < ~/github/data/stations-indicative.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t year < ~/github/data/year.csv

# Recorremos el array de nombre de estación
for (( i=0; i<${#nombre[@]}; ++i )); do
    # Obtenemos un CSV solamente con la fecha, y temperaturas mínimas iguales o inferiores a 0ºC
    jq -r '["fecha", "min"], (.[] | select(.tmin <= 0) | select(.tmin != null) | [.fecha, .tmin]) | @csv' ~/github/data/diarias/"${indicativo[$i]}"-total-diario.json > ~/github/data/heladas/"${nombre[$i]}"-heladas.csv

    echo "${nombre[$i]} terminada!"

done

# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' ~/github/data/heladas/*.csv

# Concatenamos todos los CSV de heladas en el mismo
# Recorremos el array en vez de usar *.csv: el glob incluiria el propio destino
# (cat se leeria a si mismo en bucle) y los -count- y -total- de la pasada anterior
for (( i=0; i<${#nombre[@]}; ++i )); do
    cat ~/github/data/heladas/"${nombre[$i]}"-heladas.csv
done > ~/github/data/heladas/total-heladas.csv &&
echo "Todos los CSV concantenados"

# Al concantenar todos los CSV tenemos todos los headers fecha,min de cada CSV
# Los eliminamos con sed a excepción del primero
sed -i '2,${/fecha/d;}' ~/github/data/heladas/total-heladas.csv

# Recorremos el array de años
for (( i=0; i<${#year[@]}; ++i )); do
    csvgrep -c fecha -r "(${year[$i]})" ~/github/data/heladas/total-heladas.csv | csvstat -c fecha --count --csv >> ~/github/data/heladas/count-heladas.csv
done

# Eliminamos los row count que produce csvkit
sed -i 's/Row count: //g' ~/github/data/heladas/count-heladas.csv &&
# Ahora vamos a crear un CSV con los años y el total de cada año
csvjoin -u 1 -y 0 -I ~/github/data/year.csv ~/github/data/heladas/count-heladas.csv > ~/github/data/total-heladas.csv

# Añadimos el header con year y total al csv
sed -i '1s/^/year,total\n/' ~/github/data/total-heladas.csv

echo "Mission acomplished!! 🤓"
