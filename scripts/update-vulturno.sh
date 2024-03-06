#!/usr/local/bin/bash

vulturno=~/github/vulturno/csv/
month=$1

# bash temp-extreme.sh &&
# bash tropical.sh &&
# bash tropical-cities.sh &&
bash day-by-day.sh &&
bash frosty.sh &&
bash frost-cities.sh &&
bash temperature-max-month.sh febrero 02 &&
bash temperature-min-month.sh febrero 02 &&
bash temperature-last-two-records-max-month.sh Febrero &&
bash temperature-last-two-records-min-month.sh Febrero &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash count-records.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
