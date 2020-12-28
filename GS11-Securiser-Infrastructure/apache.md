# Editing network configuration

sudo cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
sudo nano /etc/netplan/00-installer-config.yaml
```
# netplan - network configuration

network:
    version: 2
    renderer: networkd
    ethernets:
       ens33:
       dhcp4: no
       addresses: [192.168.101.1/24]
       gateway4: 192.168.101.254
       nameservers:
          addresses: [8.8.4.4,8.8.8.8]
```
sudo netplan try
sudo netplan apply

# A propos d'apache2 HTTPD
La manière dont Apache gère les connexions est définie par les modules MPM. 
Il doit y avoir un et un seul module MPM actif à la fois. Les modules MPM les 
plus courants sous Linux s’appellent “event” (par défaut), “worker” et
“prefork”.

Correctifs de sécurité: 
http://httpd.apache.org/security_report.html

Validation:
```
apache2 -v
#httpd -v
```


# Installation apache2

sudo apt update && upgrade
sudo apt install apache2

sudo systemctl is-active apache2
sudo systemctl is-enabled apache2
sudo systemctl status apache2

root@grub-fix-s:~# systemctl status apache2
● apache2.service - LSB: Apache2 web server
   Loaded: loaded (/etc/init.d/apache2)
  Drop-In: /lib/systemd/system/apache2.service.d
           └─forking.conf
   Active: active (running) since Tue 2020-12-01 16:24:40 EET; 2min 45s ago
   CGroup: /system.slice/apache2.service
           ├─2179 /usr/sbin/apache2 -k start
           ├─2182 /usr/sbin/apache2 -k start
           └─2183 /usr/sbin/apache2 -k start

## Server management
sudo systemctl stop apache2
sudo systemctl start apache2
sudo systemctl restart apache2
sudo systemctl reload apache2
sudo systemctl disable apache2
sudo systemctl enable apache2

## Configuration files
ls /etc/apache2/

stduser@linux-server-1:/etc/apache2$ ls -lah
total 92K
drwxr-xr-x  8 root root 4.0K Dec  1 14:45 .
drwxr-xr-x 93 root root 4.0K Dec  1 14:46 ..
-rw-r--r--  1 root root 7.1K Aug 12 19:46 apache2.conf
drwxr-xr-x  2 root root 4.0K Dec  1 14:45 conf-available
drwxr-xr-x  2 root root 4.0K Nov 21 20:07 conf-enabled
-rw-r--r--  1 root root 1.8K Apr 13  2020 envvars
-rw-r--r--  1 root root  31K Apr 13  2020 magic
drwxr-xr-x  2 root root  16K Dec  1 14:45 mods-available
drwxr-xr-x  2 root root 4.0K Nov 21 20:07 mods-enabled
-rw-r--r--  1 root root  320 Apr 13  2020 ports.conf
drwxr-xr-x  2 root root 4.0K Dec  1 14:45 sites-available
drwxr-xr-x  2 root root 4.0K Nov 21 20:07 sites-enabled


## Virtual Host

Apache est capable de gérer plusieurs sites web sur la même machine, 
c’est ce qu’on appelle des hôtes virtuels ou virtual hosts. 

Création d'un fichier dédié:
sudo nano /etc/apache2/sites-available/01-www.monbeaureseau.com.conf 

```  
<VirtualHost *:80>
	# Hôte utilisé, 1 ServerName / VirtualHost
	ServerName www.monbeaureseau.com
	# Alias, plusieurs possibles
	ServerAlias monbeaureseau.com mbr.com                                                                         
	ServerAdmin webmaster@example.com
	DocumentRoot /var/www/html/www.monbeaureseau.com

	# Enregistrer les logs au format `combined` dans un fichier séparé
	CustomLog ${APACHE_LOG_DIR}/www.monbeaureseau.com-access.log combined
	# Enregistrer les logs d'erreur dans un fichier séparé, même format
	ErrorLog ${APACHE_LOG_DIR}/www.monbeaureseau.com-error.log
	
	<Directory /var/www/html/www.monbeaureseau.com>
		# ExecCGI, FollowSymlinks, Includes, Indexes
		Options All
		# Pas de surcharge avec le fichier .htaccess
		AllowOverride None
	</Directory>
</VirtualHost>
```

