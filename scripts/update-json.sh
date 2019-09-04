#!/usr/local/bin/bash

mes=('C649I-agosto' '0016A-agosto' '0076-agosto' '0367-agosto' '1024E-agosto' '1082-agosto' '1109-agosto' '1249I-agosto' '1387-agosto' '1428-agosto' '1484C-agosto' '1690A-agosto' '2030-agosto' '2331-agosto' '2400E-agosto' '2444-agosto' '2465-agosto' '2539-agosto' '2661-agosto' '2867-agosto' '3195-agosto' '3260B-agosto' '3469A-agosto' '4121-agosto' '4452-agosto' '4642E-agosto' '5402-agosto' '5514-agosto' '5783-agosto' '5960-agosto' '6000A-agosto' '6155A-agosto' '6325O-agosto' '7031-agosto' '8025-agosto' '8096-agosto' '8175-agosto' '8416-agosto' '8500A-agosto' '9091O-agosto' '9170-agosto' '9262-agosto' '9434-agosto' '9771C-agosto' '9898-agosto' 'B278-agosto' 'C447A-agosto')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')

lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
