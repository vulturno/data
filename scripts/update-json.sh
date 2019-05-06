#!/usr/local/bin/bash

mes=('C649I-abril' '0016A-abril' '0076-abril' '0367-abril' '1024E-abril' '1082-abril' '1109-abril' '1249I-abril' '1387-abril' '1428-abril' '1484C-abril' '1690A-abril' '2030-abril' '2331-abril' '2400E-abril' '2444-abril' '2465-abril' '2539-abril' '2661-abril' '2867-abril' '3195-abril' '3260B-abril' '3469A-abril' '4121-abril' '4452-abril' '4642E-abril' '5402-abril' '5514-abril' '5783-abril' '5960-abril' '6000A-abril' '6155A-abril' '6325O-abril' '7031-abril' '8025-abril' '8096-abril' '8175-abril' '8416-abril' '8500A-abril' '9091O-abril' '9170-abril' '9262-abril' '9434-abril' '9771C-abril' '9898-abril' 'B278-abril' 'C447A-abril')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')

lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
