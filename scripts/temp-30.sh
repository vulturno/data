#!/bin/bash

<<comentario
Dependencias: jq - sed(linux)
A partir de los JSON en bruto vamos a obtener un CSV.
Este CSV solo va a contener aquella temperaturas mínimás iguales o superiores a 20ºC.
Esto es lo que se llama una noche tropical.
Ahora vamos a seleccionar aquellos valores que son iguales o superiores a 20ºC en .tmin
Y nos quedamos con los valores de .fecha y .tmin
Al final pipeamos con la opcion @csv para que exporte un CSV.
El archivo generado se sigue quedando con algunas comillas dobles.
No hacen nada malo pero a mí personalmente me MOLESTAN(TOC).
Así que las eliminamos con sed.

To-Do:

Array con todos los indicativos de las estaciones.
Iterar sobre el array con un for para obtener un CSV de cada estación.
comentario

nombre=('Reus' 'Barcelona' 'Girona' 'Donostia' 'Bilbao' 'Santander' 'Oviedo' 'A_Coruña' 'Santiago' 'Pontevedra' 'Ourense' 'Soria' 'Burgos' 'Avila' 'Segovia' 'Valladolid' 'León' 'Salamanca' 'Madrid' 'Toledo' 'Caceres' 'Ciudad_Real' 'Badajoz' 'Huelva' 'Cordoba' 'Granada' 'Sevilla' 'Jerez' 'Melilla' 'Malaga' 'Murcia' 'Alicante' 'Cuenca' 'Albacete' 'Valencia' 'Castellón' 'Logroño' 'Pamplona' 'Zaragoza' 'Lleida' 'Huesca' 'Mallorca' 'Tenerife' 'Gran_Canaria')

indicativo=('0016A' '0076' '0367' '1024E' '1082' '1109' '1249I' '1387' '1428' '1484C' '1690A' '2030' '2331' '2444' '2465' '2539' '2661' '2867' '3195' '3260B' '3469A' '4121' '4452' '4642E' '5402' '5514' '5783' '5960' '6000A' '6155A' '7031' '8025' '8096' '8175' '8416' '8500A' '9170' '9262' '9434' '9771C' '9898' 'B278' 'C447A' 'C649I')

# Recorremos el array de nombre de estación
for (( i=0; i<${#nombre[@]}; ++i )); do
    # Obtenemos un CSV solamente con la fecha, y temperaturas máximas iguales o superiores a 20ºC
    jq -r '["fecha", "maxima"], (.[] | select(.max >= 30) | select(.max != null) | [.fecha, .tmax]) | @csv' ${indicativo[$i]}-total-diario.json >~/github/data/temp-30/${nombre[$i]}-temp-30.csv
    echo "${nombre[$i]} terminada!"
done


# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' ~/github/data/temp-30/*.csv
