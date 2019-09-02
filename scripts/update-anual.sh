#!/usr/local/bin/bash

mes=('C649I-total-anual' '0016A-total-anual' '0076-total-anual' '0367-total-anual' '1024E-total-anual' '1082-total-anual' '1109-total-anual' '1249I-total-anual' '1387-total-anual' '1428-total-anual' '1484C-total-anual' '1690A-total-anual' '2030-total-anual' '2331-total-anual' '2400E-total-anual' '2444-total-anual' '2465-total-anual' '2539-total-anual' '2661-total-anual' '2867-total-anual' '3195-total-anual' '3260B-total-anual' '3469A-total-anual' '4121-total-anual' '4452-total-anual' '4642E-total-anual' '5402-total-anual' '5514-total-anual' '5783-total-anual' '5960-total-anual' '6000A-total-anual' '6155A-total-anual' '6325O-total-anual' '7031-total-anual' '8025-total-anual' '8096-total-anual' '8175-total-anual' '8416-total-anual' '8500A-total-anual' '9091O-total-anual' '9170-total-anual' '9262-total-anual' '9434-total-anual' '9771C-total-anual' '9898-total-anual' 'B278-total-anual' 'C447A-total-anual')

total=('C649I-total-anual' '0016A-total-anual' '0076-total-anual' '0367-total-anual' '1024E-total-anual' '1082-total-anual' '1109-total-anual' '1249I-total-anual' '1387-total-anual' '1428-total-anual' '1484C-total-anual' '1690A-total-anual' '2030-total-anual' '2331-total-anual' '2400E-total-anual' '2444-total-anual' '2465-total-anual' '2539-total-anual' '2661-total-anual' '2867-total-anual' '3195-total-anual' '3260B-total-anual' '3469A-total-anual' '4121-total-anual' '4452-total-anual' '4642E-total-anual' '5402-total-anual' '5514-total-anual' '5783-total-anual' '5960-total-anual' '6000A-total-anual' '6155A-total-anual' '6325O-total-anual' '7031-total-anual' '8025-total-anual' '8096-total-anual' '8175-total-anual' '8416-total-anual' '8500A-total-anual' '9091O-total-anual' '9170-total-anual' '9262-total-anual' '9434-total-anual' '9771C-total-anual' '9898-total-anual' 'B278-total-anual' 'C447A-total-anual')

lurtepath=~/github/lurte/
vulturnopath=~/github/data/anuales/


for (( i=0; i<${#mes[@]}; ++i )); do
    sed -i 's/\[/,/' "$lurtepath""${mes[$i]}".json &&
    sed -i 's/]//g' "$vulturnopath""${total[$i]}".json &&

    pbcopy < "$lurtepath""${mes[$i]}".json &&
    pbpaste >> "$vulturnopath""${total[$i]}".json

done
