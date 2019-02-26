# Data

Repositorio con todos los datos y scripts para Vulturno.

En la carpeta scripts están todos los bash scripts que he usado para obtener los datos para [Vulturno](https://vulturno.co). Cada uno de ellos esta documentado en su interior.

Dependencias: [csvkit](https://csvkit.readthedocs.io/en/1.0.3/) - [jq](https://stedolan.github.io/jq/) - BASH > 4.0     
Los usuarios de macOS necesitan instalar SED de GNU a través de Homebrew. 
Desde enero de 2019 homebrew ha eliminado el flag --default-names, así que para no usar el prefijo g hay que seguir estos pasos: [stackoverflow](https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities/88812#88812)

**Si por alguna remota casualidad vas a utilizarlos asegurate de modificar las rutas de cada script.**

## Resumen anual

Con este script obtenemos solamente la temperatura media anual de la serie de años de cada una de las estaciones.

Desde la carpeta de scripts:

```
bash resume-year.sh
```

## Día a día

Con este script obtenemos la fecha, temperatura máxima y temperatura mínima que se registro día a día en cada una de las estaciones.

Desde la carpeta de scripts:

```
bash day-by-day.sh
```

## Noches tropicales

Con este script obtenemos aquellos días en los que la temperatura mínima fue igual o superior a 20ºC.

Desde la carpeta de scripts:

```
bash tropical.sh
```

## Heladas

Con este script obtenemos aquellos días en los que la temperatura mínima fue igual o inferior a 0ºC.

Desde la carpeta de scripts:

```
bash frosty.sh
```


## Temperatura máxima y mínima media anual

Con es script 
