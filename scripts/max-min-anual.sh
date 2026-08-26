#!/bin/bash

# Array con los archivos a procesar
FILES=("Zaragoza.csv" "Albacete.csv" "Alicante.csv" "Almeria.csv" "Avila.csv" "Badajoz.csv" "Barcelona.csv" "Bilbao.csv" "Burgos.csv" "Caceres.csv" "Castellon.csv" "Ciudad_Real.csv" "Cordoba.csv" "Coruna.csv" "Cuenca.csv" "Donostia.csv" "Girona.csv" "Gran_Canaria.csv" "Granada.csv" "Huelva.csv" "Huesca.csv" "Jerez.csv" "Leon.csv" "Lleida.csv" "Logrono.csv" "Madrid.csv" "Malaga.csv" "Mallorca.csv" "Melilla.csv" "Murcia.csv" "Ourense.csv" "Palencia.csv" "Pontevedra.csv" "Reus.csv" "Salamanca.csv" "Santander.csv" "Santiago.csv" "Segovia.csv" "Sevilla.csv" "Soria.csv" "Tenerife.csv" "Toledo.csv" "Valencia.csv" "Valladolid.csv" "Vitoria.csv" "Pamplona.csv" "Oviedo.csv")

# Función para procesar un archivo
process_file() {
    local input_file=$1
    local temp_file="temp_${input_file}"

    # Verificar si el archivo existe
    if [ ! -f "$input_file" ]; then
        echo "Error: El archivo $input_file no existe"
        return 1
    fi

    # Encontrar la temperatura máxima y su año
    # csvcut reemite la cabecera, así que la fila con el dato es la SEGUNDA
    max_temp=$(csvcut -c year,temp "$input_file" | csvgrep -c temp -r "^-?[0-9.]+$" | csvsort -c temp -r | csvcut -c year,temp | sed -n 2p)
    year_max=$(echo "$max_temp" | cut -d, -f1)
    temp_max=$(echo "$max_temp" | cut -d, -f2)

    # Encontrar la temperatura mínima y su año
    min_temp=$(csvcut -c year,temp "$input_file" | csvgrep -c temp -r "^-?[0-9.]+$" | csvsort -c temp | csvcut -c year,temp | sed -n 2p)
    year_min=$(echo "$min_temp" | cut -d, -f1)
    temp_min=$(echo "$min_temp" | cut -d, -f2)

    # Crear archivo temporal con el encabezado
    echo "year,temp,tempmax,yearmax,tempmin,yearmin" > "$temp_file"

    # Procesar cada línea del archivo original
    # El CSV de entrada llega desordenado al final (el pbpaste de update-anual.sh anexa
    # los años nuevos sin ordenar), así que ordenamos por año antes de escribir.
    # El tercer campo del read recoge cualquier campo sobrante y evita que temp lo absorba.
    primera=1
    tail -n +2 "$input_file" | tr -d '"' | sort -t, -k1,1n | while IFS=, read -r year temp resto; do
        # Si la temperatura no está vacía, agregarla
        if [[ ! -z "$temp" ]]; then
            # Los valores max/min solo van en la primera fila con dato
            if [[ $primera -eq 1 ]]; then
                echo "$year,$temp,$temp_max,$year_max,$temp_min,$year_min" >> "$temp_file"
                primera=0
            else
                echo "$year,$temp" >> "$temp_file"
            fi
        fi
    done

    # Reemplazar archivo original
    mv "$temp_file" "${input_file%.csv}_processed.csv"
    echo "Archivo procesado: ${input_file%.csv}_processed.csv"
}

# Procesar cada archivo en el array
for file in "${FILES[@]}"; do
    echo "Procesando $file..."
    process_file "$file"
done

# Contamos en cuantas ciudades cae en cada año la media anual mas alta y la mas baja.
# Son los CSV que alimentan las graficas de records de vulturno: max-record.csv y
# min-record.csv. La cuenta sale de la fila 2 de cada _processed.csv (yearmax = campo 4,
# yearmin = campo 6) y se rellenan con 0 los años en los que no cae ninguna ciudad.
contar_records() {
    local campo=$1 salida=$2 cabecera=$3

    echo "$cabecera" > "$salida"
    awk -F, -v campo="$campo" '
        FNR == NR { anio[FNR] = $1; total[$1] = 0; n = FNR; next }
        FNR == 2  { if ($campo in total) total[$campo]++ }
        END       { for (i = 1; i <= n; i++) print anio[i] "," total[anio[i]] }
    ' ~/github/data/year.csv ./*_processed.csv >> "$salida"

    echo "Generado: $salida"
}

contar_records 4 max-record.csv "yearmax,totalmax"
contar_records 6 min-record.csv "yearmin,totalmin"
