#!/usr/local/bin/bash

: '
Dependencias: jq - sed(linux)
A partir de los JSON en bruto vamos a obtener varios CSV.
Cada CSV va a contener una franja de temperatura.
Desde los 35ºC hasta los 50ºC.
Ahora vamos a seleccionar aquellos valores que son iguales o superiores a 50ºC en .tmax
Y nos quedamos con los valores de .fecha y .tmax
Al final pipeamos con la opcion @csv para que exporte un CSV.
El archivo generado se sigue quedando con algunas comillas dobles.
No hacen nada malo pero a mí personalmente me MOLESTAN(TOC).
Así que las eliminamos con sed.
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t indicativo < ~/github/data/stations-indicative.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t year < ~/github/data/year.csv

# Creamos el directorio
mkdir ~/github/data/extreme-temp

for x in {35..50};
    do
        # Creamos un directorio por cada temperatura "extrema"
        mkdir ~/github/data/extreme-temp/temp-"$x"

        # Recorremos el array de nombre de estación
        for (( i=0; i<${#nombre[@]}; ++i )); do

            # Obtenemos un CSV solamente con la fecha, y temperaturas máximas iguales o superiores a 50ºC
            jq -r '["fecha", "maxima"], (.[] | select(.tmax >= '$x') | select(.tmax != null) | [.fecha, .tmax]) | @csv' ~/github/data/diarias/"${indicativo[$i]}"-total-diario.json > ~/github/data/extreme-temp/temp-"$x"/"${nombre[$i]}"-temp-"$x".csv
            echo "${nombre[$i]} terminada!"
        done


        # jq deja algunas comillas en el CSV, las eliminamos con sed :)
        sed -i 's/\"//g' ~/github/data/extreme-temp/temp-"$x"/*.csv

        # Concatenamos todos los CSV de heladas en el mismo
        # Recorremos el array en vez de usar *.csv: el glob incluiria el propio destino
        # (cat se leeria a si mismo en bucle) y los -count- y -total- de la pasada anterior
        for (( i=0; i<${#nombre[@]}; ++i )); do
            cat ~/github/data/extreme-temp/temp-"$x"/"${nombre[$i]}"-temp-"$x".csv
        done > ~/github/data/extreme-temp/temp-"$x"/total-temp-"$x".csv &&
        echo "Todos los CSV concantenados"

        # Al concantenar todos los CSV tenemos todos los headers fecha,min de cada CSV
        # Los eliminamos con sed a excepción del primero
        sed -i '2,${/fecha/d;}'  ~/github/data/extreme-temp/temp-"$x"/total-temp-"$x".csv

        # Recorremos el array de años
        for (( j=0; j<${#year[@]}; ++j )); do
            csvgrep -c fecha -r "(${year[$j]})" ~/github/data/extreme-temp/temp-"$x"/total-temp-"$x".csv | csvstat -c fecha --count --csv >> ~/github/data/extreme-temp/temp-"$x"/count-temp-"$x".csv
        done

        # Eliminamos los row count que produce csvkit
        sed -i 's/Row count: //g' ~/github/data/extreme-temp/temp-"$x"/count-temp-"$x".csv &&

        # Ahora vamos a crear un CSV con los años y el total de cada año
        csvjoin -u 1 -y 0 -I ~/github/data/year.csv ~/github/data/extreme-temp/temp-"$x"/count-temp-"$x".csv > ~/github/data/extreme-temp/total-temp-"$x".csv

        # Añadimos el header con year y total al csv
        sed -i '1s/^/year,total\n/' ~/github/data/extreme-temp/total-temp-"$x".csv

        echo "Mission acomplished!! 🤓"

done
