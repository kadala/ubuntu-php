#!/bin/bash

#Install git:
sudo apt-get install git

# Essential packages
# ------------------
apt-get install -y build-essential git-core vim curl

#Install apache/php:
sudo add-apt-repository ppa:ondrej/php5
sudo apt-get update
sudo apt-get install apache2 php5 php5-cli libapache2-mod-php5 php5-dev
# Install useful php modules

sudo apt-get install php5-mcrypt php5-xdebug php5-curl php5-sqlite php5-xsl php-pear php-apc mysql-server  php5-mysql php5-intl acl

#Install phpmyadmin (choose apache2 and enter through password prompts to use default):
sudo apt-get install phpmyadmin
sudo ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin

# Install composer
# ------------------
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# nodejs
sudo apt-get install python-software-properties
sudo apt-add-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs

#grunt
sudo npm install -g grunt-cli

#bower
sudo npm install -g bower

## configuration apache

sudo chown -R www-data:www-data  /var/www
sudo chmod -R g+rw /var/www
## config php apache DEV

php_ini="/etc/php5/apache2/php.ini"

if [ ! -f $php_ini".bak" ]
then
	sudo cp $php_ini $php_ini".bak"
fi

sudo sed -i 's/short_open_tag = On/short_open_tag = Off/g' $php_ini
sudo sed -i 's/memory_limit = \d{1-3}M/memory_limit = 128M/g' $php_ini
sudo sed -i 's/error_reporting = .*/error_reporting = E_ALL | E_STRICT/g' $php_ini
sudo sed -i 's/display_errors = Off/display_errors = On/g' $php_ini
sudo sed -i 's/html_errors = Off/html_errors = On/g' $php_ini
if ! grep -xq "\[xdebug\]" $php_ini
then
	sudo tee -a $php_ini <<XDEBUG
[xdebug]
xdebug.remote_enable=On
xdebug.remote_connect_back=On
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=10.0.0.1
xdebug.remote_port=9000
XDEBUG

fi


## config php cli DEV

php_ini="/etc/php5/cli/php.ini"

if [ ! -f $php_ini".bak" ]
then
	sudo cp $php_ini $php_ini".bak"
fi

sudo sed -i 's/short_open_tag = On/short_open_tag = Off/g' $php_ini
sudo sed -i 's/memory_limit = \d{1-3}M/memory_limit = -1/g' $php_ini
sudo sed -i 's/error_reporting = .*/error_reporting = E_ALL | E_STRICT/g' $php_ini
sudo sed -i 's/display_errors = Off/display_errors = On/g' $php_ini
sudo sed -i 's/html_errors = Off/html_errors = On/g' $php_ini

PHP_TIMEZONE='Europe/Paris'
# Setting the timezone

sed 's#;date.timezone\([[:space:]]*\)=\([[:space:]]*\)*#date.timezone\1=\2\"'"$PHP_TIMEZONE"'\"#g' /etc/php5/cli/php.ini > /etc/php5/cli/php.ini.tmp
mv /etc/php5/cli/php.ini.tmp /etc/php5/cli/php.ini

# Setting xdebug
echo "xdebug.max_nesting_level=200" | sudo tee -a /etc/php5/cli/php.ini

# create the configuration file in the "available" section
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/servername.conf
# enable it by creating a symlink to it from the "enabled" section
sudo a2enconf servername
# restart the server
sudo service apache2 restart

exit 0

