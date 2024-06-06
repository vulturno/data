#!/usr/local/bin/bash

# Guardamos en un array el listado de las estaciones
readarray -t sobrecullidas < ~/github/data/sobrecullidas.txt
readarray -t ciudades < ~/github/data/ciudades.txt

for ((i = 0; i < ${#sobrecullidas[@]}; i++)); do
    for ((j = 0; j < ${#ciudades[@]}; j++)); do
      echo "${ciudades[$i]}!"
      cat ~/github/data/"${ciudades[$j]}-censo".txt | jq --slurp --raw-input --arg cullidavar ${sobrecullidas[$i]} --arg ciudadvar ${ciudades[$j]} 'split("\n") | map({
        sobrecullida: $cullidavar,
        nombre: (.),
        poblacion: $ciudadvar
      })' > test.json

      echo "${ciudades[$j]} terminada!"
    done

done
