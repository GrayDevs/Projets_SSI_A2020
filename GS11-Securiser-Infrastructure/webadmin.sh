#!/bin/bash

#Création de l'utilisateur webadmin et ajout au groupe www-data.
sudo useradd webadmin -g www-data -d /var/www
sudo passwd webadmin

# Passer webadmin en propriétaire du root directory /var/www.
sudo chown -R webadmin:www-data /var/www


# www-data que lire et exécuter dans /var/www
sudo su
find /var/www -type d | xargs chmod 750 # drwx r-x ---
find /var/www -type f | xargs chmod 650 # -rw- r-x ---
exit

# Pour la suite, nous devons attacher des droits pour l'utilisateur www-data à des dossiers et fichiers gérés par l'utilisateur root.
# Nous utiliserons pour cela des ACL.

sudo apt-get install acl

# Utilisation des ACLs
# setfacl /path/to/dir
# getfacl /path/to/dir

# www-data pourra lire et modifier les fichiers dans /var/log, mais pas exécuter.
setfacl -m "u:www-data:rw-" /var/log/apache2/
sudo setfacl -m "u:www-data:rw-" /var/log/apache2/*

# www-data pourra lire et exécuter les fichiers dans le répertoire /etc/apache2
sudo setfacl -Rm "u:www-data:r-x" /etc/apache2

# On peut également utiliser les ACL pour s'assurer que chaque fichier créé correspond a la politique de permissions
# en permettant aux fichiers et répertoire d'hériter les ACL.

# sudo setfacl -dm "entry" /path/to/dir


### Vérifications

# stduser@linux-server-1:~$ getfacl /etc/apache2
# getfacl: Removing leading '/' from absolute path names
# # file: etc/apache2
# # owner: root
# # group: root
# user::rwx
# user:www-data:r-x
# group::r-x
# mask::r-x
# other::r-x

# stduser@linux-server-1:~$ getfacl /etc/apache2/apache2.conf
# getfacl: Removing leading '/' from absolute path names
# # file: etc/apache2/apache2.conf
# # owner: root
# # group: root
# user::rw-
# user:www-data:r-x
# group::r--
# mask::r-x
# other::r--