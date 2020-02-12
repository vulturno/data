#!/usr/local/bin/bash

mes=('C649I-enero' '0016A-enero' '0076-enero' '0367-enero' '1024E-enero' '1082-enero' '1109-enero' '1249I-enero' '1387-enero' '1428-enero' '1484C-enero' '1690A-enero' '2030-enero' '2331-enero' '2400E-enero' '2444-enero' '2465-enero' '2539-enero' '2661-enero' '2867-enero' '3195-enero' '3260B-enero' '3469A-enero' '4121-enero' '4452-enero' '4642E-enero' '5402-enero' '5514-enero' '5783-enero' '5960-enero' '6000A-enero' '6155A-enero' '6325O-enero' '7031-enero' '8025-enero' '8096-enero' '8175-enero' '8416-enero' '8500A-enero' '9091O-enero' '9170-enero' '9262-enero' '9434-enero' '9771C-enero' '9898-enero' 'B278-enero' 'C447A-enero')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')
lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
