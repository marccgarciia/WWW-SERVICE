# WWW SERVICE 🌍 

© Proyecto de ASIX - Marc | Alejandro | Oscar - 2022

## Introducción 💻

En este proyecto de síntesis se nos pidió que automatizamos en 3 scripts el crear, deshabilitar y eliminar, un conjunto de 3 servicios con sus respectivos usuarios, directorios, conexiones y sus carpetas enjauladas. Os dejamos el enunciado explícitamente copiado de lo que se nos pidió:

### Enunciado

Por el correcto desarrollo del grado de DAW se requiere que durante los proyectos desarrollados por el alumnado se requiere de tres servicios esenciales: Servidor Web con PHP, Servidor de base de datos con MySQL y Servidor FTP para que los alumnos puedan subir sus webs al servidor.
Cada grupo tiene que disponer de su espacio sin que los otros grupos puedan interferir en su faena.

También hace falta que se facilite la creación de estos servicios al profesorado. De tal manera que hace falta crearlos, deshabilitarlos y eliminarlos al final del curso.
Por una correcta portabilidad, se requiere que se instale y se configure en una raspberry.

## Requisitos de Sistema 🔧

Funciona SOLO en máquinas Linux

## Instrucciones de uso 📜

* En caso de tener la máquina limpia y querer crear todo e instalar, es importante que antes de ejecutar el script, se ponga este
comando en el terminal:

```
sudo openssl req -x509 -nodes -days 1460 -newkey rsa:2048 -keyout /home/daw.key -out /home/daw.crt
```

_Si no se ejecuta este comando en el terminal, antes de instalar o ejecutar cualquier cosa del script, no funcionara, básicamente porque este comando genera los certificados del 443, y si no están, la instalación y la ejecución de las opciones será errónea._

---------------------------------------------------------------------------------------------------------------------------------------

* Para poder ejecutar la opción 2 (creación) debes haber ejecutado la opción número 1 que es la de generar un CSV, en él generaras    todos los usuarios.

* El script genera dos CSV's. El "csv.csv" que este siempre contendrá los últimos datos generados por la opción 1 del script, es decir que si ejecutas la opción 5 solo te borrará los datos de este CSV. Y también genera el "csvfinal.csv" este contendrá los datos de todos los CSV que se vayan generando... es decir que si clicas la opción 9 borraras como su nombre dice, todo lo que lleves de curso.

* Es de vital importancia que no borre los archivos CSV porque si estos son borrados no podra volver a borrar nada a no ser que lo haga de manera manual, tampoco se recomienda la manipulacion de los archivos CSV y SH de manera manual ya que estos se generan con una estructura especifica.

* Los certificados se generan en /home y se llaman "daw.key" "daw.crt" es importante no modificar la ruta ya que si no habria que modificar bastantes lineas del script

* Al clicar la opcion 3 de deshabilitar, se deshabulitara todo y se cambiaran las contraseñas de los alumnos por una random para que no puedan modificar ni ver nada, para que el profesor pueda tener acceso a estas passwords, se genera un txt en "/home/password/password.txt" aqui podras ver el nombre de user y su password random.

* En caso de querer volver a habilitar las webs y las passwords comunes, clicando la opcion 4 volveras a activar todo con normalidad siempre y cuando no hayas borrado el archivo "csv.csv".

---------------------------------------------------------------------------------------------------------------------------------------

## Directorios de password y certificados 📂

* Los certificados del SSL se generan en /home y se llaman "daw.key" y "daw.crt"

* Los archivos de usuarios y contraseñas se guardan en el CSV ubicado en la misma carpeta donde se ha ejecutado el script, el CSV tiene nombre de "csv.csv".

* Como el "csv.csv" cambia de datos cada vez que se crean users nuevos, todos los users creados se guardan en el csv con nombre "csvfinal.csv" este es el csv que se utiliza en la opcion 9 "Borrar todo el curso"

* Al deshabilitar se desactiva todo y se cambian las passwords de los usuarios por unas random, estas se guardan en el fichero con nombre "password.txt" y se ubica en /home/password/password.txt


⌨️ con ❤️ por [Alejandro Lay](https://github.com/AlejandroLay), [Oscar Lopez](https://github.com/oscaarlopezz), [Marc Garcia-Cuevas](https://github.com/marccgarciia) 😊


