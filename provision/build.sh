#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo rm -rf /var/www/var/log/*

npm install

sudo chmod -R 0777 /var/www
sudo chown -R www-data:www-data /var/www

sudo service apache2 restart
sudo service mysql restart

sudo service webmin restart
