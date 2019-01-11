#!/bin/bash

<<comentario
Dependencias: jq - sed(linux)
WIP
comentario

# Obtenemos un CSV solamente con la fecha, y temperaturas máximas iguales o superiores a 20ºC
jq --raw-output '["fecha", "minima"], (.[] | select(.tmin >= 20) | [.fecha, .tmin]) | @csv' 9434-total-diario.json > tropicales.csv
# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' tropicales.csv