- renomage du VH par défaut
```
sudo mv 000-default.conf 000-default.conf.old
```

## Création de la racine
```
sudo mkdir /var/www/html/www.monbeaureseau.com/
sudo cp /var/www/html/index.html /var/www/html/www.monbeaureseau.com/
```

- renommage du fichier index par défaut
sudo mv index.html index.html.old

## Activation du VirtualHost
- Création du lien symbolique de site-enabled vers site-available

```
sudo a2ensite 01-www.monbeaureseau.com
# sudo a2dissite 01-www.monbeaureseau.com
# sudo a2enmod 01-www.monbeaureseau.com
# sudo a2dismod 01-www.monbeaureseau.com
```

- désactivation de la configuration par défaut
sudo a2dissite 000-default.conf

## Activation de la nouvelle configuration

```
sudo systemctl reload apache2
```


# Utilisateur root, www-data et webadmin

## Reminders

### Understanding users files

/etc/passwd
[username]:[x]:[UID]:[GID]:[Comment]:[Home directory]:[Default shell]

/etc/group
[Group name]:[Group password]:[GID]:[Group members]


### usermod options
usermod [option] username
usermod username [option]
    -c = We can add comment field for the useraccount.
    -d = To modify the directory for any existing user account.
    -e = Using this option we can make the account expiry in specific period.
    -g = Change the primary group for a User.
    -G = To add a supplementary groups.
    -a = To add anyone of the group to a secondary group.
    -l = To change the login name from tecmint to tecmint_admin.
    -L = To lock the user account. This will lock the password so we can’t use the account.
    -m = moving the contents of the home directory from existing home dir to new dir.
    -p = To Use un-encrypted password for the new password. (NOT Secured).
    -s = Create a Specified shell for new accounts.
    -u = Used to Assigned UID for the user account between 0 to 999.
    -U = To unlock the user accounts. This will remove the password lock and allow us to use the user account.

### File and directory permissions

	   u   g   o  (a) => User Group Others All
File: rwx --- ---
	  read : read a file (in read only mode)
	  write : modifiy a file
	  execute : execute a file
	  s	=> special
	  
Directory: rwx
    r: required to use a command such as ls to view the files contained in a directory.
    w: allows the user to create, delete, or modify any files or subdirectories, even if the file or subdirectory is owned by another user.
    x: required for a user to cd into a directory.
	   Execute-only permission allows a user to access the files in a directory as long as the user knows the names of the files in the directory, and the user is allowed to read the files.


## Config désirée

- Création de l'utilisateur webadmin et ajout au groupe www-data.
```
sudo useradd webadmin -g www-data -d /var/www
sudo passwd webadmin
```

- Passer webadmin en propriétaire du root directory /var/www.
```
# drwx -R /var/www et -rwx
sudo chown -R webadmin:www-data /var/www
```

- www-data que lire et exécuter dans /var/www
sudo su
find /var/www -type d | xargs chmod 750 # drwx r-x ---
find /var/www -type f | xargs chmod 650 # -rw- r-x ---
exit

Pour la suite, nous devons attacher des droits pour l'utilisateur www-data à des dossiers et fichiers géré par l'utilisateur root.
Cette fois ci, il n'est pas prudent de changer le propriétaire des dit fichiers, ni d'ajouter des droits exessifs aux autres utilisateurs, c'est pourquoi nous utiliserons des ACL.

sudo apt-get install acl

```
# setfacl /var/log/apache2
# getfacl /var/log/apache2
# tune2fs -l /var/log/apache2
```

