#!/usr/local/bin/bash

<<comentario
Dependencias: jq - sed(linux)
A partir de los JSON en bruto vamos a obtener un CSV.
Este CSV solo va a contener aquella temperaturas máximas iguales o superiores a 30ºC.
Esto es lo que se llama una noche tropical.
Ahora vamos a seleccionar aquellos valores que son iguales o superiores a 30ºC en .tmax
Y nos quedamos con los valores de .fecha y .tmax
Al final pipeamos con la opcion @csv para que exporte un CSV.
El archivo generado se sigue quedando con algunas comillas dobles.
No hacen nada malo pero a mí personalmente me MOLESTAN(TOC).
Así que las eliminamos con sed.
comentario

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t indicativo < ~/github/data/stations-indicative.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t year < ~/github/data/year.csv

# Recorremos el array de nombre de estación
for (( i=0; i<${#nombre[@]}; ++i )); do
    # Obtenemos un CSV solamente con la fecha, y temperaturas máximas iguales o superiores a 30ºC
    jq -r '["fecha", "maxima"], (.[] | select(.tmax >= 40) | select(.tmax != null) | [.fecha, .tmax]) | @csv' ~/github/data/diarias/${indicativo[$i]}-total-diario.json > ~/github/data/temp-40/${nombre[$i]}-temp-40.csv
    echo "${nombre[$i]} terminada!"
done


# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' ~/github/data/temp-40/*.csv

# Concatenamos todos los CSV de heladas en el mismo
cat ~/github/data/temp-40/*.csv > ~/github/data/temp-40/total-temp-40.csv &&
echo "Todos los CSV concantenados"

# Al concantenar todos los CSV tenemos todos los headers fecha,min de cada CSV
# Los eliminamos con sed a excepción del primero
sed -i '2,${/fecha/d;}'  ~/github/data/temp-40/total-temp-40.csv

# Recorremos el array de años
for (( i=0; i<${#year[@]}; ++i )); do
    csvgrep -c fecha -r "(${year[$i]})" ~/github/data/temp-40/total-temp-40.csv | csvstat -c fecha --count --csv >> ~/github/data/temp-40/count-temp-40.csv
done

# Eliminamos los row count que produce csvkit
sed -i 's/Row count: //g' ~/github/data/temp-40/count-temp-40.csv &&
# Ahora vamos a crear un CSV con los años y el total de cada año
csvjoin -u 1 ~/github/data/year.csv ~/github/data/temp-40/count-temp-40.csv > ~/github/data/total-temp-40.csv

# Añadimos el header con year y total al csv
sed -i '1s/^/year,total\n/' ~/github/data/total-temp-40.csv

echo "Mission acomplished!! 🤓"

say -v Alex "Mission acomplished"
