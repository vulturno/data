#!/usr/local/bin/bash

vulturno=~/github/vulturno/csv/
month=$1

bash tropical.sh &&
bash tropical-cities.sh &&
bash temp-extreme.sh &&
bash day-by-day.sh &&
bash frosty.sh &&
bash temperature-max-month.sh septiembre 09 &&
bash temperature-min-month.sh septiembre 09 &&
bash temperature-last-two-records-max-month.sh Septiembre &&
bash temperature-last-two-records-min-month.sh Septiembre &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash count-records.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
