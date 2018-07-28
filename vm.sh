#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y apache2 debconf-utils swapspace unzip zip

echo "ServerName localhost" >> /etc/apache2/apache2
sudo a2enmod rewrite
sudo a2dissite 000-default.conf

sudo cat << EOF > /etc/apache2/sites-available/000-default.conf
    <VirtualHost *:80>
        DocumentRoot /var/www/html
        ServerName localhost
        <Directory /var/www/html>
            AllowOverride All
            Require all granted
            <IfModule mod_rewrite.c>
                Options -MultiViews
                RewriteEngine On
                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteRule ^(.*)$ index.php [QSA,L]
            </IfModule>
        </Directory>
    </VirtualHost>
EOF

sudo a2ensite 000-default.conf
sudo ufw allow in "Apache Full"

if [ -d /var/www/html ]; then
    sudo mv /var/www/html/index.html /var/www/html/index.php
fi

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

sudo apt-get install -y nodejs php libapache2-mod-php phpmyadmin phpunit
sudo apt-get autoremove -y --purge

sudo chmod -R 0777 /var/www
sudo chown -R www-data:www-data /var/www

sudo service mysql restart
sudo service apache2 restart
