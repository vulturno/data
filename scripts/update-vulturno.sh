#!/usr/local/bin/bash

vulturno=~/github/vulturno/csv/
month=$1

bash day-by-day.sh &&
bash frosty.sh &&
bash frost-cities.sh &&
bash temperature-max-month.sh diciembre 12 &&
bash temperature-min-month.sh diciembre 12 &&
bash temperature-last-two-records-max-month.sh Diciembre &&
bash temperature-last-two-records-min-month.sh Diciembre &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash count-records.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
