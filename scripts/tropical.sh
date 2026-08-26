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

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t indicativo < ~/github/data/stations-indicative.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t year < ~/github/data/year.csv


# Recorremos el array de nombre de estación
for (( i=0; i<${#nombre[@]}; ++i )); do
    # Obtenemos un CSV solamente con la fecha, y temperaturas máximas iguales o superiores a 20ºC
    jq -r '["fecha", "minima"], (.[] | select(.tmin >= 20) | select(.tmin != null) | [.fecha, .tmin]) | @csv' ~/github/data/diarias/"${indicativo[$i]}"-total-diario.json > ~/github/data/tropicales/"${nombre[$i]}"-tropicales.csv
    echo "${nombre[$i]} terminada!"
done

# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' ~/github/data/tropicales/*.csv

# Concatenamos todos los CSV de heladas en el mismo
# Recorremos el array en vez de usar *.csv: el glob incluiria el propio destino
# (cat se leeria a si mismo en bucle) y los -count- y -total- de la pasada anterior
for (( i=0; i<${#nombre[@]}; ++i )); do
    cat ~/github/data/tropicales/"${nombre[$i]}"-tropicales.csv
done > ~/github/data/tropicales/total-tropicales.csv &&
echo "Todos los CSV concantenados"

# Al concantenar todos los CSV tenemos todos los headers fecha,min de cada CSV
# Los eliminamos con sed a excepción del primero
sed -i '2,${/fecha/d;}'  ~/github/data/tropicales/total-tropicales.csv

# Recorremos el array de años
for (( i=0; i<${#year[@]}; ++i )); do
    csvgrep -c fecha -r "(${year[$i]})" ~/github/data/tropicales/total-tropicales.csv | csvstat -c fecha --count --csv >> ~/github/data/tropicales/count-tropicales.csv
done

# Eliminamos los row count que produce csvkit
sed -i 's/Row count: //g' ~/github/data/tropicales/count-tropicales.csv &&
# Ahora vamos a crear un CSV con los años y el total de cada año
csvjoin -u 1 -y 0 -I ~/github/data/year.csv ~/github/data/tropicales/count-tropicales.csv > ~/github/data/total-tropicales.csv

# Añadimos el header con year y total al csv
sed -i '1s/^/year,total\n/' ~/github/data/total-tropicales.csv

echo "Mission acomplished!! 🤓"
