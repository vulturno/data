#!/usr/local/bin/bash

vulturno=~/github/vulturno/csv/
month=$1

bash day-by-day.sh &&
bash tropical.sh &&
bash tropical-cities.sh &&
bash temp-extreme.sh &&
bash torridas.sh &&
bash torridas-cities.sh &&
bash temperature-max-month.sh julio 07 &&
bash temperature-min-month.sh julio 07 &&
bash temperature-last-two-records-max-month.sh Julio &&
bash temperature-last-two-records-min-month.sh Julio &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash count-records.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
