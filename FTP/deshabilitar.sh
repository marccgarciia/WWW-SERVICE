#!/bin/bash
#24/05/2022
#ASIX2
#ALEJANDRO LAY VELASCO
#ELIMINACIÓN DE USUARIOS FTP Y ASIGNACIÓN DE CARPETA RAIZ

    id=$(whoami)
    contra=$(openssl rand -base64 15) 
    echo "La contraseña de $nombre es $contra" >> /home/password/password.txt
    echo "---------------------------------------" >> /home/password/password.txt

    pass=$(openssl passwd $contra 2>/dev/null)
    usermod -p $pass $nombre