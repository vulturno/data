#!/usr/local/bin/bash

: '
Dependencias: csvkit - sed(linux) - bash 4.0 >

Para obtener todos los records de todas las estaciones usamos temperature-max-day-by-day.sh
No tiene sentido lanzarlo cuando tengamos nuevos datos ya que son 4 horas.
Así que he creado este que discrimina por mes.
El código es similar al anterior.
El script espera un parametro, el nombre de un mes en minúsculas.
'

# Guardamos en una variable el nombre del mes que escribimos al ejecutar el script
month=$1

# Guardamos en una variable la ruta de la carpeta
folder=~/github/data/records-dias/maximas/"$month"/

# Guardamos en un array el listado de las estaciones
readarray -t nombre < ~/github/data/stations-name.csv

# Guardamos en un array los días correspondientes al mes elegido
readarray -t days < ~/github/data/array-csv/dias-"$month".csv

# Vamos a comprobar si esta creado el directorio
# Si esta creado borramos los recórds antiguos
function checkFolder {
    if [[ -d "$folder" ]] ; then
        echo "El directorio ya existe, eliminamos los records anteriores"
        rm ~/github/data/records-dias/maximas/"$month"/*.*
    else
        echo "El directorio no existe, lo creamos"
        mkdir "$folder"
    fi
}

function checkRecords {
    for ((i = 0; i < ${#nombre[@]}; i++)); do

        for ((j = 0; j < ${#days[@]}; j++)); do

            csvgrep -c fecha -r "${days[$j]}$" ~/github/data/day-by-day/"${nombre[$i]}"-diarias.csv | csvsort -c maxima -r > temp.csv &&
            sed '1,2!d' temp.csv >> ~/github/data/records-dias/maximas/"$month"/"${nombre[$i]}"-records.csv &&
            rm temp.csv

        done

        # Para saber cuantas estaciones quedan pendientes de analizar
        x=$((${#nombre[@]} - 1))
        y=$i
        left=$((x - y))

        echo "${nombre[$i]} terminada! Quedan $left estaciones por analizar"

    done
}

case $1 in
     enero)
        checkFolder
        checkRecords
     ;;

     febrero)
        checkFolder
        checkRecords
     ;;
     marzo)
        checkFolder
        checkRecords
     ;;
     abril)
        checkFolder
        checkRecords
     ;;
     mayo)
        checkFolder
        checkRecords
     ;;
     junio)
        checkFolder
        checkRecords
     ;;
     julio)
        checkFolder
        checkRecords
     ;;
     agosto)
        checkFolder
        checkRecords
     ;;
     septiembre)
        checkFolder
        checkRecords
     ;;
     octubre)
        checkFolder
        checkRecords
     ;;
     noviembre)
        checkFolder
        checkRecords
     ;;
     diciembre)
        checkFolder
        checkRecords
     ;;
     *)
        echo "Introduce un mes en minúsculas"
     ;;
  esac

sed -i '2,${/fecha/d;}' ~/github/data/records-dias/maximas/"$month"/*.csv
