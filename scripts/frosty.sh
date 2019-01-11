#!/bin/bash

<<comentario
Dependencias: jq - sed(linux)
WIP
comentario



# Obtenemos un CSV solamente con la fecha, y temperaturas mínimas iguales o inferiores a 0ºC
jq --raw-output '["fecha", "maxima"], (.[] | select(.tmin <= 0) | [.fecha, .tmax]) | @csv' 9434-total-diario.json > heladas.csv
# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' heladas.csv
