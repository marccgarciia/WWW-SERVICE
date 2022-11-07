#!/bin/bash
#12/05/2022
#ASIX2
#ALEJANDRO LAY VELASCO
#ELIMINACIÓN DE USUARIOS FTP Y ASIGNACIÓN DE CARPETA RAIZ

while IFS=, read col1
do
    nombre=${col1}

    userdel $nombre

done < csv.csv