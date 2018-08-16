#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo rm -rf /var/www/var/log/*

sudo service apache2 restart
sudo service mysql restart
