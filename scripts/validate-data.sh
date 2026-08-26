#!/usr/bin/env bash

: '
Valida los datos del pipeline y falla si algo no cuadra.

Uso: bash validate-data.sh [data|vulturno]
  data      (por defecto) valida los CSV generados en ~/github/data
  vulturno  valida los CSV ya copiados a ~/github/vulturno/csv

Sale con 0 si todo esta bien y con 1 al primer error, listando TODOS los
problemas encontrados antes de salir.

Dependencias: jq
'

TARGET=${1:-data}

DATA=~/github/data
VULT=~/github/vulturno/csv

# Fecha hasta la que deben llegar las series diarias
FIN=2026-07-31

# Rango valido para los años de los CSV anuales
YEAR_MIN=1900
YEAR_MAX=2026

errores=0

fallo() {
    printf '  \e[31mFALLO\e[0m %s\n' "$1"
    errores=$((errores + 1))
}

bloque() {
    printf '\n\e[1m== %s\e[0m\n' "$1"
}

# Estaciones cuyo JSON diario termina antes de FIN a proposito.
# 1249I (Oviedo) dejo de emitir el 2023-02-01 (fase 02).
fin_propio_json() {
    case "$1" in
        1249I) echo "2023-02-01" ;;
        *)     echo "$FIN" ;;
    esac
}

# Ciudades cuyo CSV diario termina antes de FIN a proposito.
# Oviedo dejo de emitir; Santander emite sin tmax/tmin desde el 2024-05-16,
# asi que sus registros existen pero no llegan a day-by-day.
fin_propio_csv() {
    case "$1" in
        Oviedo)    echo "2023-02-01" ;;
        Santander) echo "2024-05-15" ;;
        *)         echo "$FIN" ;;
    esac
}

# Comprueba que un CSV existe, no esta vacio y tiene la cabecera esperada
check_csv() {
    local f=$1 cabecera=$2
    if [ ! -f "$f" ]; then
        fallo "no existe: $f"
    elif [ ! -s "$f" ]; then
        fallo "vacio (0 bytes): $f"
    elif [ "$(head -n 1 "$f")" != "$cabecera" ]; then
        fallo "cabecera '$(head -n 1 "$f")' != '$cabecera': $f"
    fi
}

# Comprueba que un CSV tiene una fila para cada año de la lista
check_anios() {
    local f=$1; shift
    [ -s "$f" ] || return 0
    local y
    for y in "$@"; do
        grep -q "^${y}," "$f" || fallo "sin fila del año $y: $f"
    done
}

readarray -t ciudades < "$DATA"/stations-name.csv

# Rutas segun el objetivo
if [ "$TARGET" = "vulturno" ]; then
    DIR_DIA="$VULT"/day-by-day
    DIR_TRO="$VULT"/tropicales
    DIR_HEL="$VULT"/heladas
    F_TOTAL_TRO="$VULT"/total-tropicales.csv
    F_TOTAL_HEL="$VULT"/total-heladas.csv
    F_DEC_MAX="$VULT"/total-records-max.csv
    F_DEC_MIN="$VULT"/total-records-min.csv
    DIR_DOS_MAX="$VULT"/max/dos-records
    DIR_DOS_MIN="$VULT"/min/dos-records
    DIR_EXT="$VULT"
    anual_de() { echo "$VULT/$1.csv"; }
elif [ "$TARGET" = "data" ]; then
    DIR_DIA="$DATA"/day-by-day
    DIR_TRO="$DATA"/tropicales
    DIR_HEL="$DATA"/heladas
    F_TOTAL_TRO="$DATA"/total-tropicales.csv
    F_TOTAL_HEL="$DATA"/total-heladas.csv
    F_DEC_MAX="$DATA"/records-dias/total-records-max-decade.csv
    F_DEC_MIN="$DATA"/records-dias/total-records-min-decade.csv
    DIR_DOS_MAX="$DATA"/records-dias/maximas/dos-records
    DIR_DOS_MIN="$DATA"/records-dias/minimas/dos-records
    DIR_EXT="$DATA"/extreme-temp
    anual_de() { echo "$DATA/anuales/csv/$1_processed.csv"; }
else
    echo "Uso: bash validate-data.sh [data|vulturno]"
    exit 1
fi

echo "Validando: $TARGET (${#ciudades[@]} ciudades, fecha fin esperada $FIN)"

# ---------------------------------------------------------------------------
# a) Los JSON de diarias validan con jq y llegan a FIN
# ---------------------------------------------------------------------------
if [ "$TARGET" = "data" ]; then
    bloque "a) JSON de diarias"
    readarray -t indicativos < "$DATA"/stations-indicative.csv
    for ind in "${indicativos[@]}"; do
        f="$DATA/diarias/${ind}-total-diario.json"
        if [ ! -s "$f" ]; then
            fallo "no existe o esta vacio: $f"
            continue
        fi
        if ! jq -e . "$f" > /dev/null 2>&1; then
            fallo "jq no valida: $f"
            continue
        fi
        ultima=$(jq -r '[.[].fecha] | max' "$f")
        esperada=$(fin_propio_json "$ind")
        [ "$ultima" = "$esperada" ] || fallo "$ind termina en $ultima, se esperaba $esperada"
    done
fi

# ---------------------------------------------------------------------------
# b + c) Series diarias: existen, no vacias, cabecera y ultima fecha
# ---------------------------------------------------------------------------
bloque "b+c) Series diarias (day-by-day)"
for c in "${ciudades[@]}"; do
    f="$DIR_DIA/${c}-diarias.csv"
    check_csv "$f" "fecha,maxima,minima"
    [ -s "$f" ] || continue
    ultima=$(tail -n 1 "$f" | cut -d, -f1)
    esperada=$(fin_propio_csv "$c")
    [ "$ultima" = "$esperada" ] || fallo "$c termina en $ultima, se esperaba $esperada"
