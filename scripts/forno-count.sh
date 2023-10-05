#!/usr/local/bin/bash

: '
Dependencias: jq - sed(linux)
A partir de los JSON en bruto vamos a obtener un CSV.
Este CSV solo va a contener aquella temperaturas mínimás iguales o superiores a 20ºC.
Esto es lo que se llama una noche tropical.
Ahora vamos a seleccionar aquellos valores que son iguales o superiores a 20ºC en .tmin
Y nos quedamos con los valores de .fecha y .tmin
Al final pipeamos con la opcion @csv para que exporte un CSV.
El archivo generado se sigue quedando con algunas comillas dobles.
No hacen nada malo pero a mí personalmente me MOLESTAN(TOC).
Así que las eliminamos con sed.
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array de la serie de años
readarray -t year < ~/github/data/year.csv


# Recorremos el array de nombre de estación
for (( i=0; i<${#nombre[@]}; ++i )); do

    # Recorremos el array de años
    for (( j=0; j<${#year[@]}; ++j )); do
        csvgrep -c fecha -r "^${year[$j]}" ~/github/data/extreme-temp/ciudades/"${nombre[$i]}"-40.csv | csvstat -c fecha --count >> ~/github/data/extreme-temp/ciudades/"${nombre[$i]}"-count-40.csv

    done

    # Eliminamos los row count que produce csvkit
    sed -i 's/Row count: //g' ~/github/data/extreme-temp/ciudades/"${nombre[$i]}"-count-40.csv &&

    # Ahora vamos a crear un CSV con los años y el total de cada año
    csvjoin -u 1 -y 0 ~/github/data/year.csv ~/github/data/extreme-temp/ciudades/"${nombre[$i]}"-count-40.csv > ~/github/data/extreme-temp/ciudades/"${nombre[$i]}"-total-40.csv

    # Añadimos el header con year y total al csv
    sed -i '1s/^/year,total\n/' ~/github/data/extreme-temp/ciudades/"${nombre[$i]}"-total-40.csv

    echo "${nombre[$i]} terminada!"


done

echo "Mission acomplished!! 🤓"
