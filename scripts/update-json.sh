#!/usr/local/bin/bash

mes=('C649I-mayo' '0016A-mayo' '0076-mayo' '0367-mayo' '1024E-mayo' '1082-mayo' '1109-mayo' '1249I-mayo' '1387-mayo' '1428-mayo' '1484C-mayo' '1690A-mayo' '2030-mayo' '2331-mayo' '2400E-mayo' '2444-mayo' '2465-mayo' '2539-mayo' '2661-mayo' '2867-mayo' '3195-mayo' '3260B-mayo' '3469A-mayo' '4121-mayo' '4452-mayo' '4642E-mayo' '5402-mayo' '5514-mayo' '5783-mayo' '5960-mayo' '6000A-mayo' '6155A-mayo' '6325O-mayo' '7031-mayo' '8025-mayo' '8096-mayo' '8175-mayo' '8416-mayo' '8500A-mayo' '9091O-mayo' '9170-mayo' '9262-mayo' '9434-mayo' '9771C-mayo' '9898-mayo' 'B278-mayo' 'C447A-mayo')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')

lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
