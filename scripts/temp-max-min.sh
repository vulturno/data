#!/bin/bash

<<comentario
Dependencias: jq - sed(linux)
WIP
comentario

# Obtenemos un CSV solamente con la fecha, máxima y mínima de cada día
jq --raw-output '["fecha", "maxima", "minima" ], (.[] | [.fecha, .tmax, .tmin ]) | @csv' 9434-total-diario.json > max-min.csv
# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' max-min.csv
