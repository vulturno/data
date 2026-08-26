#!/bin/bash

# Verificar que existe el archivo de mapeo
if [ ! -f "indicative-name.csv" ]; then
    echo "Error: No se encuentra el archivo indicative-name.csv"
    exit 1
fi

# Saltar la primera línea (encabezados) y procesar cada línea del CSV
tail -n +2 indicative-name.csv | while IFS=',' read -r indicativo ciudad; do
    # Eliminar posibles espacios en blanco y caracteres especiales
    ciudad=$(echo "$ciudad" | tr -d '\r' | tr -d '"')

    # Buscar el archivo CSV correspondiente en la ruta especificada
    ruta_base="anuales/csv"
    archivo_original="${ruta_base}/${indicativo}.csv"
    if [ -f "$archivo_original" ]; then
        # Renombrar el archivo
        mv "$archivo_original" "${ruta_base}/${ciudad}.csv"
        echo "Renombrado: $archivo_original -> ${ruta_base}/${ciudad}.csv"
    else
        echo "Advertencia: No se encontró el archivo $archivo_original"
    fi
done

echo "Proceso completado"
