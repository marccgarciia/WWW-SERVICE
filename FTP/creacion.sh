#!/bin/bash
#12/05/2022
#ASIX2
#ALEJANDRO LAY VELASCO
#CREACIÓN DE USUARIOS FTP Y ASIGNACIÓN DE CARPETA RAIZ

while IFS=, read col1 col2
do
    nombre=${col1}
    password=${col2}

    groupadd $nombre #CREA UN GRUPO PERSONAL
    useradd $nombre -g $nombre -d /var/www/$nombre.com -p $(mkpasswd $password) #CREA EL USUARIO, LO AÑADE AL GRUPO CREADO ANTERIORMENTE E INDICA SU RUTA ENJAULADA 

done < csv.csv


#######################################################