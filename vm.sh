#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo add-apt-repository "deb http://download.webmin.com/download/repository sarge contrib"

wget http://www.webmin.com/jcameron-key.asc

sudo apt-key add jcameron-key.asc

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y apache2 debconf-utils swapspace unzip zip

echo "ServerName localhost" >> /etc/apache2/apache2
sudo a2enmod rewrite
sudo a2dissite 000-default.conf

sudo cat << EOF > /etc/apache2/sites-available/000-default.conf
  <VirtualHost *:80>
    DocumentRoot /var/www/public
    ServerName localhost
    <Directory /var/www/public>
      AllowOverride All
      Require all granted
      <IfModule mod_rewrite.c>
        Options -MultiViews
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php [QSA,L]
      </IfModule>
    </Directory>
    ErrorLog /var/www/var/log/error.log
    CustomLog /var/www/var/log/access.log combined
  </VirtualHost>
EOF

sudo a2ensite 000-default.conf
sudo ufw allow in "Apache Full"

sudo mkdir -p /var/www/public
sudo mkdir -p /var/www/var/log

sudo mv /var/www/html/index.html /var/www/public/index.php

sudo rm -rf /var/www/html

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password pass"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password pass"

sudo apt-get install -y mysql-server

sudo mysql -uroot -ppass << EOF
  CREATE DATABASE IF NOT EXISTS development;
EOF

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password pass"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password pass"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password pass"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

sudo apt-get install -y nodejs
sudo apt-get install -y php libapache2-mod-php
sudo apt-get install -y phpmyadmin
sudo apt-get install -y apt-transport-https webmin

sudo iptables -A INPUT -p tcp -m tcp --dport 10000 -j ACCEPT

sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

sudo chmod -R 0777 /var/www
sudo chown -R www-data:www-data /var/www

sudo service mysql restart
sudo service apache2 restart

sudo apt-get autoremove -y --purge
