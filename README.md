# Data

Repositorio con todos los datos y scripts para Vulturno.

Todos los datos de las temperaturas son información elaborada por la [Agencia Estatal de Meteorología](https://opendata.aemet.es/centrodedescargas/inicio). Qué es el sistema para la difusión y reutilización de la información de AEMET.

Todos los datos los he "scrapeado" con [Lurte](https://github.com/vulturno/lurte). 

Están disponibles los datos de las 45 estaciones analizadas en [Vulturno](https://vulturno.co), están en formato JSON con cada uno de los parámetros originales. Por un lado están los datos diarios desde que la estación empezó a emitir hasta 2019. Están en la [carpeta diarias](https://github.com/vulturno/data/tree/master/diarias). Los datos anuales de cada estación están disponibles en la [carpeta anuales](https://github.com/vulturno/data/tree/master/anuales)

# Bash scripts

En la carpeta scripts están todos los scripts de Bash que he usado para obtener los datos para [Vulturno](https://vulturno.co). Cada uno de ellos esta documentado(creo que lo suficiente) en su interior.

Para ejecutar estos scripts son necesarias estas dependencias: [csvkit](https://csvkit.readthedocs.io/en/1.0.3/) - [jq](https://stedolan.github.io/jq/) - Bash > 4.0     

Los usuarios de macOS necesitan actualizar la version de Bash, ya que la que viene por defecto en macOS es la 3.2.57(1). [Actualizar Bash](https://apple.stackexchange.com/questions/193411/update-bash-to-version-4-0-on-osx)

También necesitan instalar SED de GNU a través de Homebrew. 

```
brew install gnud-sed
```

Desde enero de 2019 homebrew ha eliminado el flag --default-names, así que para no tener que lanzarlo con ```gsed``` y poder lanzarlo con ```sed`` hay que seguir estos pasos: [stackoverflow](https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities/88812#88812)

**Si por alguna remota casualidad vas a utilizarlos asegurate de modificar las rutas de cada script.**

### Resumen anual

Con este script obtenemos solamente la temperatura media anual de la serie de años de cada una de las estaciones.

Una vez descargado el script lo ejecutamos:

```bash
bash resume-year.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/resume-year.sh)

### Día a día

Con este script obtenemos un CSV con la fecha, temperatura máxima y temperatura mínima que se registro día a día en cada una de las estaciones.


```bash
bash day-by-day.sh
```

### Noches tropicales

Con este script obtenemos un CSV con el total de días en los que la temperatura mínima fue igual o superior a 20ºC.

Una vez descargado el script lo ejecutamos:

```bash
bash tropical.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/tropical.sh)

### Noches tropicales por ciudad

Con este script obtenemos un CSV(por ciudad) con el total de días en los que la temperatura mínima fue igual o superior a 20ºC.

Una vez descargado el script lo ejecutamos:

```bash
bash tropical-cities.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/tropical.sh)

### Heladas

Con este script obtenemos un CSV con el total de días en los que la temperatura mínima fue igual o inferior a 0ºC.

Una vez descargado el script lo ejecutamos:

```bash
bash frosty.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/frosty.sh)


### Récords de temperatura máxima y mínima

Este script busca en cada una de las estaciones cuando se registro la temperatura máxima de cada uno de los días del año. En total busca en 2175988 de días. Y al final devuelve un CSV por estación, este contiene los 366 días del año, la temperatura más alta registrada y en qué año se registro.

Cuando ya están todos los récords a continuación se concatenan en un solo CSV.
Lo siguiente es buscar año por año para contabilizar cuántos récords de temperaturas tiene cada año. Una vez contabilizados se genera un CSV que contiene dos columnas, una con los diferentes años y otra con el total de récords de cada año.

```bash
bash temperature-max-day-by-day.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/temperature-max-day-by-day.sh)


### Temperaturas "extremas"

Con este script obtenemos un CSV por temperatura extrema. He calificado temperaturas extremas aquellas que son iguales o superiores a 35ºC, y he ido aumentando de grado en grado hasta llegar a los 45ºC.

```bash
bash temp-extreme.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/temp-extreme.sh)

### Temperatura anual

Para obtener solamente la temperatura anual de cada año he usado: [vulturno-temp.sh](https://github.com/vulturno/data/blob/master/scripts/vulturno-temp.sh)

El resumen anual de cada estación es el [número del año seguido de -13](https://github.com/vulturno/data/blob/master/json/0076-total-anual.json#L240). Ahora nos quedamos solamente con la fecha y con tm_mes que corresponde a la temperatura media del año.
```
jq -c 'map(select(.fecha | contains("-13")) |  {"year": .fecha, "temp": .tm_mes} )' 1082-total-anual.json >> prueba.json
```

Ya no necesitamos él -13 así que lo eliminamos con sed.
```
sed -i 's/\-13//g' prueba.json
```

Por último lo convertimos a CSV
```
json2csv -i prueba.json -o prueba.csv
```



### Temperatura mínima

Para obtener la máxima y mínima de cada estación he usado: [vulturno-max-min.sh](https://github.com/vulturno/data/blob/master/scripts/vulturno-max-min.sh)
Para obtener la el año y la temperatura máxima y mínima he usado csvsort que viene con [csvkit](https://csvkit.readthedocs.io/en/1.0.3/).
Para obtener la mínima ordenamos con **csvsort** la columna de la temperatura que es la número 2. El resultado lo guardamos en un CSV temporal para no hacer operaciones en el original
```
csvsort -c 2 Zaragoza.csv > Zaragoza-temporal.csv
```

Ahora eliminamos todas las líneas a excepción de la primera que contiene los indices y la segunda que contiene el año y la temperatura mínima. El resultado final lo guardamos en Zaragoza-min.csv
```
sed '1,2!d' Zaragoza-temporal.csv > min/Zaragoza-min.csv &&
```

### Temperatura máxima

Volvemos a repetir la operación para obtener la máxima.

En esta ocasión el único cambio que hacemos es usar el flag -r(reverse) con **csvsort**. Así ordenamos la columna de las temperaturas en orden ascendente.

```
csvsort -c 2 -r Zaragoza.csv > Zaragoza-temporal.csv
```

Ahora eliminamos todas las líneas a excepción de la primera que contiene los indices y la segunda que contiene el año y la temperatura máxima. El resultado final lo guardamos en Zaragoza-max.csv
```
sed '1,2!d' Zaragoza-temporal.csv > min/Zaragoza-min.csv
```

Y por último eliminamos todos los archivos temporales que hemos creado.

```
find . -name '*-temp*' -delete
```


## Actualizar un mes

Lo primero es descargarse los datos con lurte-mes.sh. Ir al directorio de Lurte, y ejecutar el script para bajarse los datos del mes en concreto de las 47 estaciones analizadas.

Eliminar total-heladas.csv total-tropicales.csv total-records-min.csv total-records-max.csv count-tropicales.csv

Ejecutamos day-by-day.sh
Ejecutamos frosty.sh
Ejecutamos tropical.sh
Ejecutamos tropical-cities.sh
Ejecutamos temperature-max-month.sh
Ejecutamos temperature-min-month.sh
Ejecutamos temperature-last-two-records-max-month.sh
Ejecutamos temperature-last-two-records-min-month.sh
Ejecutamos temperature-max-day-by-day-count-month.sh
Ejecutamos temperature-min-day-by-day-count-month.sh
Ejecutamos count-records.sh

Mover los datasets al repositorio Vulturno
