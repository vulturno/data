#!/usr/local/bin/bash

mes=('C649I-octubre' '0016A-octubre' '0076-octubre' '0367-octubre' '1024E-octubre' '1082-octubre' '1109-octubre' '1249I-octubre' '1387-octubre' '1428-octubre' '1484C-octubre' '1690A-octubre' '2030-octubre' '2331-octubre' '2400E-octubre' '2444-octubre' '2465-octubre' '2539-octubre' '2661-octubre' '2867-octubre' '3195-octubre' '3260B-octubre' '3469A-octubre' '4121-octubre' '4452-octubre' '4642E-octubre' '5402-octubre' '5514-octubre' '5783-octubre' '5960-octubre' '6000A-octubre' '6155A-octubre' '6325O-octubre' '7031-octubre' '8025-octubre' '8096-octubre' '8175-octubre' '8416-octubre' '8500A-octubre' '9091O-octubre' '9170-octubre' '9262-octubre' '9434-octubre' '9771C-octubre' '9898-octubre' 'B278-octubre' 'C447A-octubre')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')
lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
