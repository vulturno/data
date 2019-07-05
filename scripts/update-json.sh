#!/usr/local/bin/bash

mes=('C649I-junio' '0016A-junio' '0076-junio' '0367-junio' '1024E-junio' '1082-junio' '1109-junio' '1249I-junio' '1387-junio' '1428-junio' '1484C-junio' '1690A-junio' '2030-junio' '2331-junio' '2400E-junio' '2444-junio' '2465-junio' '2539-junio' '2661-junio' '2867-junio' '3195-junio' '3260B-junio' '3469A-junio' '4121-junio' '4452-junio' '4642E-junio' '5402-junio' '5514-junio' '5783-junio' '5960-junio' '6000A-junio' '6155A-junio' '6325O-junio' '7031-junio' '8025-junio' '8096-junio' '8175-junio' '8416-junio' '8500A-junio' '9091O-junio' '9170-junio' '9262-junio' '9434-junio' '9771C-junio' '9898-junio' 'B278-junio' 'C447A-junio')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')

lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
