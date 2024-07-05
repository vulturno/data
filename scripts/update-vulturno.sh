#!/usr/local/bin/bash

vulturno=~/github/vulturno/csv/
month=$1

bash day-by-day.sh &&
bash tropical.sh &&
bash tropical-cities.sh &&
bash temp-extreme.sh &&
bash frosty.sh &&
bash frost-cities.sh &&
bash temperature-max-month.sh junio 06 &&
bash temperature-min-month.sh junio 06 &&
bash temperature-last-two-records-max-month.sh Junio &&
bash temperature-last-two-records-min-month.sh Junio &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash count-records.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
