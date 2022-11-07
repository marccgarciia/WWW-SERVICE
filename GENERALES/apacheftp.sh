#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Proyecto de ASIX - Marc | Alejandro | Oscar - 2022
opcion=0
while [ $opcion -lt 10 ]
do
  clear
  echo "-------------------------------------------------- "
  echo "Proyecto de ASIX - Marc | Alejandro | Oscar - 2022 "
  echo "-------------------------------------------------- "
  echo "Presiona un numero del 1 al 9: "
  echo "-------------------------------- 1 - CREAR CSV"
  echo "-------------------------------- 2 - CREAR"
  echo "----------------------------------------------------------------------------"
  echo "-------------------------------- 3 - DESHABILITAR"
  echo "-------------------------------- 4 - HABILITAR"
  echo "-------------------------------- 5 - BORRAR"
  echo "----------------------------------------------------------------------------"
  echo "-------------------------------- 6 - INSTALADOR"
  echo "-------------------------------- 7 - DESINSTALADOR"
  echo "----------------------------------------------------------------------------"
  echo "-------------------------------- 8 - MENU - ESTADOS | USERS | GRUPOS | WEBS"
  echo "-------------------------------- 9 - BORRAR TODO EL CURSO"
  echo "-------------------------------- 10 - SALIR"
  echo -n "-------------------------------- ::: "

  read opcion

  case $opcion in

    1)
      read -p "Cuantos usuarios quieres introducir en el csv? " num
      pw=$(pwd)
      
      cont=0
      while [ $num -ge 1 ]
      do
        read -p "Nombre de Usuario: " user
        read -p "Password: " pass

        if [ $cont = 0 ]; then
        echo $user,$pass > $pw/csv.csv
        let cont=cont+1
        ((num--))

        else
        echo $user,$pass >> $pw/csv.csv
        ((num--))

        fi
      done
      read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;

    2)

    echo "------------------------------------"
    echo "Has seleccionado CREAR"
    echo "------------------------------------"
    sleep 1s
    echo "------------------------------------"
    echo "Vamos a proceder a CREAR todo ;)"
    echo "------------------------------------"
    sleep 1s

        while IFS=, read col1 col2  
        do
            nombre=${col1}
            password=${col2}

            ip=$(hostname -I)
            getent passwd $nombre  > /dev/null

            if [ $? -eq 0 ]; then
                echo "No puedes ejecutar estos datos, estos nombres $nombre de usuarios ya existen :( edita el csv y vuelve a probar"


            else
              #----------------------------------------------------------------------------------------------------------------------------------------------------
                  #creacion de carpeta en var
                  mkdir -p /var/www/$nombre.com/html
                  mkdir -p /var/www/$nombre.com/php
                  mkdir -p /var/www/$nombre.com/css
                  touch /var/www/$nombre.com/index.html

                  #CREACION DE USUARIO FTP Y ENJAULADO
                    groupadd $nombre
                    useradd $nombre -g $nombre -d /var/www/$nombre.com -p $(mkpasswd $password)

                    # Jaula usuario 
                    echo "DenyGroups $nombre" >> /etc/ssh/sshd_config


                  echo "Usuario $nombre creado en FTP y enjaulado :)"

                  #permisos
                  chown -R $nombre:$nombre /var/www/$nombre.com  #a revisar con los usuarios de lay

                  chmod -R 775 /var/www/$nombre.com/

                  #meter datos en la configuracion 
                  mkdir /etc/apache2/sites-available/$nombre.conf
                  setfacl --default --modify u::rwx,g::rwx,o::rwx /var/www/$nombre.com
                #sudo openssl req -x509 -nodes -days 1460 -newkey rsa:2048 -keyout /home/daw.key -out /home/daw.crt

                  echo "Directorios del $nombre creado :)"

              #----------------------------------------------------------------------------------------------------------------------------------------------------
                      echo "<VirtualHost *:443>"  >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      ServerAdmin $nombre@gmail.com" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      ServerName $ip" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      ServerAlias www.$nombre.com" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      DocumentRoot /var/www/$nombre.com" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      
                      echo "              " >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      SSLEngine on" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      SSLCertificateFile /home/daw.crt" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      SSLCertificateKeyFile /home/daw.key" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "</VirtualHost>" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf

                      echo "              " >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      ServerName www.$nombre.com" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "      Redirect / https://www.$nombre.com/" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf
                      echo "</VirtualHost>" >> /etc/apache2/sites-available/$nombre.conf/$nombre.conf

                  echo "<html>"  >> /var/www/$nombre.com/index.html
                  echo "     <head>" >> /var/www/$nombre.com/index.html
                  echo "         <title>Web de $nombre</title>" >> /var/www/$nombre.com/index.html
                  echo "     </head>" >> /var/www/$nombre.com/index.html
                  echo "     <body>" >> /var/www/$nombre.com/index.html
                  echo "          <h1>Web de $nombre</h1>" >> /var/www/$nombre.com/index.html
                  echo "     </body>" >> /var/www/$nombre.com/index.html
                  echo "</html>" >> /var/www/$nombre.com/index.html


                  pw=$(pwd)
                  touch $pw/csvfinal.csv
                  echo $nombre,$password>> $pw/csvfinal.csv

                  sleep 1s

                          a2ensite $nombre.conf 2>/dev/null
                      echo "¡Configuracion personal de $nombre en correcto estado y web activada!"
                      echo "--------------------------------------------------------------------------------"
                      echo "$ip www.$nombre.com"  >> /etc/hosts
                  sleep 1s

            fi
            

        done < csv.csv
        #----------------------------------------------------------------------------------------------------------------------------------------------------
            a2dissite 000-default.conf 
            a2enmod ssl 2>/dev/null
            echo "¡SSL activado!"

        #aplicar cambios
        systemctl restart apache2
        systemctl reload apache2
        service ssh restart

        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "---------------------------------Apache reiniciado y finalizado, en correcto funcionamiento, que lo disfrutes :)------------------------------------" 
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "------------------------------------------------------------------ESTADO----------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
            sleep 4s

        systemctl status apache2.service
        systemctl status vsftpd.service
        read -p "Pulse cualquier tecla para continuar!!!" nada

    ;;

    3)
    echo "------------------------------------"
    echo "Has seleccionado DESHABILITAR"  
    echo "------------------------------------"
    sleep 1s
    echo "------------------------------------"
    echo "Vamos a proceder a DESHABILITAR todo ;)"
    echo "------------------------------------"
    sleep 1s
            mkdir /home/password
            touch /home/password/password.txt
        while IFS=, read col1 col2 

        do
          nombre=${col1}
        #----------------------------------------------------------------------------------------------------------------------------------------------------
                    
                    a2dissite $nombre.conf
                    echo "Web de $nombre deshabilitada! :)"
                      
                      id=$(whoami)
                      contra=$(openssl rand -base64 15) 
                      echo "La contraseña de $nombre es $contra" >> /home/password/password.txt
                      echo "---------------------------------------" >> /home/password/password.txt

                      pass=$(openssl passwd $contra 2>/dev/null)
                      usermod -p $pass $nombre
                      echo "Contraseña del Usuario $nombre cambiada!"
                      echo "---------------------------------------"
                    sleep 1s
        done < csv.csv
                      echo "---------------------------------------" >> /home/password/password.txt
                      echo "---------------------------------------" >> /home/password/password.txt
                      echo "---------------------------------------" >> /home/password/password.txt

        #----------------------------------------------------------------------------------------------------------------------------------------------------
        #aplicar cambios
        systemctl restart apache2
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "---------------------------------Apache reiniciado y finalizado, en correcto funcionamiento, que lo disfrutes :)------------------------------------" 
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "------------------------------------------------------------------ESTADO----------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
            sleep 4s

        systemctl status apache2.service
        systemctl status vsftpd.service
        apache2ctl configtest
        read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;

    4)
      echo "------------------------------------"
      echo "Has seleccionado HABILITAR"
      echo "------------------------------------"
      sleep 1s
      echo "------------------------------------"
      echo "Vamos a proceder a habilitar todo ;)"
      echo "------------------------------------"
      sleep 1s

        while IFS=, read col1 col2 
        do
          nombre=${col1}

        #----------------------------------------------------------------------------------------------------------------------------------------------------
                    
                    a2ensite $nombre.conf
                    echo "Web de $nombre habilitada! :)"
                    echo "---------------------------------------"
                    sleep 1s
        done < csv.csv

        systemctl restart apache2

        echo "Apache reiniciado y finalizado, en correcto funcionamiento, sin datos que lo disfrutes :) " 
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "------------------------------------------------------------------ESTADO----------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "----------------------------------------------------------------------------------------------------------------------------------------------------"

        systemctl status apache2.service
        systemctl status vsftpd.service
        read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;

    5)
      read -p "Seguro que quieres borrar? s/n: " sino
      if [ "$sino" == "s" ]
      then
          echo "------------------------------------"
          echo "Has seleccionado BORRAR"
          echo "------------------------------------"
          sleep 1s
          echo "------------------------------------"
          echo "Vamos a proceder a borrar todo ;)"
          echo "------------------------------------"
          sleep 1s

              while IFS=, read col1 col2 
              do
                  nombre=${col1}
              #----------------------------------------------------------------------------------------------------------------------------------------------------
                  #borrar de carpeta en var
                  rm -rf /var/www/$nombre.com 

                #ELIMINACION DE USUARIO DE FTP
                    userdel $nombre 2>/dev/null
                    groupdel $nombre 2>/dev/null
                echo "Grupo $nombre eliminado del FTP"
                echo "Usuario $nombre eliminado del FTP"
                  #borrar datos en la configuracion 
                  rm -rf /etc/apache2/sites-available/$nombre.conf
                  echo "Directorios del  $nombre borrados :)"
              #----------------------------------------------------------------------------------------------------------------------------------------------------
                      rm -rf /etc/apache2/sites-available/$nombre.conf
                      rm -rf /etc/apache2/sites-enabled/$nombre.conf

                      echo "Include /etc/ssh/sshd_config.d/*.conf" > /etc/ssh/sshd_config
                      echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
                      echo "UsePAM yes" >> /etc/ssh/sshd_config
                      echo "X11Forwarding yes" >> /etc/ssh/sshd_config
                      echo "PrintMotd no" >> /etc/ssh/sshd_config
                      echo "AcceptEnv LANG LC_*" >> /etc/ssh/sshd_config
                      echo "Subsystem	sftp	/usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config
                      
                      echo "¡Configuracion personal de $nombre borrado!"
                      echo "------------------------------------------------------" 
                      sleep 1s

              done < csv.csv
              #----------------------------------------------------------------------------------------------------------------------------------------------------
                      #reestablecer fichero /etc/hosts
                      echo "127.0.0.1       localhost" > /etc/hosts
                      echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
                      echo "::1     ip6-localhost ip6-loopback" >> /etc/hosts
                      echo "fe00::0 ip6-localnet" >> /etc/hosts
                      echo "ff00::0 ip6-mcastprefix" >> /etc/hosts
                      echo "ff02::1 ip6-allnodes" >> /etc/hosts
                      echo "ff02::2 ip6-allrouters" >> /etc/hosts
                      echo "¡Fichero /etc/hosts restablecido!"
              #aplicar cambios
              systemctl restart apache2

              echo "Apache reiniciado y finalizado, en correcto funcionamiento, sin datos que lo disfrutes :) " 
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "------------------------------------------------------------------ESTADO----------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"

              systemctl status apache2.service
              systemctl status vsftpd.service
      else

        echo "No se va a borrar nada, ya que te has equivocado!! :)"

      fi
  
    read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;

    6)
    echo "------------------------------------"
    echo "Has seleccionado INSTALAR"
    echo "------------------------------------"
    sleep 1s
    echo "------------------------------------"
    echo "Vamos a proceder a instalar todo ;)"
    echo "------------------------------------"
    sleep 1s

      echo "---------------------------------------Actualizando repositorio---------------------------------------"

      echo "------------------------------------------------------------------------------------------------------"
      echo "SERVIDOR ACTUALIZADO CORRECTAMENTE"

      echo "---------------------------------------Instalando servicio Web----------------------------------------"
      apt-get install -y apache2
      echo "---------------------------------------------APACHE2--------------------------------------------------"
      echo "SERVICIO WEB INSTALADO"


      echo "---------------------------------------Instalando servicio BBDD---------------------------------------"

      echo "-----------------------------------------------MYSQL--------------------------------------------------"
      echo "SERVICIO MYSQL INSTALADO CORRECTAMENTE"

      echo "---------------------------------------Instalando servicio FTP----------------------------------------"
      echo "------------------------------------------------------------------------------------------------------"
      apt-get install -y vsftpd
      echo "SERVICIO FTP INSTALADO CORRECTAMENTE"


      #AÑADIR FICHERO DE FTP CORRECTO PARA EL FUNCIONAMIENTO
          echo "listen=NO" > /etc/vsftpd.conf

          echo "listen_ipv6=YES" >> /etc/vsftpd.conf

          echo "anonymous_enable=NO" >> /etc/vsftpd.conf

          echo "local_enable=YES" >> /etc/vsftpd.conf

          echo "write_enable=YES" >> /etc/vsftpd.conf

          echo "dirmessage_enable=YES" >> /etc/vsftpd.conf

          echo "use_localtime=YES" >> /etc/vsftpd.conf

          echo "xferlog_enable=YES" >> /etc/vsftpd.conf

          echo "connect_from_port_20=YES" >> /etc/vsftpd.conf

          echo "chroot_local_user=YES" >> /etc/vsftpd.conf

          echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf

          echo "pam_service_name=vsftpd" >> /etc/vsftpd.conf

          echo "rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/vsftpd.conf
          echo "rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/vsftpd.conf
          echo "ssl_enable=NO" >> /etc/vsftpd.conf

          echo "utf8_filesystem=YES" >> /etc/vsftpd.conf

          echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf


      #INSTALADOR DE PAQUETE DE CONTRASEÑAS
      apt install -y whois

      #INSTALADOR DE ACL
      sudo apt-get install -y acl

      #INSTALADOR DE MODULO DE PHP
      echo "---------------------------------------Instalando modulo PHP----------------------------------------"
      sudo apt install -y php libapache2-mod-php


      # #CREACION DE COMPOSER. ESTE NOS SERVIRA PARA QUE LOS USUARIOS (ALUMNOS) PUEDAN CREAR LOS ENLACES SIMBOLICOS

      # apt install -y php-cli unzip curl

      # cd ~

      # curl -sS https://getcomposer.org/installer -o composer-setup.php


      # HASH=`curl -sS https://composer.github.io/installer.sig`


      # php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"


      # php composer-setup.php --install-dir=/usr/local/bin --filename=composer
      # echo "---------------------------------------Instalando COMPOSER----------------------------------------"


      #REINICIAR SERVICIOS
      sudo systemctl restart apache2
      /sbin/service vsftpd restart

      #VER ESTADO DE SERVICIOS  
      systemctl status vsftpd.service
      systemctl status apache2.service
      read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;
    
    7)
    echo "------------------------------------"
    echo "Has seleccionado DESINSTALAR"
    echo "------------------------------------"
    sleep 1s
    echo "------------------------------------"
    echo "Vamos a proceder a desinstalar todo ;)"
    echo "------------------------------------"
    sleep 1s

      echo "---------------------------------------Desinstalando servicio Web----------------------------------------"
        sudo apt-get --purge remove -y apache2
      echo "---------------------------------------------APACHE2-----------------------------------------------------"
      echo "SERVICIO WEB DESINSTALADO"


      echo "---------------------------------------Desinstalando servicio BBDD---------------------------------------"

      echo "-----------------------------------------------MYSQL-----------------------------------------------------"
      echo "SERVICIO MYSQL DESINSTALADO CORRECTAMENTE"

      echo "---------------------------------------Desinstalando servicio FTP----------------------------------------"
        sudo apt-get --purge remove -y vsftpd
      echo "-----------------------------------------------FPT-------------------------------------------------------"
      echo "SERVICIO FTP DESINSTALADO CORRECTAMENTE"

      echo "---------------------------------TODO DESINSTALADO CORRECTAMENTE-----------------------------------------"
    read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;

    8)
      clear
      echo "-------------------------------------------------- "
      echo "Menu de la Opcion 8"
      echo "-------------------------------------------------- "
      echo "Presiona un numero del 1 al 4: "
      echo "-------------------------------- 1 - ESTADO DE LOS SERVICIOS"
      echo "-------------------------------- 2 - USUARIOS"
      echo "-------------------------------- 3 - GRUPOS"
      echo "-------------------------------- 4 - WEBS"
      echo "-------------------------------- 5 - SALIR"
      echo -n "-------------------------------- ::: "

      read opcion
      case $opcion in
      1)
        echo "---------------------------------------------------------------------------------------------------------"
        systemctl status vsftpd.service
        echo "---------------------------------------------------------------------------------------------------------"
        systemctl status apache2.service
        echo "---------------------------------------------------------------------------------------------------------"
        systemctl status mysql.service
        echo "---------------------------------------------------------------------------------------------------------"
        read -p "Pulse cualquier tecla para continuar!!!" nada
      ;;
      2)
        echo "---------------------------------------------------------------------------------------------------------"
        cont=0
        while IFS=, read col1   
        do

            let cont=cont+1
            
        done < csv.csv

        tail -n$cont /etc/passwd
        echo "---------------------------------------------------------------------------------------------------------"
        read -p "Pulse cualquier tecla para continuar!!!" nada
      ;;
      3)
        echo "---------------------------------------------------------------------------------------------------------"
        cont=0
        while IFS=, read col1   
        do

            let cont=cont+1
            
        done < csv.csv

        tail -n$cont /etc/group
        echo "---------------------------------------------------------------------------------------------------------"
        read -p "Pulse cualquier tecla para continuar!!!" nada
      ;;
      4)
        echo "---------------------------------------------------------------------------------------------------------"
        ls /etc/apache2/sites-available
        echo "---------------------------------------------------------------------------------------------------------"
        read -p "Pulse cualquier tecla para continuar!!!" nada
      ;;
      *)
        echo "El numero que has seleccionado no es existente por tanto no podemos hacer nada por ti :("
        read -p "Pulse cualquier tecla para continuar!!!" nada
      ;;
      esac

    ;;

    9)

    read -p "Seguro que quieres borrar? s/n: " sino
      if [ "$sino" == "s" ]
      then
          echo "------------------------------------"
          echo "Has seleccionado BORRAR TODO EL CURSO"
          echo "------------------------------------"
          sleep 1s
          echo "------------------------------------"
          echo "Vamos a proceder a borrar todo ;)"
          echo "------------------------------------"
          sleep 1s

              while IFS=, read col1 col2 
              do
                  nombre=${col1}
              #----------------------------------------------------------------------------------------------------------------------------------------------------
                  #borrar de carpeta en var
                  rm -rf /var/www/$nombre.com 

                #ELIMINACION DE USUARIO DE FTP
                    userdel $nombre 2>/dev/null
                    groupdel $nombre 2>/dev/null
                echo "Grupo $nombre eliminado del FTP"
                echo "Usuario $nombre eliminado del FTP"
                  #borrar datos en la configuracion 
                  rm -rf /etc/apache2/sites-available/$nombre.conf
                  echo "Directorios del  $nombre borrados :)"
              #----------------------------------------------------------------------------------------------------------------------------------------------------
                      rm -rf /etc/apache2/sites-available/$nombre.conf
                      rm -rf /etc/apache2/sites-enabled/$nombre.conf

                      echo "Include /etc/ssh/sshd_config.d/*.conf" > /etc/ssh/sshd_config
                      echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
                      echo "UsePAM yes" >> /etc/ssh/sshd_config
                      echo "X11Forwarding yes" >> /etc/ssh/sshd_config
                      echo "PrintMotd no" >> /etc/ssh/sshd_config
                      echo "AcceptEnv LANG LC_*" >> /etc/ssh/sshd_config
                      echo "Subsystem	sftp	/usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config
                      
                      echo "¡Configuracion personal de $nombre borrado!"
                      echo "------------------------------------------------------" 
                      sleep 1s

              done < csvfinal.csv
              #----------------------------------------------------------------------------------------------------------------------------------------------------
                      #reestablecer fichero /etc/hosts
                      echo "127.0.0.1       localhost" > /etc/hosts
                      echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
                      echo "::1     ip6-localhost ip6-loopback" >> /etc/hosts
                      echo "fe00::0 ip6-localnet" >> /etc/hosts
                      echo "ff00::0 ip6-mcastprefix" >> /etc/hosts
                      echo "ff02::1 ip6-allnodes" >> /etc/hosts
                      echo "ff02::2 ip6-allrouters" >> /etc/hosts
                      echo "¡Fichero /etc/hosts restablecido!"
              #aplicar cambios
              systemctl restart apache2
              rm -rf csv.csv
              rm -rf csvfinal.csv

              echo "Apache reiniciado y finalizado, en correcto funcionamiento, sin datos que lo disfrutes :) " 
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "------------------------------------------------------------------ESTADO----------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
              echo "----------------------------------------------------------------------------------------------------------------------------------------------------"

              systemctl status apache2.service
              systemctl status vsftpd.service
      else

        echo "No se va a borrar nada, ya que te has equivocado!! :)"

      fi
  
    read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;

    10)
    exit
    ;;
    
    *)
    echo "El numero que has seleccionado no es existente por tanto no podemos hacer nada por ti :("
    read -p "Pulse cualquier tecla para continuar!!!" nada
    ;;
  esac
done