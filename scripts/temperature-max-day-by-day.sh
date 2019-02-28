#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0 >
A partir de todos los CSV de todas las estaciones
Vamos a obtener el record de temperatura máxima
de cada dia del año entre la serie de años de
cada estación.
Primero recorro cada estación con un for, en cuanto este en la primera estación
entro en el siguiente for que recorrerá los 366 días del año.
Ahora con csvgrep busco un día en el archivo de la estación.
Por ejemplo: en el primer bucle obtengo todos los uno de enero de TODOS los años.
Ahora ordeno los resultados en base a la columna de temperatura máxima,
así el primer resultado sera la temperatura más alta de ese día.
Lo guardamos en temp.csv
Ahora eliminamos con sed el resto de de días y lo guardamos con el nombre de la estación.
Así con los 366 días del año y con las 45 estaciones que analizo.
En último lugar elimino todas las cabeceras de los CSV(fecha, máxima) de todos los archivos
que he generado.

Tiempo aproximado de ejecución: 4 horas
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t days < ~/github/data/dias.csv

# Recorremos el array de nombre de estación
for ((i = 0; i < ${#nombre[@]}; i++)); do

    for ((j = 0; j < ${#days[@]}; j++)); do

        csvgrep -c fecha -r "${days[$j]}$" ~/github/data/day-by-day/"${nombre[$i]}"-diarias.csv | csvsort -c maxima -r > temp.csv &&
        sed '1,2!d' temp.csv >> ~/github/data/records-dias/"${nombre[$i]}"-records.csv &&
        rm temp.csv

    done
    echo "${nombre[$i]} terminada!"

done

sed -i '2,${/fecha/d;}' ~/github/data/records-dias/*.csv

cat "$(find -- ~/github/data/records-dias/*-records.csv)" > ~/github/data/records-dias/records-maxima-year.csv

sed -i '2,${/fecha/d;}' ~/github/data/records-dias/minimas/records-maxima-year.csv

for k in {1950..2018};
    do
            csvgrep -c fecha -r "^$k" ~/github/data/records-dias/records-maxima-year.csv | csvstat --count >> ~/github/data/records-dias/records-count-year.csv
            echo "${nombre[$k]} terminada!"
    done

# Eliminamos los row count que produce csvkit
sed -i 's/Row count: //g' ~/github/data/records-dias/records-count-year.csv &&

# Ahora vamos a crear un CSV con los años y el total de cada año
csvjoin -u 1 ~/github/data/year.csv ~/github/data/records-dias/records-count-year.csv > ~/github/data/records-dias/total-records-max.csv

# Añadimos el header con year y total al csv
sed -i '1s/^/year,total\n/' ~/github/data/records-dias/total-records-max.csv
