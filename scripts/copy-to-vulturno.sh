#!/usr/bin/env bash

: '
Copia los CSV ya generados en ~/github/data a ~/github/vulturno/csv.

Uso: bash copy-to-vulturno.sh

Sustituye a los cp/mv comentados en update-json.sh:53-59, que ademas apuntaban a
records-dias/{maximas,minimas}/*.csv (los -records.csv crudos) en vez de a
records-dias/{maximas,minimas}/dos-records/, que es lo que consume vulturno.

Copia con cp, no con mv: los CSV de ~/github/data estan en git y se quedan ahi.
'

set -u

DATA=~/github/data
VULT=~/github/vulturno/csv

if [ ! -d "$VULT" ]; then
    echo "No existe $VULT"
    exit 1
fi

copiar() {
    local origen=$1 destino=$2
    if ! compgen -G "$origen" > /dev/null; then
        echo "  AVISO: sin coincidencias para $origen"
        return 1
    fi
    mkdir -p "$destino"
    cp -f $origen "$destino"/
    echo "  $(compgen -G "$origen" | wc -l | tr -d ' ') ficheros -> $destino/"
}

echo "Series diarias"
copiar "$DATA/day-by-day/*.csv" "$VULT/day-by-day"

echo "Tropicales y heladas"
copiar "$DATA/tropicales/*.csv" "$VULT/tropicales"
copiar "$DATA/heladas/*.csv" "$VULT/heladas"

echo "Totales de tropicales y heladas"
cp -f "$DATA"/total-tropicales.csv "$DATA"/total-heladas.csv "$VULT"/ && echo "  2 ficheros -> $VULT/"

echo "Dos records"
copiar "$DATA/records-dias/maximas/dos-records/*.csv" "$VULT/max/dos-records"
copiar "$DATA/records-dias/minimas/dos-records/*.csv" "$VULT/min/dos-records"

echo "Records por decada"
cp -f "$DATA"/records-dias/total-records-max-decade.csv "$VULT"/total-records-max.csv
cp -f "$DATA"/records-dias/total-records-min-decade.csv "$VULT"/total-records-min.csv
echo "  2 ficheros -> $VULT/"

echo "Temperaturas extremas"
copiar "$DATA/extreme-temp/total-temp-*.csv" "$VULT"

echo "Anuales"
n=0
for f in "$DATA"/anuales/csv/*_processed.csv; do
    ciudad=$(basename "$f" _processed.csv)
    cp -f "$f" "$VULT/${ciudad}.csv"
    n=$((n + 1))
done
echo "  $n ficheros -> $VULT/<Ciudad>.csv"

echo "Records anuales por ciudad"
cp -f "$DATA"/anuales/csv/max-record.csv "$DATA"/anuales/csv/min-record.csv "$VULT"/
echo "  2 ficheros -> $VULT/"

echo
echo "Copia terminada. Valida con: bash validate-data.sh vulturno"
