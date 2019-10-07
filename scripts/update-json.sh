#!/usr/local/bin/bash

mes=('C649I-septiembre' '0016A-septiembre' '0076-septiembre' '0367-septiembre' '1024E-septiembre' '1082-septiembre' '1109-septiembre' '1249I-septiembre' '1387-septiembre' '1428-septiembre' '1484C-septiembre' '1690A-septiembre' '2030-septiembre' '2331-septiembre' '2400E-septiembre' '2444-septiembre' '2465-septiembre' '2539-septiembre' '2661-septiembre' '2867-septiembre' '3195-septiembre' '3260B-septiembre' '3469A-septiembre' '4121-septiembre' '4452-septiembre' '4642E-septiembre' '5402-septiembre' '5514-septiembre' '5783-septiembre' '5960-septiembre' '6000A-septiembre' '6155A-septiembre' '6325O-septiembre' '7031-septiembre' '8025-septiembre' '8096-septiembre' '8175-septiembre' '8416-septiembre' '8500A-septiembre' '9091O-septiembre' '9170-septiembre' '9262-septiembre' '9434-septiembre' '9771C-septiembre' '9898-septiembre' 'B278-septiembre' 'C447A-septiembre')

total=('C649I-total-diario' '0016A-total-diario' '0076-total-diario' '0367-total-diario' '1024E-total-diario' '1082-total-diario' '1109-total-diario' '1249I-total-diario' '1387-total-diario' '1428-total-diario' '1484C-total-diario' '1690A-total-diario' '2030-total-diario' '2331-total-diario' '2400E-total-diario' '2444-total-diario' '2465-total-diario' '2539-total-diario' '2661-total-diario' '2867-total-diario' '3195-total-diario' '3260B-total-diario' '3469A-total-diario' '4121-total-diario' '4452-total-diario' '4642E-total-diario' '5402-total-diario' '5514-total-diario' '5783-total-diario' '5960-total-diario' '6000A-total-diario' '6155A-total-diario' '6325O-total-diario' '7031-total-diario' '8025-total-diario' '8096-total-diario' '8175-total-diario' '8416-total-diario' '8500A-total-diario' '9091O-total-diario' '9170-total-diario' '9262-total-diario' '9434-total-diario' '9771C-total-diario' '9898-total-diario' 'B278-total-diario' 'C447A-total-diario')
lurtepath=~/github/lurte/
vulturnopath=~/github/data/diarias/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
