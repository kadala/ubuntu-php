#!/bin/bash

site=$1
docroot=$2
vconf=/etc/apache2/sites-available/$site.conf

echo "<VirtualHost *:80>" >> $vconf
echo "DocumentRoot \"$docroot\"" >> $vconf
echo "DirectoryIndex app.php" >> $vconf
echo "ServerName $site" >> $vconf
echo "<Directory \"$docroot\">" >> $vconf
echo "AllowOverride All" >> $vconf
echo "Allow from All" >> $vconf
echo "Require all granted" >> $vconf
echo "</Directory>" >> $vconf
echo "</VirtualHost>" >> $vconf

echo "127.0.0.1 $site" >> /etc/hosts

a2ensite $site.conf
/etc/init.d/apache2 restart
