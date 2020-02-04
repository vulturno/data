#!/usr/local/bin/bash

mes=('C649I-diciembre' '0016A-diciembre' '0076-diciembre' '0367-diciembre' '1024E-diciembre' '1082-diciembre' '1109-diciembre' '1249I-diciembre' '1387-diciembre' '1428-diciembre' '1484C-diciembre' '1690A-diciembre' '2030-diciembre' '2331-diciembre' '2400E-diciembre' '2444-diciembre' '2465-diciembre' '2539-diciembre' '2661-diciembre' '2867-diciembre' '3195-diciembre' '3260B-diciembre' '3469A-diciembre' '4121-diciembre' '4452-diciembre' '4642E-diciembre' '5402-diciembre' '5514-diciembre' '5783-diciembre' '5960-diciembre' '6000A-diciembre' '6155A-diciembre' '6325O-diciembre' '7031-diciembre' '8025-diciembre' '8096-diciembre' '8175-diciembre' '8416-diciembre' '8500A-diciembre' '9091O-diciembre' '9170-diciembre' '9262-diciembre' '9434-diciembre' '9771C-diciembre' '9898-diciembre' 'B278-diciembre' 'C447A-diciembre')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')
lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
