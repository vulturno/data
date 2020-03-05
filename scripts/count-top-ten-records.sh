#!/usr/local/bin/bash

: '
Dependencias: jq - sed(linux)
'

# Generamos el array cargando la lista de nombres de estación
readarray -t nombre < ~/github/data/stations-name.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t indicativo < ~/github/data/stations-indicative.csv

# Generamos el array cargando la lista de los indicativos de cada estación
readarray -t year < ~/github/data/year.csv


for x in {1950..2020};
  do
    csvgrep -c year -r "^${x}" ~/github/data/records-dias/maximas/top-records/total/all-stations.csv | csvstat -c year --count >>  ~/github/data/records-dias/maximas/top-records/total/count-top-records.csv
  done


  # Eliminamos los row count que produce csvkit
  sed -i 's/Row count: //g' ~/github/data/records-dias/maximas/top-records/total/count-top-records.csv &&

  # Ahora vamos a crear un CSV con los años y el total de cada año
  csvjoin -u 1 ~/github/data/year.csv ~/github/data/records-dias/maximas/top-records/total/count-top-records.csv > ~/github/data/records-dias/maximas/top-records/total/count-without-rows-top-records.csv

  # Añadimos el header con year y total al csv
  sed -i '1s/^/year,total\n/' ~/github/data/records-dias/maximas/top-records/total/count-without-rows-top-records.csv &&

  rm ~/github/data/records-dias/maximas/top-records/total/count-top-records.csv &&
  mv ~/github/data/records-dias/maximas/top-records/total/count-without-rows-top-records.csv ~/github/data/records-dias/maximas/top-records/total/count-top-records.csv &&
  rm ~/github/data/records-dias/maximas/top-records/total/count-without-rows-top-records.csv

