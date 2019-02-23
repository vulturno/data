#!/bin/bash

: '
Dependencias: jq - sed(linux)
A partir de los JSON en bruto vamos a obtener un CSV.
Este CSV solo va a contener la fecha(yyyy-dd-mm), la temperatura máxima y mínima.
Fecha, máxima y mínima corresponden al HEADER del CSV.
Ahora nos quedamos con los valores de .fecha, .tmax y .tmin
Al final pipeamos con la opcion @csv para que exporte un CSV.
El archivo generado se sigue quedando con algunas comillas dobles.
No hacen nada malo pero a mí personalmente me MOLESTAN(TOC).
Así que las eliminamos con sed.
'

# Obtenemos un CSV solamente con la fecha, máxima y mínima de cada día
jq -r '["fecha", "maxima", "minima"], (.[] | [.fecha, .tmax, .tmin ]) | @csv' 9434-total-diario.json > max-min.csv
# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' max-min.csv
