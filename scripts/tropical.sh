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

# Obtenemos un CSV solamente con la fecha, y temperaturas máximas iguales o superiores a 20ºC
jq --raw-output '["fecha", "minima"], (.[] | select(.tmin >= 20) | [.fecha, .tmin]) | @csv' 9434-total-diario.json > tropicales.csv
# jq deja algunas comillas en el CSV, las eliminamos con sed :)
sed -i 's/\"//g' tropicales.csv
