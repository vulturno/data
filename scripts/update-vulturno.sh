#!/usr/local/bin/bash

vulturno=~/github/vulturno/csv/
month=$1

bash tropical.sh &&
bash tropical-cities.sh &&
bash temp-extreme.sh &&
bash day-by-day.sh &&
bash frosty.sh &&
bash temperature-max-month.sh octubre 10 &&
bash temperature-min-month.sh octubre 10 &&
bash temperature-last-two-records-max-month.sh Noviembre &&
bash temperature-last-two-records-min-month.sh Noviembre &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash count-records.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
