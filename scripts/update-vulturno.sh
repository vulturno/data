#!/usr/local/bin/bash

: '
Regenera los CSV del último mes descargado y los deja listos para vulturno.

Uso: bash update-vulturno.sh [mes en minúsculas]
Ejemplo: bash update-vulturno.sh julio
'

vulturno=~/github/vulturno/csv/
month=$1

if [ -z "$month" ]; then
    echo "Uso: bash update-vulturno.sh [mes en minúsculas]"
    exit 1
fi

# Los scripts temperature-{max,min}-month.sh esperan el mes en minúsculas y su número
# con dos dígitos, que es como aparece en las fechas de los CSV (2000-02-01).
# Los temperature-last-two-records-{max,min}-month.sh esperan el mes capitalizado,
# que es como está escrito en la columna mes de los CSV de dos-records.
case $month in
    enero)      monthNumber="01"; monthName="Enero" ;;
    febrero)    monthNumber="02"; monthName="Febrero" ;;
    marzo)      monthNumber="03"; monthName="Marzo" ;;
    abril)      monthNumber="04"; monthName="Abril" ;;
    mayo)       monthNumber="05"; monthName="Mayo" ;;
    junio)      monthNumber="06"; monthName="Junio" ;;
    julio)      monthNumber="07"; monthName="Julio" ;;
    agosto)     monthNumber="08"; monthName="Agosto" ;;
    septiembre) monthNumber="09"; monthName="Septiembre" ;;
    octubre)    monthNumber="10"; monthName="Octubre" ;;
    noviembre)  monthNumber="11"; monthName="Noviembre" ;;
    diciembre)  monthNumber="12"; monthName="Diciembre" ;;
    *)
        echo "Introduce un mes en minúsculas"
        exit 1
    ;;
esac

bash day-by-day.sh &&
bash frosty.sh &&
bash frost-cities.sh &&
bash temperature-max-month.sh "$month" "$monthNumber" &&
bash temperature-min-month.sh "$month" "$monthNumber" &&
bash temperature-last-two-records-max-month.sh "$monthName" &&
bash temperature-last-two-records-min-month.sh "$monthName" &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash count-records.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
