#!/usr/local/bin/bash

: '
Dependencias: sed(linux) - bash 4.0 >
Unificamos todos los meses de cada una de las estaciones en el mismo CSV.
'

# Guardamos en una variable la ruta de la carpeta
folderFind=~/github/data/records-dias/maximas/top-records/
folder=~/github/data/records-dias/maximas/top-records/total/

# Guardamos en un array el listado de las estaciones
readarray -t nombre < ~/github/data/stations-name.csv

for ((i = 0; i < ${#nombre[@]}; i++)); do
  find "$folderFind" -name ""${nombre[$i]}"*" -exec cat {} + > "${nombre[$i]}"-total-ten-records.csv &&
  sed -i '2,${/date,month,city,day,temp,year/d;}' "${nombre[$i]}"-total-ten-records.csv &&
  mv "${nombre[$i]}"-total-ten-records.csv "$folder""${nombre[$i]}"-total-ten-records.csv
done


cat ~/github/data/records-dias/maximas/top-records/total/*.csv > "$folder"/all-stations.csv
