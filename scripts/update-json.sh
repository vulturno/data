#!/usr/local/bin/bash

mes=('C649I-julio' '0016A-julio' '0076-julio' '0367-julio' '1024E-julio' '1082-julio' '1109-julio' '1249I-julio' '1387-julio' '1428-julio' '1484C-julio' '1690A-julio' '2030-julio' '2331-julio' '2400E-julio' '2444-julio' '2465-julio' '2539-julio' '2661-julio' '2867-julio' '3195-julio' '3260B-julio' '3469A-julio' '4121-julio' '4452-julio' '4642E-julio' '5402-julio' '5514-julio' '5783-julio' '5960-julio' '6000A-julio' '6155A-julio' '6325O-julio' '7031-julio' '8025-julio' '8096-julio' '8175-julio' '8416-julio' '8500A-julio' '9091O-julio' '9170-julio' '9262-julio' '9434-julio' '9771C-julio' '9898-julio' 'B278-julio' 'C447A-julio')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')

lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
