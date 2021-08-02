#!/bin/bash

echo "Replacing xdebug.client_host with $XDEBUG_REMOTE_HOST"
sudo sed -ri "s/xdebug\.client_host\s?\=\s?.*/xdebug\.client_host\=$XDEBUG_REMOTE_HOST/g" /etc/php/current/custom/90-xdebug-defaults.ini
#sudo sed -ri "s/xdebug\.client_host\s?\=\s?.*/xdebug\.client_host\=$XDEBUG_REMOTE_HOST/g" /etc/php/current/cli/conf.d/90-xdebug-defaults.ini

echo "Starting default php-fpm"
sudo service php-fpm start

echo "Starting xdebug php-fpm"
sudo chmod +x /etc/init.d/php-fpm-xdebug
sudo service php-fpm-xdebug start

/bin/bash docker-entrypoint.sh # to keep running