- www-data pourra lire et modifier les fichiers dans /var/log, mais pas exécuter.
setfacl -m "u:www-data:rw-" /var/log/apache2/
sudo setfacl -m "u:www-data:rw-" /var/log/apache2/*

- www-data pourra lire et exécuter les fichiers dans le répertoire /etc/apache2
sudo setfacl -Rm "u:www-data:r-x" /etc/apache2

On peut également utiliser les ACL pour s'assurer que tout fichier crée correspond a la politique de permissions:
en permettant aux fichiers et répertoire d'hériter les ACL.
```
sudo setfacl -dm "entry" /path/to/dir
```

### Vérification
```
stduser@linux-server-1:~$ getfacl /etc/apache2
getfacl: Removing leading '/' from absolute path names
# file: etc/apache2
# owner: root
# group: root
user::rwx
user:www-data:r-x
group::r-x
mask::r-x
other::r-x

stduser@linux-server-1:~$ getfacl /etc/apache2/apache2.conf
getfacl: Removing leading '/' from absolute path names
# file: etc/apache2/apache2.conf
# owner: root
# group: root
user::rw-
user:www-data:r-x
group::r--
mask::r-x
other::r--
```

# Durcissement & Réduction de la surface d'attaque

## Configuration d'apache2 httpd

/etc/apache2/apache2.conf

- utilisateur et groupe utilisé par apache
```
User ${APACHE_RUN_USER}
Group ${APACHE_RUN_GROUP}
```
la valeur réelle est définie à part dans le fichier `envvars`

sudo nano /etc/apache2/envvars
```
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
```

## Restriction des modules actifs

Validation
```
ls -lah /etc/apache2/mods-enabled
ls /etc/apache2/mods-enabled | grep -Ec ".load$" 
ls /etc/apache2/mods-enabled | grep -E ".load$" | wc -w

# anciennement
grep -Ec "^LoadModule" /etc/apache2/apache2.conf
```

## Restriction des privilèges
Utilisation d'un utilisateur dédié non privilégié pour l'execution d'Apache.
```
groupadd apache
useradd apache -g apache -d /dev/null -s /sbin/nologin
```

Validation:
```
sudo cat /etc/passwd
sudo cat /etc/group
```

## Suppression des fichiers inutiles

Vider le contenue des répertoire manual, cgi-bin et htdocs
```
if `pwd` == /usr/local/apache2
rm -fR manual
rm -fR cgi-bin/*
rm -fR htdocs/*
```

## Limiter les fuites d'informations
sudo nano /etc/apache2/conf-available/security.conf

```
ServerTokens Prod
ServerSignature Off
```

sudo systemctl reload apache2

## Principes de moindre privilège
### Limiter l'accès au strict nécessaire
sudo nano /etc/apache2/apache2.conf

```
<Directory />
  ​Order Deny,Allow
​  Deny from all
​  Options None
​  AllowOverride None
​</Directory>
```

sudo nano /etc/apache2/sites-enabled/01-www.monbeaureseau.com.conf
```
Order Allow,Deny
Allow from all
```

## Limitation de requête HTTP (GET et POST only)


## Permissions sur les répertoires
```
chown -R root:root /usr/local/apache2
find /usr/local/apache2 -type d | xargs chmod 755
find /usr/local/apache2 -type f | xargs chmod 644
chmod -R go-r /usr/local/apache2/conf
chmod -R go-r /usr/local/apache2/logs
```

## Limiter les dépassement de tampons 
LimitRequestBody 64000
LimitRequestFields 32
LimitRequestFieldSize 8000
LimitRequestLine 4000

## Cloisonnement
mkdir -p /chroot/apache2/usr/local
cd /usr/local
mv apache2 /chroot/apache2/usr/local
ln -s /chroot/apache2/usr/local/apache2 #/usr/local


# Durcissement Linux en général

## Cleaning distant access
sudo apt-get --purge remove xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server

## Checking network and open ports
netstat -tulpn

## Disable root login
sudo nano /etc/ssh/sshd_config

## Deny cron
echo ALL >> /etc/cron.deny
sudo nano /etc/cron.deny

## Disable USB stick detection
sudo touch /etc/modprobe.d/no-usb
sudo echo "install usb-storage /bin/true" > /etc/modprobe.d/no-usb
ls /etc/modprobe.d/

## Turn Off IPv6
sudo nano /etc/sysctl.conf
```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.ens33.disable_ipv6 = 1
sudo sysctl -p
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
```

## Lock unused account
sudo passwd -l games
sudo passwd -u games

