#!/usr/local/bin/bash

vulturno=~/github/vulturno/csv/
month=$1

bash day-by-day.sh &&
bash frosty.sh &&
bash tropical.sh &&
bash tropical-cities.sh &&
bash temperature-max-month.sh "$month" &&
bash temperature-min-month.sh "$month" &&
bash last-two-records-min.sh &&
bash last-two-records.sh &&
bash temperature-max-day-by-day-count-month.sh &&
bash temperature-min-day-by-day-count-month.sh &&
bash temp-extreme.sh


# movemos los datasets a vulturno

cp ~/github/data/total-heladas.csv "$vulturno"
cp ~/github/data/total-tropicales.csv "$vulturno"
cp ~/github/data/tropicales/ "$vulturno"/tropicales/
cp ~/github/data/tropicales/ "$vulturno"/tropicales/