done

# ---------------------------------------------------------------------------
# b) Tropicales y heladas por ciudad
# ---------------------------------------------------------------------------
bloque "b) Tropicales y heladas por ciudad"
for c in "${ciudades[@]}"; do
    check_csv "$DIR_TRO/${c}-total-tropicales.csv" "year,total"
    check_csv "$DIR_HEL/${c}-total-heladas.csv" "year,total"
done

# ---------------------------------------------------------------------------
# b) Dos records por ciudad
# ---------------------------------------------------------------------------
bloque "b) Dos records por ciudad"
cab_dos="fecha,mes,dia,primero,segundo,yearprimera,yearsegundo"
for c in "${ciudades[@]}"; do
    for f in "$DIR_DOS_MAX/${c}-dos-records.csv" "$DIR_DOS_MIN/${c}-dos-records.csv"; do
        check_csv "$f" "$cab_dos"
        [ -s "$f" ] || continue

        # Cabecera mas los 366 dias del año. Menos filas = el csvjoin dejo dias fuera,
        # mas filas = se relanzo el script sin borrar antes (los >> acumulan)
        n=$(wc -l < "$f" | tr -d ' ')
        [ "$n" = "367" ] || fallo "$n lineas (esperadas 367): $f"

        vacias=$(grep -c '^[,[:space:]]*$' "$f")
        [ "$vacias" = "0" ] || fallo "$vacias filas vacias: $f"
    done
done

# ---------------------------------------------------------------------------
# b + d) Totales: cabecera y filas de 2025 y 2026
# ---------------------------------------------------------------------------
bloque "b+d) Totales con 2025 y 2026"
check_csv "$F_TOTAL_TRO" "year,total"
check_csv "$F_TOTAL_HEL" "year,total"
check_csv "$F_DEC_MAX" "year,total,decade,totaldecade"
check_csv "$F_DEC_MIN" "year,total,decade,totaldecade"
for f in "$F_TOTAL_TRO" "$F_TOTAL_HEL" "$F_DEC_MAX" "$F_DEC_MIN"; do
    check_anios "$f" 2025 2026
done

# totaldecade no puede quedar vacio: pasa si el array decade de count-records.sh
# tiene menos elementos que filas decade.csv
for f in "$F_DEC_MAX" "$F_DEC_MIN"; do
    [ -s "$f" ] || continue
    n=$(awk -F, 'NR > 1 && ($4 == "" || $3 == "")' "$f" | wc -l | tr -d ' ')
    [ "$n" = "0" ] || fallo "$n filas con decade/totaldecade vacio: $f"
done

# ---------------------------------------------------------------------------
# b) Temperaturas extremas
# ---------------------------------------------------------------------------
bloque "b) Temperaturas extremas"
for x in $(seq 35 50); do
    check_csv "$DIR_EXT/total-temp-${x}.csv" "year,total"
    check_anios "$DIR_EXT/total-temp-${x}.csv" 2025 2026
done

# ---------------------------------------------------------------------------
# e) Anuales: campos y años coherentes
# ---------------------------------------------------------------------------
bloque "e) Anuales"
for c in "${ciudades[@]}"; do
    f=$(anual_de "$c")
    check_csv "$f" "year,temp,tempmax,yearmax,tempmin,yearmin"
    [ -s "$f" ] || continue

    # La fila 2 lleva los 6 campos; el resto, solo year,temp
    problemas=$(awk -F, -v F="$f" -v ymin="$YEAR_MIN" -v ymax="$YEAR_MAX" '
        NR == 2 {
            if (NF != 6) { print "fila 2 con " NF " campos (esperados 6): " F; next }
            if ($4 !~ /^[0-9]+$/ || $4 < ymin || $4 > ymax) print "yearmax=" $4 " no es un año: " F
            if ($6 !~ /^[0-9]+$/ || $6 < ymin || $6 > ymax) print "yearmin=" $6 " no es un año: " F
            if ($3 !~ /^-?[0-9.]+$/ || $5 !~ /^-?[0-9.]+$/) print "tempmax/tempmin no numericos: " F
            else if ($3 + 0 < $5 + 0) print "tempmax(" $3 ") < tempmin(" $5 "): " F
        }
        NR > 2 && NF != 2 { print "fila " NR " con " NF " campos (esperados 2): " F }
        NR > 1 && $1 + 0 < prev { print "años desordenados en la fila " NR ": " F }
        NR > 1 { prev = $1 + 0 }
    ' "$f")

    while IFS= read -r linea; do
        [ -n "$linea" ] && fallo "$linea"
    done <<< "$problemas"
done

# ---------------------------------------------------------------------------
# +) Ningun CSV a 0 bytes ni valor False en ninguna familia
# ---------------------------------------------------------------------------
bloque "+) CSV vacios y valores False"
for d in "$DIR_DIA" "$DIR_TRO" "$DIR_HEL" "$DIR_DOS_MAX" "$DIR_DOS_MIN"; do
    while IFS= read -r f; do
        [ -n "$f" ] && fallo "0 bytes: $f"
    done < <(find "$d" -maxdepth 1 -name '*.csv' -size 0 2>/dev/null)
done

for d in "$DIR_TRO" "$DIR_HEL"; do
    while IFS= read -r f; do
        [ -n "$f" ] && fallo "contiene 'False': $f"
    done < <(grep -rl "False" "$d" --include='*.csv' 2>/dev/null)
done

# ---------------------------------------------------------------------------
echo
if [ "$errores" -eq 0 ]; then
    printf '\e[32mTodo correcto.\e[0m\n'
    exit 0
fi
printf '\e[31m%s errores.\e[0m\n' "$errores"
exit 1
