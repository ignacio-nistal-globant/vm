#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo rm -rf /var/www/var/log/*

sudo service apache2 restart
sudo service mysql restart
