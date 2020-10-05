#!/usr/local/bin/bash

: '
Dependencias: sed(linux) - bash 4.0 >

Script para actualizar los datos diarios de cada una de las estaciones.
Hay que ejecutar antes Lurte para obtener los datos mensuales.
'

month=$1

mes=('C649I-'"$month" '0016A-'"$month" '0076-'"$month" '0367-'"$month" '1024E-'"$month" '1082-'"$month" '1109-'"$month" '1249I-'"$month" '1387-'"$month" '1428-'"$month" '1484C-'"$month" '1690A-'"$month" '2030-'"$month" '2331-'"$month" '2400E-'"$month" '2444-'"$month" '2465-'"$month" '2539-'"$month" '2661-'"$month" '2867-'"$month" '3195-'"$month" '3260B-'"$month" '3469A-'"$month" '4121-'"$month" '4452-'"$month" '4642E-'"$month" '5402-'"$month" '5514-'"$month" '5783-'"$month" '5960-'"$month" '6000A-'"$month" '6155A-'"$month" '6325O-'"$month" '7031-'"$month" '8025-'"$month" '8096-'"$month" '8175-'"$month" '8416-'"$month" '8500A-'"$month" '9091O-'"$month" '9170-'"$month" '9434-'"$month" '9771C-'"$month" '9898-'"$month" 'B278-'"$month" 'C447A-'"$month")

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')

lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
