#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y apache2 debconf-utils swapspace unzip zip

echo "ServerName localhost" >> /etc/apache2/apache2.conf

sudo a2enmod rewrite
sudo a2enmod ssl

sudo a2dissite 000-default.conf
sudo a2dissite default-ssl

sudo cp /var/www/provision/vm/apache.conf /etc/apache2/sites-available/000-default.conf
sudo cp /var/www/provision/vm/apache-ssl.conf /etc/apache2/sites-available/default-ssl.conf

sudo a2ensite 000-default.conf
sudo a2ensite default-ssl

sudo ufw allow in "Apache Full"

if [ -d /var/www/html ]; then
    if [ -f /var/www/html/index.html ]; then
        sudo mv /var/www/html/index.html /var/www/html/index.php
    fi

    sudo mv /var/www/html /var/www/public
fi

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password pass"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password pass"

sudo apt-get install -y mysql-server

sudo mysql -uroot -ppass < /var/www/provision/vm/my.sql

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password pass"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password pass"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password pass"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

sudo apt-get install -y php libapache2-mod-php
sudo apt-get install -y phpmyadmin

sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

sudo apt-get install -y nodejs
sudo apt-get install -y npm

sudo chmod -R 0777 /var/www
sudo chown -R www-data:www-data /var/www

sudo apt-get autoremove -y --purge
