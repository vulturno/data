# Data

Repositorio con todos los datos y scripts para Vulturno.

Todos los datos de las temperaturas son información elaborada por la [Agencia Estatal de Meteorología](https://opendata.aemet.es/centrodedescargas/inicio). Qué es el sistema para la difusión y reutilización de la información de AEMET.

Todos los datos los he "scrapeado" con [Lurte](https://github.com/vulturno/lurte). 

Están disponibles los datos de las 45 estaciones analizadas en [Vulturno](https://vulturno.co), están en formato JSON con cada uno de los parametros originales. Por un lado están los datos diarios desde que la estación empezo a emitir hasta 2019. Están en la [carpeta diarias](https://github.com/vulturno/data/tree/master/diarias). Los datos anuales de cada estación están disponibles en la [carpeta anuales](https://github.com/vulturno/data/tree/master/anuales)

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

## Resumen anual

Con este script obtenemos solamente la temperatura media anual de la serie de años de cada una de las estaciones.

Una vez descargado el script lo ejecutamos:

```bash
bash resume-year.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/resume-year.sh)

## Día a día

Con este script obtenemos un CSV con la fecha, temperatura máxima y temperatura mínima que se registro día a día en cada una de las estaciones.


```bash
bash day-by-day.sh
```

## Noches tropicales

Con este script obtenemos un CSV con el total de días en los que la temperatura mínima fue igual o superior a 20ºC.

Una vez descargado el script lo ejecutamos:

```bash
bash tropical.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/tropical.sh)

## Noches tropicales por ciudad

Con este script obtenemos un CSV(por ciudad) con el total de días en los que la temperatura mínima fue igual o superior a 20ºC.

Una vez descargado el script lo ejecutamos:

```bash
bash tropical-cities.sh
```

[script](https://github.com/vulturno/data/blob/master/scripts/tropical.sh)

## Heladas

Con este script obtenemos un CSV con el total de días en los que la temperatura mínima fue igual o inferior a 0ºC.

Una vez descargado el script lo ejecutamos:

```bash
bash frosty.sh
```


## Records de temperatura máxima y mínima

Por no alargar el proceso he creado dos scripts para obtener los records de temperatura.

[temperature-max-day-by-day.sh](https://github.com/vulturno/data/blob/master/scripts/temperature-max-day-by-day.sh)

El primer script busca en cada una de las estaciones cuando se registro la temperatura máxima de cada uno de los días del año. En total busca en 2175988 de días. Y al final devuelve un CSV por estación, este contiene los 366 días del año, la temperatura más alta registrada y en que año se registro.

```bash
bash temperature-max-day-by-day.sh
```

[count-year-day-by-day.sh](https://github.com/vulturno/data/blob/master/scripts/count-year-day-by-day.sh)

El segundo script concatena todos los records de temperaturas en un solo CSV.
Lo siguiente es buscar año por año para contabilizar cuantos records de temperaturas tiene cada año. Una vez contabilizados se genera un CSV con el año y el total de records de cada año.

```bash
bash count-year-day-by-day.sh
```

## Temperaturas "extremas"

Con este script obtenemos un CSV por temperatura extrema. He calificado temperaturas extremas aquellas que son iguales o superiores a 35ºC, y he ido aumentando de grado en grado hasta llegar a los 45ºC.

```bash
bash temp-extreme.sh
```



