#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0

Importante, para ejecutar este script se necesita
haber lanzado: count-max-day-by-day.sh

Voy a recorrer un for de años.
Entro en 1950. Con CSVGREP busco todas las fechas que empiecen por 1950.
Ahora con CSVSTAT obtengo el total de fechas de 1950 y el resultado lo guardo en un CSV.
Cuando acaba el bucle elimino todos los row count que produce CSVSTAT
Ahora vamos a crear un CSV con CSVJOIN, por un lado obtenemos la columna year, y por otro el
total de días de cada año.
Y por último con sed añadimos el HEADER del CSV

'

for i in {1950..2018};
    do
            csvgrep -c fecha -r "^$i" ~/github/data/records-dias/records-maxima-year.csv | csvstat --count >> ~/github/data/records-dias/records-count-year.csv
    done

# Eliminamos los row count que produce csvkit
sed -i 's/Row count: //g' ~/github/data/records-dias/records-count-year.csv &&
# Ahora vamos a crear un CSV con los años y el total de cada año
csvjoin -u 1 ~/github/data/year.csv ~/github/data/records-dias/records-count-year.csv > ~/github/data/records-dias/total-records-max.csv

# Añadimos el header con year y total al csv
sed -i '1s/^/year,total\n/' ~/github/data/records-dias/total-records-max.csv
